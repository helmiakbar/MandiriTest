//
//  MovieListPresenter.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import RxSwift
import RxCocoa

final class MovieListPresenter: MovieListPresenterProtocol {
    weak var view: MovieListViewProtocol?
    var interactor: MovieListInteractorInputProtocol?
    var router: MovieListRouterProtocol?
    private let disposeBag = DisposeBag()

    func getMovieByGenre(request: RequestMovieByGenreModel) {
        self.view?.loadingState.accept(.loading)
        interactor?.getMovieByGenre(request: request)
        .subscribe(onNext: { [weak self] responseModel in
            guard let self = self else { return }
            self.didSuccessGetMovie(model: responseModel)
            self.view?.loadingState.accept(.finished)
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.didFailGetMovie(message: error.localizedDescription)
            self.view?.loadingState.accept(.failed)
        }).disposed(by: disposeBag)
    }
    
    func goToMovieDetail(model: ResponseMovieByGenreModel.Result) {
        guard let view = view else { return }
        router?.presentMovieDetail(from: view, for: model)
    }
}

extension MovieListPresenter: MovieListInteractorOutputProtocol {
    func didSuccessGetMovie(model: ResponseMovieByGenreModel?) {
        view?.didSuccess(model)
    }
    
    func didFailGetMovie(message: String?) {
        view?.didFail(message: message)
    }
}
