//
//  MovieListInteractor.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import Foundation
import RxSwift

class MovieListInteractor: MovieListInteractorInputProtocol {
    private let remoteData: NetworkProvider
    var presenter: MovieListInteractorOutputProtocol?
    
    init(remoteData: NetworkProvider) {
        self.remoteData = remoteData
    }
    
    func getMovieByGenre(request: RequestMovieByGenreModel) -> Observable<ResponseMovieByGenreModel?> {
        let url = APIUrl.movieByGenre(request: request).urlString()
        return remoteData.get(url: url).flatMap { data -> Observable<ResponseMovieByGenreModel?> in
            do {
                let responseModel = try JSONDecoder().decode(ResponseMovieByGenreModel.self, from: data)
                return Observable.just(responseModel)
            } catch {
                return Observable.error(error)
            }
        }
    }
    
}
