//
//  ReviewListInteractor.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import Foundation
import RxSwift

class ReviewListInteractor: ReviewListInteractorInputProtocol {
    private let remoteData: NetworkProvider
    var presenter: ReviewListInteractorOutputProtocol?
    
    init(remoteData: NetworkProvider) {
        self.remoteData = remoteData
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
}
