//
//  CastListProtocol.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit

protocol CastListRouterProtocol: AnyObject {
    static func createCastListModule(with model: ResponseCreditModel?) -> UIViewController
}
