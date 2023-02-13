//
//  RequestReviewModel.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import Foundation

struct RequestReviewModel {
    var movieId: Int? = 0
    var apiKey: String? = ""
    var page: Int? = 1
    
    func getParams() -> [String: Any] {
        var params = [String: Any]()
        params["api_key"] = apiKey
        params["page"] = page
        return params
    }
}
