//
//  RequestMovieDetailModel.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import Foundation

struct RequestMovieDetailModel {
    var movieId: Int? = 0
    var apiKey: String? = ""
    
    func getParams() -> [String: Any] {
        var params = [String: Any]()
        params["api_key"] = apiKey
        return params
    }
}
