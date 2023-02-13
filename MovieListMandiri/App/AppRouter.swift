//
//  AppRouter.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import UIKit

final class AppRouter {
    let window: UIWindow
    
    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    func launchMainView(){
        let viewController = GenreListRouter.createMainViewModule()
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

}
