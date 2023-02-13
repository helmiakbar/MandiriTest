//
//  GenreListInteractor.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import RxSwift

class GenreListInteractor: GenreListInteractorInputProtocol {
    private let remoteData: NetworkProvider
    var presenter: GenreListInteractorOutputProtocol?
    
    init(remoteData: NetworkProvider) {
        self.remoteData = remoteData
    }

    func getGenreMovie(request: RequestGenreModel) -> Observable<ResponseGenreModel?> {
        let url = APIUrl.genre(request: request).urlString()
        return remoteData.get(url: url).flatMap { data -> Observable<ResponseGenreModel?> in
            do {
                let responseModel = try JSONDecoder().decode(ResponseGenreModel.self, from: data)
                return Observable.just(responseModel)
            } catch {
                return Observable.error(error)
            }
        }
    }
}
