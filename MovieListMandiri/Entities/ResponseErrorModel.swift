//
//  ResponseErrorModel.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import Foundation

struct ResponseErrorArrayModel: Codable, Error {
    var errors: [ResponseErrorModel]?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case errors, error
    }
}

struct ResponseErrorModel: Codable, Error {
    var title: String?
    var detail: String?
    var errorImageUrl: String?
    var status: NSNumber?
    var code: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case detail
        case code
    }
}
