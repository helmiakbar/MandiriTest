//
//  ReviewListPresenter.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import RxSwift
import RxCocoa

final class ReviewListPresenter: ReviewListPresenterProtocol {
    weak var view: ReviewListViewProtocol?
    var interactor: ReviewListInteractorInputProtocol?
    var router: ReviewListRouterProtocol?
    private let disposeBag = DisposeBag()
    
    func loadMoreReview(request: RequestReviewModel?){
        guard let request = request else {
            return
        }
        self.view?.loadingState.accept(.loading)
        interactor?.getMovieReview(request: request)
            .subscribe(onNext: { [weak self] responseModel in
                guard let self = self else { return }
                self.didSuccessGetReview(model: responseModel)
                self.view?.loadingState.accept(.finished)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.didFailGetReview(message: error.localizedDescription)
                self.view?.loadingState.accept(.failed)
            }).disposed(by: disposeBag)
    }
}

extension ReviewListPresenter: ReviewListInteractorOutputProtocol {
    func didSuccessGetReview(model: ResponseReviewModel?) {
        self.view?.didSuccessGetReview(model)
    }
    
    func didFailGetReview(message: String?) {
        self.view?.didFailGetReview(message: message)
    }
}
