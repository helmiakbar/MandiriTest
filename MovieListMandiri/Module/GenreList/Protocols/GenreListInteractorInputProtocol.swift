//
//  GenreListInteractorInputProtocol.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import RxSwift

protocol GenreListInteractorInputProtocol: AnyObject {
    var presenter: GenreListInteractorOutputProtocol? { get set }
    func getGenreMovie(request: RequestGenreModel) -> Observable<ResponseGenreModel?>
}
