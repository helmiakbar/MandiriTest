//
//  ResponseCreditModel.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import Foundation

struct ResponseCreditModel: Codable {
    let id: Int?
    let cast: [Cast]?
    
    struct Cast: Codable {
        let gender: Int?
        let id: Int?
        let name: String?
        let character: String?
        let profile_path: String?
    }
}
