//
//  APIUrl.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import Foundation

enum APIUrl {
    case genre(request: RequestGenreModel)
    case movieByGenre(request: RequestMovieByGenreModel)
    case movieDetail(request: RequestMovieDetailModel)
    case getReview(request: RequestReviewModel)
    case getVideo(request: RequestVideoModel)
    case getMovieCast(request: RequestMovieDetailModel)
    
    func apiString() -> String {
        switch self {
        case .genre(let request):
            return "genre/movie/list?\(request.getParams().toQueryString())"
        case .movieByGenre(let request):
            return "discover/movie?\(request.getParams().toQueryString())"
        case .movieDetail(let request):
            return "movie/\(request.movieId ?? 0)?\(request.getParams().toQueryString())"
        case .getReview(let request):
            return "movie/\(request.movieId ?? 0)/reviews?\(request.getParams().toQueryString())"
        case .getVideo(let request):
            return "movie/\(request.movieId ?? 0)/videos?\(request.getParams().toQueryString())"
        case .getMovieCast(let request):
            return "movie/\(request.movieId ?? 0)/credits?\(request.getParams().toQueryString())"
        }
    }
    
    func urlString() -> String {
        return NetworkConfiguration.api(self)
    }
}
