//
//  ReviewListRouter.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit

class ReviewListRouter: ReviewListRouterProtocol {
    static func createReviewListModule(with model: ResponseReviewModel?) -> UIViewController {
        let view = ReviewListViewController.loadFromNib()
        let presenter = ReviewListPresenter()
        let interactor = ReviewListInteractor(remoteData: NetworkProvider())
        let router = ReviewListRouter()
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        view.reviewModel = model
        return view
    }
}
