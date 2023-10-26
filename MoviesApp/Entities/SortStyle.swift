//
//  SortStyle.swift
//  MoviesApp
//
//  Created by anduser on 25.10.2023.
//

import Foundation

enum SortStyle: String, CaseIterable {
    case ascending = "Ascending"
    case descending = "Descending"
    
    var name: String {
        switch self {
        case .ascending:
            return Strings.ascending
        case .descending:
            return Strings.descending
        }
    }
}
