//
//  MovieCell.swift
//  MoviesApp
//
//  Created by anduser on 23.10.2023.
//

import SDWebImage
import UIKit

final class MovieCell: UITableViewCell {
    
    // MARK: - Constants and Reuse Identifiers
    static let reuseIdentifier = Constants.ReuseIdentifiers.movieCell
    
    // MARK: - UI Elements
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.Common.cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let shadowView: UIView = {
        let shadowView = UIView()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.layer.cornerRadius = Constants.Common.cornerRadius
        shadowView.backgroundColor = .black
        
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.label.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowRadius = Constants.Common.shadowRadius
        shadowView.layer.shadowOpacity = Constants.Common.shadowOpacity
        return shadowView
    }()
    
    private let gradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.layer.cornerRadius = Constants.Common.cornerRadius
        gradientView.clipsToBounds = true
        return gradientView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSizes.xLarge)
        label.numberOfLines = 3
        label.textColor = .white
        return label
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSizes.small)
        label.numberOfLines = 3
        label.textColor = .white
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSizes.large)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(shadowView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genresLabel)
        contentView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Paddings.mPadding),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Paddings.mPadding),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Paddings.sPadding),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Paddings.sPadding),
            
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Paddings.mPadding),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Paddings.mPadding),
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Paddings.sPadding),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Paddings.sPadding),
            
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Paddings.mPadding),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Paddings.mPadding),
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Paddings.sPadding),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Paddings.sPadding),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Paddings.xlPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Paddings.xlPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Paddings.xlPadding),
            
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Paddings.xlPadding),
            ratingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Paddings.lPadding),
            
            genresLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genresLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: Constants.Paddings.xlPadding),
            genresLabel.bottomAnchor.constraint(equalTo: ratingLabel.bottomAnchor)
        ])
    }
    
    // MARK: - Cell Configuration
    func configure(with movie: Movie) {
        if let title = movie.title {
            titleLabel.text = title
        }
        if let releaseDate = movie.releaseDate, !releaseDate.isEmpty {
            let title = titleLabel.text ?? ""
            titleLabel.text = title + ", " + releaseDate.prefix(Constants.Common.yearPrefix)
        }
        
        genresLabel.text = movie.genres
        
        if let voteAverage = movie.voteAverage {
            ratingLabel.text = "★ \(voteAverage)"
        }
        
        if let backdropPath = movie.backdropPath, let posterURL = URL(string: Constants.URLs.largePicturePath + backdropPath) {
            posterImageView.sd_setImage(with: posterURL, completed: nil)
        } else {
            if let posterPath = movie.posterPath, let posterURL = URL(string: Constants.URLs.smallPicturePath + posterPath) {
                posterImageView.sd_setImage(with: posterURL, completed: nil)
            }
        }
    }
    
    // MARK: - Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = ""
        genresLabel.text = ""
        ratingLabel.text = ""
    }
}



