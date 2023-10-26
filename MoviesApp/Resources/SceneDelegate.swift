//
//  SceneDelegate.swift
//  MoviesApp
//
//  Created by anduser on 23.10.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        let moviesListRouter = Router(navigationController: navigationController, networkManager: NetworkService())
        window.rootViewController = navigationController
        moviesListRouter.navigateToMovieList()
        self.window = window
        window.makeKeyAndVisible()
    }

}

