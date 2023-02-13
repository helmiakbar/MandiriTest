//
//  MovieDetailProtocols.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol MovieDetailViewProtocol: AnyObject {
    var presenter: MovieDetailPresenterProtocol? { get set }
    var loadingState: BehaviorRelay<LoadingState> { get set }
    var model: ResponseMovieByGenreModel.Result? { get set }
    var request: RequestMovieDetailModel? { get set }
    var requestReview: RequestReviewModel? { get set }

    var detailModel: ResponseMovieDetailModel? { get set }
    var reviewModel: ResponseReviewModel? { get set }
    
    var requestVideo: RequestVideoModel? { get set }
    var videoModel: ResponseVideoModel? { get set}

    func didSuccess(_ model: ResponseMovieDetailModel?)
    func didFail(message: String?)
    func didSuccessGetReview(_ model: ResponseReviewModel?)
    func didFailGetReview(message: String?)
    func didSuccessGetVideo(_ model: ResponseVideoModel?)
    func didFailGetVideo(message: String?)
    func didSuccessGetCredit(_ model: ResponseCreditModel?)
    func didFailGetCredit(message: String?)
}

protocol MovieDetailPresenterProtocol: AnyObject {
    var view: MovieDetailViewProtocol? { get set }
    var interactor: MovieDetailInteractorInputProtocol? { get set }
    var router: MovieDetailRouterProtocol? { get set }
    func getMovieDetail(request: RequestMovieDetailModel?)
    func goToReviewList(model: ResponseReviewModel)
    func goToCastList(model: ResponseCreditModel)
}

protocol MovieDetailInteractorInputProtocol: AnyObject {
    var presenter: MovieDetailInteractorOutputProtocol? { get set }
    func getMovieDetail(request: RequestMovieDetailModel) -> Observable<ResponseMovieDetailModel?>
    func getMovieReview(request: RequestReviewModel) -> Observable<ResponseReviewModel?>
    func getMovieVideo(request: RequestVideoModel) -> Observable<ResponseVideoModel?>
    func getMovieCredit(request: RequestMovieDetailModel) -> Observable<ResponseCreditModel?>
}

protocol MovieDetailInteractorOutputProtocol: AnyObject{
    func didSuccessGetMovie(model: ResponseMovieDetailModel?)
    func didSuccessGetReview(model: ResponseReviewModel?)
    func didSuccessGetVideo(model: ResponseVideoModel?)
    func didSuccessGetCredit(model: ResponseCreditModel?)
    func didFailGetReview(message: String?)
    func didFailGetMovie(message: String?)
    func didFailGetVideo(message: String?)
    func didFailGetCredit(message: String?)
}

protocol MovieDetailRouterProtocol: AnyObject {
    static func createMovieDetailModule(with model: ResponseMovieByGenreModel.Result?) -> UIViewController
    func presentReviewList(from view: MovieDetailViewProtocol, for model: ResponseReviewModel?)
    func presentCastList(from view: MovieDetailViewProtocol, for model: ResponseCreditModel?)
}
