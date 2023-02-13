//
//  ReviewListViewController.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit
import RxCocoa
import RxSwift
import FloatingPanel

class ReviewListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: ReviewListPresenterProtocol?
    var loadingState = BehaviorRelay<LoadingState>(value: .notLoad)
    var request: RequestReviewModel?
    var reviewModel: ResponseReviewModel?
    var reviewResultModel: [ResponseReviewModel.Result]?
    private let disposeBag = DisposeBag()
    var isLoadmore: Bool = false {
        didSet {
            if self.isLoadmore {
                guard let page = request?.page else { return }
                self.request?.page = page + 1
                self.presenter?.loadMoreReview(request: request)
            }
        }
    }
    
    private var readMoreArticleFPC: FloatingPanelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Review List"
        configureTableView()
        
        if let validModal = reviewModel {
            reviewResultModel = validModal.results
        }
        bindView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: String(describing: ReviewListTableViewCell.self), bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: String(describing: ReviewListTableViewCell.self))
    }
    
    private func bindView() {
        if let model = reviewModel {
            request = RequestReviewModel(movieId: model.id, apiKey: NetworkConfiguration.apiKey)
        }
        self.loadingState.asObservable().observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading, .notLoad:
                    break
                case .finished, .failed:
                    DispatchQueue.main.async {[weak self] in
                        guard let self = self else { return }
                        self.tableView.hideLoadingFooter()
                        self.tableView.reloadData()
                    }
                    break
                }
            }).disposed(by: disposeBag)
    }
}

extension ReviewListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewResultModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReviewListTableViewCell.self)) as? ReviewListTableViewCell {
            if let validModel = reviewResultModel {
                cell.configureCellData(validModel[indexPath.row])
                cell.delegate = self
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let model = reviewResultModel, let total = reviewModel?.totalResults {
            let lastElement = model.count - 1
            let count = model.count
            if indexPath.row == lastElement {
                if !self.isLoadmore && count > 0 {
                    if count < total {
                        tableView.showLoadingFooter()
                        self.isLoadmore = true
                    }
                }
            }
        }
    }
}

extension ReviewListViewController: ReviewListViewProtocol {
    func didSuccessGetReview(_ model: ResponseReviewModel?) {
        guard let result = model?.results else { return }
        for data in result {
            self.reviewResultModel?.append(data)
        }
        isLoadmore = false
    }
    
    func didFailGetReview(message: String?) {
        self.showError(title: "Error", message: message ?? "")
    }
}

extension ReviewListViewController: ReviewListTableCellDelegate {
    func didTapMore(data: ResponseReviewModel.Result?) {
        readMoreArticleFPC = FloatingPanelControllerHelper.createFloatingPanelController()
        readMoreArticleFPC?.delegate = self
        
        guard let fpc = readMoreArticleFPC else {
            return
        }
        
        let reviewVC = ReviewDetailViewController.loadFromNib()
        reviewVC.reviewerData = data
        
        fpc.set(contentViewController: reviewVC)
        present(fpc, animated: true, completion: nil)
    }
}

extension ReviewListViewController: FloatingPanelControllerDelegate {
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return FixedHeightLayout(height: UIScreen.main.bounds.height / 1.3)
    }
    
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        if fpc.isAttracting == false {
            let loc = fpc.surfaceLocation
            let minY = fpc.surfaceLocation(for: .full).y - 6.0
            let maxY = fpc.surfaceLocation(for: .tip).y + 6.0
            fpc.surfaceLocation = CGPoint(x: loc.x, y: min(max(loc.y, minY), maxY))
        }
    }
}

