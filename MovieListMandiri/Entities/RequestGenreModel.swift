//
//  RequestGenreModel.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import Foundation

struct RequestGenreModel {
    var apiKey: String? = ""
    
    func getParams() -> [String: Any] {
        var params = [String: Any]()
        params["api_key"] = apiKey
        
        return params
    }
}
