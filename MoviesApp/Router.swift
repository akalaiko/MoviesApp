//
//  Router.swift
//  MoviesApp
//
//  Created by anduser on 23.10.2023.
//

import UIKit

protocol RouterProtocol {
    func navigateToMovieList()
    func navigateToMovieDetails(movieID: Int)
}

final class Router: RouterProtocol {
    private let navigationController: UINavigationController
    private let networkManager: NetworkServiceProtocol
    
    init(navigationController: UINavigationController, networkManager: NetworkServiceProtocol) {
        self.navigationController = navigationController
        self.networkManager = networkManager
    }

    func navigateToMovieList() {
        let view = MoviesListView()
        let presenter = MoviesListPresenterImpl(view: view, router: self, networkManager: networkManager)
        view.presenter = presenter
        navigationController.pushViewController(view, animated: true)
    }

    func navigateToMovieDetails(movieID: Int) {
        let view = MovieDetailsView(id: movieID)
        let presenter = MovieDetailsPresenter(view: view,router: self, networkManager: networkManager)
        view.presenter = presenter
        navigationController.pushViewController(view, animated: true)
    }
}
