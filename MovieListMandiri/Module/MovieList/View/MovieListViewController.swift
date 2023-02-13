//
//  MovieListViewController.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

class MovieListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    var presenter: MovieListPresenterProtocol?
    var loadingState = BehaviorRelay<LoadingState>(value: .notLoad)
    var genreModel: ResponseGenreModel.Genre?
    var movieListModel: ResponseMovieByGenreModel?
    var request: RequestMovieByGenreModel?
    var movieListResultModel: [ResponseMovieByGenreModel.Result]?
    var isLoadmore: Bool = false {
        didSet {
            if self.isLoadmore {
                guard let page = request?.page else {
                    return
                }
                self.request?.page = page + 1
                if let request = request {
                    self.presenter?.getMovieByGenre(request: request)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Movie List"
        setupCollectionView()
        bindView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nibName = UINib(nibName: String(describing: MovieListCollectionViewCell.self), bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: String(describing: MovieListCollectionViewCell.self))
    }
    
    private func bindView(){
        if let model = genreModel {
            request = RequestMovieByGenreModel(withGenres: model.id, apiKey: NetworkConfiguration.apiKey)
            if let request = request {
                presenter?.getMovieByGenre(request: request)
            }
        }
        self.loadingState.asObservable().observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading, .notLoad,  .failed:
                    if self.request?.page == 1 {
                        self.collectionView.showAnimatedSkeleton()
                    }
                case .finished:
                    DispatchQueue.main.async {[weak self] in
                        guard let self = self else { return }
                        self.collectionView.hideSkeleton()
                        self.collectionView.reloadData()
                    }
                    break
                }
            }).disposed(by: disposeBag)
    }

}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieListResultModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionViewCell", for: indexPath) as? MovieListCollectionViewCell {
            if let validModel = movieListResultModel {
                cell.configureCellData(model: validModel[indexPath.row])
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = movieListResultModel {
            presenter?.goToMovieDetail(model: model[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: 168)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let model = movieListResultModel, let total = movieListModel?.totalResults {
            let lastElement = model.count - 1
            let count = model.count
            if indexPath.row == lastElement {
                if !self.isLoadmore && count > 0 {
                    if count < total {
                        self.isLoadmore = true
                    }
                }
            }
        }
    }
}

extension MovieListViewController: SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: MovieListCollectionViewCell.self)
    }
}

extension MovieListViewController: MovieListViewProtocol {
    func didSuccess(_ model: ResponseMovieByGenreModel?) {
        if isLoadmore == false {
            movieListModel = model
            movieListResultModel = model?.results
        } else {
            guard let result = model?.results else { return }
            for data in result {
                movieListResultModel?.append(data)
            }
            isLoadmore = false
        }
    }
    
    func didFail(message: String?) {
        self.showError(title: "error", message: message ?? "")
    }
}
