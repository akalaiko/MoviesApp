//
//  Constants.swift
//  MoviesApp
//
//  Created by anduser on 25.10.2023.
//

import Foundation

enum Constants {
    
    enum Common {
        static let cornerRadius: CGFloat = 16
        static let shadowRadius: CGFloat = 8
        static let shadowOpacity: Float = 0.3
        static let yearPrefix: Int = 4
        static let customSpacing: CGFloat = 8
        static let numberOfLinesLimited: Int = 3
        static let numberOfLinesUnlimited: Int = 0
        
        static let minZoomScale: CGFloat = 1.0
        static let maxZoomScale: CGFloat = 3.0
    }
    
    enum FontSizes {
        static let xSmall: CGFloat = 12
        static let small: CGFloat = 14
        static let medium: CGFloat = 16
        static let large: CGFloat = 20
        static let xLarge: CGFloat = 24
    }
    
    enum ImageNames {
        static let sort: String = "arrow.up.arrow.down"
        static let noImage: String = "noImage"
        static let trailer: String = "play.rectangle.fill"
    }
    
    enum Paddings {
        static let sPadding: CGFloat = 8
        static let mPadding: CGFloat = 16
        static let lPadding: CGFloat = 24
        static let xlPadding: CGFloat = 32
    }
    
    enum ReuseIdentifiers {
        static let movieCell: String = "MovieCell"
    }
    
    enum URLs {
        static let largePicturePath: String = "https://image.tmdb.org/t/p/w1280"
        static let smallPicturePath: String = "https://image.tmdb.org/t/p/w300"
    }
}
