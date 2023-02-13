//
//  CastListRouter.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit

class CastListRouter: CastListRouterProtocol {
    static func createCastListModule(with model: ResponseCreditModel?) -> UIViewController {
        let view = CastListViewController.loadFromNib()
        view.model = model
        return view
    }
}
