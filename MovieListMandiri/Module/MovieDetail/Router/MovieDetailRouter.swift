//
//  MovieDetailRouter.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit

class MovieDetailRouter: MovieDetailRouterProtocol {
    static func createMovieDetailModule(with model: ResponseMovieByGenreModel.Result?) -> UIViewController {
        let view = MovieDetailViewController.loadFromNib()
        let presenter = MovieDetailPresenter()
        let interactor = MovieDetailInteractor(remoteData: NetworkProvider())
        let router = MovieDetailRouter()
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        view.model = model
        return view
    }
    
    func presentReviewList(from view: MovieDetailViewProtocol, for model: ResponseReviewModel?) {
        let goToReviewList = ReviewListRouter.createReviewListModule(with: model)
        guard let viewVC = view as? UIViewController else {
            fatalError("Invalid View Protocol type")
        }
        viewVC.navigationController?.pushViewController(goToReviewList, animated: true)
    }
    
    func presentCastList(from view: MovieDetailViewProtocol, for model: ResponseCreditModel?) {
        let goToCastList = CastListRouter.createCastListModule(with: model)
        guard let viewVC = view as? UIViewController else {
            fatalError("Invalid View Protocol type")
        }
        viewVC.navigationController?.pushViewController(goToCastList, animated: true)
    }
}
