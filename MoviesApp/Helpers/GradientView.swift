//
//  GradientView.swift
//  MoviesApp
//
//  Created by anduser on 23.10.2023.
//

import UIKit

final class GradientView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let gradientLayer = self.layer as? CAGradientLayer {
            gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
            gradientLayer.locations = [0.0, 0.5, 1.0]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
    }
}

