//
//  MovieListProtocols.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol MovieListViewProtocol: AnyObject {
    var presenter: MovieListPresenterProtocol? { get set }
    var loadingState: BehaviorRelay<LoadingState> { get set }
    func didSuccess(_ model: ResponseMovieByGenreModel?)
    func didFail(message: String?)
}

protocol MovieListPresenterProtocol: AnyObject {
    
    var view: MovieListViewProtocol? { get set }
    var interactor: MovieListInteractorInputProtocol? { get set }
    var router: MovieListRouterProtocol? { get set }
    
    func getMovieByGenre(request: RequestMovieByGenreModel)
    func goToMovieDetail(model: ResponseMovieByGenreModel.Result)
}

protocol MovieListInteractorInputProtocol: AnyObject {
    var presenter: MovieListInteractorOutputProtocol? { get set }
    func getMovieByGenre(request: RequestMovieByGenreModel) -> Observable<ResponseMovieByGenreModel?>
}

protocol MovieListInteractorOutputProtocol: AnyObject{
    func didSuccessGetMovie(model: ResponseMovieByGenreModel?)
    func didFailGetMovie(message: String?)
}

protocol MovieListRouterProtocol: AnyObject {
    static func createMovieListModule(with model: ResponseGenreModel.Genre?) -> UIViewController
    func presentMovieDetail(from view: MovieListViewProtocol, for model: ResponseMovieByGenreModel.Result?)
}
