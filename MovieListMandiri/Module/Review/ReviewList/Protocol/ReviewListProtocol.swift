//
//  ReviewListProtocol.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol ReviewListViewProtocol: AnyObject {
    var presenter: ReviewListPresenterProtocol? { get set }
    var loadingState: BehaviorRelay<LoadingState> { get set }
    var reviewModel: ResponseReviewModel? { get set }
    var reviewResultModel: [ResponseReviewModel.Result]? { get set }
    func didSuccessGetReview(_ model: ResponseReviewModel?)
    func didFailGetReview(message: String?)
    var isLoadmore: Bool { get set }
}

protocol ReviewListPresenterProtocol: AnyObject {
    var view: ReviewListViewProtocol? { get set }
    var interactor: ReviewListInteractorInputProtocol? { get set }
    var router: ReviewListRouterProtocol? { get set }
    func loadMoreReview(request: RequestReviewModel?)
}    

protocol ReviewListInteractorInputProtocol: AnyObject {
    var presenter: ReviewListInteractorOutputProtocol? { get set }
    func getMovieReview(request: RequestReviewModel) -> Observable<ResponseReviewModel?>
}

protocol ReviewListInteractorOutputProtocol: AnyObject{
    func didSuccessGetReview(model: ResponseReviewModel?)
    func didFailGetReview(message: String?)
}

protocol ReviewListRouterProtocol: AnyObject {
    static func createReviewListModule(with model: ResponseReviewModel?) -> UIViewController
}
