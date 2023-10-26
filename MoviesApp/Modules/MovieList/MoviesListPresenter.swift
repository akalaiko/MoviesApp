//
//  MoviesListPresenter.swift
//  MoviesApp
//
//  Created by anduser on 23.10.2023.
//

import UIKit

protocol MoviesListPresenter {
    func fetchMovies(page: Int, sorting: SortStyle)
    func didSelectMovie(_ id: Int)
    func searchForMovie(name: String, page: Int)
}

final class MoviesListPresenterImpl: MoviesListPresenter {
    
    // MARK: - Properties
    
    private weak var view: MoviesListViewProtocol?
    private let router: RouterProtocol?
    private var networkManager: NetworkServiceProtocol?

    // MARK: - Initialization
    
    required init(view: MoviesListViewProtocol, router: RouterProtocol?, networkManager: NetworkServiceProtocol?) {
        self.view = view
        self.router = router
        self.networkManager = networkManager
    }

    // MARK: - MoviesListPresenter Methods

    func didSelectMovie(_ id: Int) {
        router?.navigateToMovieDetails(movieID: id)
    }
    
    func searchForMovie(name: String, page: Int) {
        view?.showLoadingIndicator()
        networkManager?.searchForMovie(name: name, page: page) { [weak self] movies, error in
            DispatchQueue.main.async {
                self?.view?.hideLoadingIndicator()
                if let error = error {
                    self?.view?.showError(error)
                } else if let movies = movies {
                    self?.view?.showMovies(movies)
                }
            }
        }
    }
    
    func fetchMovies(page: Int, sorting: SortStyle) {
        view?.showLoadingIndicator()
        networkManager?.fetchMovies(page: page, sorting: sorting) { [weak self] movies, error in
            DispatchQueue.main.async {
                self?.view?.hideLoadingIndicator()
                if let error = error {
                    self?.view?.showError(error)
                } else if let movies = movies {
                    self?.view?.showMovies(movies)
                    self?.view?.backupMovies()
                }
            }
        }
    }
}

