//
//  MovieListRouter.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit

class MovieListRouter: MovieListRouterProtocol {
    static func createMovieListModule(with model: ResponseGenreModel.Genre?) -> UIViewController {
        let view = MovieListViewController.loadFromNib()
        
        let presenter = MovieListPresenter()
        let interactor = MovieListInteractor(remoteData: NetworkProvider())
        let router = MovieListRouter()
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        view.genreModel = model
        return view
    }
    
    func presentMovieDetail(from view: MovieListViewProtocol, for model: ResponseMovieByGenreModel.Result?) {
        let goToMovieDetail = MovieDetailRouter.createMovieDetailModule(with: model)
        guard let viewVC = view as? UIViewController else {
            fatalError("Invalid View Protocol type")
        }
        viewVC.navigationController?.pushViewController(goToMovieDetail, animated: true)
    }
}
