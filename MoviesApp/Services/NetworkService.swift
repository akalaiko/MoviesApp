//
//  NetworkService.swift
//  MoviesApp
//
//  Created by anduser on 23.10.2023.
//

import Alamofire
import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func fetchMovies(page: Int, sorting: SortStyle, completion: @escaping ([Movie]?, Error?) -> Void)
    func fetchDetailsOfMovie(id: Int, completion: @escaping (MovieDetailed?, Error?) -> Void)
    func searchForMovie(name: String, page: Int, completion: @escaping ([Movie]?, Error?) -> Void)
    func fetchMovieTrailerURL(movieID: Int, completion: @escaping (String?, Error?) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    private let headers: HTTPHeaders = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjNjJkNTM3ZjYyODYyNzNhZmYyMzA2NWYyN2JiMDkyYSIsInN1YiI6IjY1MzY0ZTM5YzhhNWFjMDEzOWFiYWEyOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.zsrwpmv1OSa13lBmjnHVVwD4VeQ9OlOYmBNy3eSGAXM"
    ]
    
    func fetchMovies(page: Int, sorting: SortStyle, completion: @escaping ([Movie]?, Error?) -> Void) {
        
        let urlString = "https://api.themoviedb.org/3/discover/movie"
        var sortParam = ""
        switch sorting {
        case .ascending:
            sortParam = "popularity.asc"
        case .descending:
            sortParam = "popularity.desc"
        }
        
        let parameters: Parameters = [
            "language": "en-US",
            "page": page,
            "sort_by": sortParam
        ]
        
        AF.request(urlString, method: .get, parameters: parameters, headers: headers).validate().responseDecodable(of: MoviesListResponse.self) { response in
            switch response.result {
            case .success(let moviesListResponse):
                let movies = moviesListResponse.results
                completion(movies, nil)
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
    }
    
    func fetchDetailsOfMovie(id: Int, completion: @escaping (MovieDetailed?, Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(id)"
        let parameters: [String: Any] = [
            "language": "en-US"
        ]
        
        AF.request(urlString, method: .get, parameters: parameters, headers: headers).validate().responseDecodable(of: MovieDetailed.self) { response in
            switch response.result {
            case .success(let movieDetailed):
                completion(movieDetailed, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func searchForMovie(name: String, page: Int, completion: @escaping ([Movie]?, Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/search/movie"
        let parameters: Parameters = [
            "query": name,
            "language": "en-US",
            "page": page
        ]
        
        AF.request(urlString, method: .get, parameters: parameters, headers: headers).validate().responseDecodable(of: MoviesListResponse.self) { response in
            switch response.result {
            case .success(let moviesListResponse):
                let movies = moviesListResponse.results
                completion(movies, nil)
            case .failure(let error):
                print(error)
                completion(nil, error)
            }
        }
    }
    
    func fetchMovieTrailerURL(movieID: Int, completion: @escaping (String?, Error?) -> Void) {
      
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)/videos"
        
        AF.request(urlString, method: .get, headers: headers).validate().responseDecodable(of: MovieVideosResponse.self) { response in
            switch response.result {
            case .success(let videosResponse):
                if let trailerKey = videosResponse.results.first(where: { $0.site.lowercased() == "youtube" && $0.type.lowercased() == "trailer" })?.key {
                    completion(trailerKey, nil)
                } else {
                    completion(nil, NSError(domain: "MoviesApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Trailer not found."]))
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
