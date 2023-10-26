//
//  Video.swift
//  MoviesApp
//
//  Created by anduser on 25.10.2023.
//

import Foundation

struct MovieVideosResponse: Decodable {
    let results: [Video]
}

struct Video: Decodable {
    let site: String
    let type: String
    let key: String
}
