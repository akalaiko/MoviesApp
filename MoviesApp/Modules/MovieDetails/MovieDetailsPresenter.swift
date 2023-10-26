//
//  MovieDetailsPresenter.swift
//  MoviesApp
//
//  Created by anduser on 23.10.2023.
//

import Foundation

protocol MovieDetailsPresenterProtocol {
    var trailerKey: String? { get set }
    func viewDidLoad(with id: Int)
}

final class MovieDetailsPresenter: MovieDetailsPresenterProtocol {
    
    // MARK: - Properties

    private weak var view: MovieDetailsViewProtocol?
    private let router: RouterProtocol?
    private var networkManager: NetworkServiceProtocol?
    
    var trailerKey: String?
    
    // MARK: - Initialization

    required init(view: MovieDetailsViewProtocol?, router: RouterProtocol?, networkManager: NetworkServiceProtocol?) {
        self.view = view
        self.router = router
        self.networkManager = networkManager
    }
    
    // MARK: - MovieDetailsPresenterProtocol

    func viewDidLoad(with id: Int) {
        fetchMovieDetails(for: id)
    }
    
    // MARK: - Private Methods

    private func fetchMovieDetails(for id: Int) {
        view?.showLoadingIndicator()
        
        networkManager?.fetchDetailsOfMovie(id: id) { [weak self] movie, error in
            DispatchQueue.main.async {
                self?.view?.hideLoadingIndicator()
                if let error = error {
                    self?.view?.showError(error)
                } else if let movie {
                    self?.view?.showMovieDetails(movie)
                    self?.networkManager?.fetchMovieTrailerURL(movieID: id) { key, error in
                        if error != nil {
                            self?.view?.shouldShowTrailerButton(false)
                        } else if let key {
                            self?.trailerKey = key
                            self?.view?.shouldShowTrailerButton(true)
                        }
                    }
                }
            }
        }
    }
}


