//
//  MovieDetailed.swift
//  MoviesApp
//
//  Created by anduser on 24.10.2023.
//

import Foundation

// MARK: - MovieDetailed
struct MovieDetailed: Codable {
    let backdropPath: String?
    let genres: [Genre]?
    let id: Int?
    let overview: String?
    let posterPath: String?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genres
        case id
        case overview
        case posterPath = "poster_path"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case video
        case title
        case voteAverage = "vote_average"
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

