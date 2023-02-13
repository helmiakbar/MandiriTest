//
//  RequestVideoModel.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import Foundation

struct RequestVideoModel {
    var movieId: Int? = 0
    var apiKey: String? = ""
    
    func getParams() -> [String: Any] {
        var params = [String: Any]()
        params["api_key"] = apiKey
        return params
    }
}
