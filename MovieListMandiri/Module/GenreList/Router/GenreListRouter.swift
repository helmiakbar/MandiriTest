//
//  GenreListRouter.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import UIKit

class GenreListRouter: GenreListRouterProtocol {
    static func createMainViewModule() -> UIViewController {
        let view = GenreListViewController.loadFromNib()
        let presenter = GenreListPresenter()
        
        let interactor = GenreListInteractor(remoteData: NetworkProvider())
        let router = GenreListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
    
    func presentMovieByGenre(from view: GenreListProtocol, for model: ResponseGenreModel.Genre?) {
        let goToMovieListByGenre = MovieListRouter.createMovieListModule(with: model)
        guard let viewVC = view as? UIViewController else {
            fatalError("Invalid View Protocol type")
        }
        viewVC.navigationController?.pushViewController(goToMovieListByGenre, animated: true)
    }
}
