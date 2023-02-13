//
//  MovieDetailInteractor.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import Foundation
import RxSwift

class MovieDetailInteractor: MovieDetailInteractorInputProtocol {
    private let remoteData: NetworkProvider
    var presenter: MovieDetailInteractorOutputProtocol?
    
    init(remoteData: NetworkProvider) {
        self.remoteData = remoteData
    }
    
    func getMovieDetail(request: RequestMovieDetailModel) -> Observable<ResponseMovieDetailModel?> {
        let url = APIUrl.movieDetail(request: request).urlString()
        return remoteData.get(url: url).flatMap { data -> Observable<ResponseMovieDetailModel?> in
            do {
                let responseModel = try JSONDecoder().decode(ResponseMovieDetailModel.self, from: data)
                return Observable.just(responseModel)
            } catch {
                return Observable.error(error)
            }
        }
    }
    
    func getMovieReview(request: RequestReviewModel) -> Observable<ResponseReviewModel?> {
        let url = APIUrl.getReview(request: request).urlString()
        return remoteData.get(url: url).flatMap { data -> Observable<ResponseReviewModel?> in
            do {
                let responseModel = try JSONDecoder().decode(ResponseReviewModel.self, from: data)
                return Observable.just(responseModel)
            } catch {
                return Observable.error(error)
            }
        }
    }
    
    func getMovieVideo(request: RequestVideoModel) -> Observable<ResponseVideoModel?> {
        let url = APIUrl.getVideo(request: request).urlString()
        return remoteData.get(url: url).flatMap { data -> Observable<ResponseVideoModel?> in
            do {
                let responseModel = try JSONDecoder().decode(ResponseVideoModel.self, from: data)
                return Observable.just(responseModel)
            } catch {
                return Observable.error(error)
            }
        }
    }
    
    func getMovieCredit(request: RequestMovieDetailModel) -> Observable<ResponseCreditModel?> {
        let url = APIUrl.getMovieCast(request: request).urlString()
        return remoteData.get(url: url).flatMap { data -> Observable<ResponseCreditModel?> in
            do {
                let responseModel = try JSONDecoder().decode(ResponseCreditModel.self, from: data)
                return Observable.just(responseModel)
            } catch {
                return Observable.error(error)
            }
        }
    }
}
