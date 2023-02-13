//
//  GenreListPresenter.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import RxSwift
import RxCocoa

final class GenreListPresenter: GenreListPresenterProtocol {
    weak var view: GenreListProtocol?
    var interactor: GenreListInteractorInputProtocol?
    var router: GenreListRouterProtocol?
    private let disposeBag = DisposeBag()

    func showMovieByGenre(model: ResponseGenreModel.Genre?){
        guard let view = view else { return }
        router?.presentMovieByGenre(from: view, for: model)
    }
    
    func getGenreMovie(request: RequestGenreModel) {
        view?.loadingState.accept(.loading)
        interactor?.getGenreMovie(request: request)
        .subscribe(onNext: { [weak self] responseModel in
            guard let self = self else { return }
            self.didSuccessGetGenre(model: responseModel)
            self.view?.loadingState.accept(.finished)
        }, onError: { [weak self] error in
            guard let self = self else { return }
            let errorModel = error as? ResponseErrorModel
            self.didFailGetGenre(message: errorModel?.detail ?? "")
            self.view?.loadingState.accept(.failed)
        }).disposed(by: disposeBag)
    }
}

extension GenreListPresenter: GenreListInteractorOutputProtocol {
    func didSuccessGetGenre(model: ResponseGenreModel?){
        self.view?.showGenreMovie(model)
    }
    
    func didFailGetGenre(message: String) {
        self.view?.showErrorMessage(message: message)
    }
}
