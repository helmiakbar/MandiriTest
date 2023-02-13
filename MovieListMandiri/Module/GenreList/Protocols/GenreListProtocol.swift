//
//  GenreListProtocol.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol GenreListProtocol: AnyObject {
    var presenter: GenreListPresenterProtocol? { get set }
    func showGenreMovie(_ model: ResponseGenreModel?)
    func showErrorMessage(message: String)
    var loadingState: BehaviorRelay<LoadingState> { get set }
}

protocol GenreListPresenterProtocol: AnyObject {
    
    var view: GenreListProtocol? { get set }
    var interactor: GenreListInteractorInputProtocol? { get set }
    var router: GenreListRouterProtocol? { get set }

    func getGenreMovie(request: RequestGenreModel)
    func showMovieByGenre(model: ResponseGenreModel.Genre?)
}

protocol GenreListInteractorOutputProtocol: AnyObject{
    func didSuccessGetGenre(model: ResponseGenreModel?)
    func didFailGetGenre(message: String)
}

protocol GenreListRouterProtocol: AnyObject {
    static func createMainViewModule() -> UIViewController
    func presentMovieByGenre(from view: GenreListProtocol, for model: ResponseGenreModel.Genre?)
}
