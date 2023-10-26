//
//  Movie.swift
//  MoviesApp
//
//  Created by anduser on 23.10.2023.
//

import Foundation

struct MoviesListResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let posterPath: String?
    let releaseDate, title: String?
    let voteAverage: Double?
    var genres: String {
        return getGenres()
    }
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id, title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    private func getGenres() -> String {
        guard let genreIDS else { return "" }
        var genres = ""
        genreIDS.forEach({genreId in
            if let genreName = MovieGenre(rawValue: genreId)?.name {
                if !genres.isEmpty { genres.append(", ")}
                genres.append(genreName)
            }
        })
        return genres
    }
}

extension Movie: Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
         return lhs.id == rhs.id
     }
}
