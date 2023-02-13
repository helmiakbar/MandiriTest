//
//  ResponseGenreModel.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import Foundation

struct ResponseGenreModel: Codable {
    let genres: [Genre]?
    
    struct Genre: Codable {
        let id: Int?
        let name: String?
    }
}
