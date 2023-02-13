//
//  GenreListViewController.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

class GenreListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: GenreListPresenterProtocol?
    var loadingState = BehaviorRelay<LoadingState>(value: .notLoad)
    var model: ResponseGenreModel? = nil {
        didSet {
            DispatchQueue.main.async {
                self.setupSkeloton()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        configureTableView()
        setupSkeloton()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupSkeloton() {
        switch loadingState.value {
        case .notLoad, .loading, .failed:
            tableView.showAnimatedSkeleton()
        case .finished:
            tableView.hideSkeleton()
            tableView.reloadData()
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: String(describing: GenreListTableViewCell.self), bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: String(describing: GenreListTableViewCell.self))
    }
    
    private func bindViewModel() {
        presenter?.getGenreMovie(request: RequestGenreModel(apiKey: NetworkConfiguration.apiKey))
    }
}

extension GenreListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.genres?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GenreListTableViewCell.self)) as? GenreListTableViewCell {
            if let validModel = model {
                cell.configureDataCell(model: validModel.genres?[indexPath.row])
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let genre = model {
            presenter?.showMovieByGenre(model: genre.genres?[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension GenreListViewController: GenreListProtocol {
    func showGenreMovie(_ model: ResponseGenreModel?) {
        self.model = model
    }
    
    func showErrorMessage(message: String) {
        DispatchQueue.main.async {
            self.showError(title: "Error", message: message)
        }
        
    }
}

extension GenreListViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: GenreListTableViewCell.self)
    }
}
