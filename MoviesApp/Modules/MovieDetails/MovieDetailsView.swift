//
//  MovieDetailsViewController.swift
//  MoviesApp
//
//  Created by anduser on 23.10.2023.
//

import UIKit

protocol MovieDetailsViewProtocol: AnyObject {
    func showMovieDetails(_ movie: MovieDetailed)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func shouldShowTrailerButton(_ videoExists: Bool)
    func showError(_ error: Error)
}

final class MovieDetailsView: UIViewController, MovieDetailsViewProtocol {
    
    // MARK: - Properties
    
    var presenter: MovieDetailsPresenterProtocol?
    private var id: Int
    private var movie: MovieDetailed?
    
    // MARK: - Initialization
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.Paddings.mPadding
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let moviePosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.ImageNames.noImage)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSizes.xLarge)
        label.numberOfLines = Constants.Common.numberOfLinesLimited
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.movieNameNotSpecified
        return label
    }()

    private let movieCountryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSizes.small)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.countryNotSpecified
        return label
    }()

    private let movieGenresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSizes.medium)
        label.numberOfLines = Constants.Common.numberOfLinesLimited
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.genresNotSpecified
        return label
    }()

    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let videoIconButton: UIButton = {
        let videoIconButton = UIButton(type: .system)
        videoIconButton.setImage(UIImage(systemName: Constants.ImageNames.trailer), for: .normal)
        videoIconButton.contentMode = .scaleAspectFit
        videoIconButton.tintColor = videoIconButton.isEnabled ? .label : .secondaryLabel
        videoIconButton.translatesAutoresizingMaskIntoConstraints = false
        return videoIconButton
    }()

    private let spacerView: UIView = {
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return spacerView
    }()
    
    private let movieRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSizes.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSizes.medium)
        label.numberOfLines = Constants.Common.numberOfLinesUnlimited
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.noOverview
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad(with: id)
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(moviePosterImageView)
        stackView.addArrangedSubview(movieNameLabel)
        stackView.addArrangedSubview(movieCountryLabel)
        stackView.addArrangedSubview(movieGenresLabel)
        stackView.addArrangedSubview(ratingStackView)
        stackView.addArrangedSubview(movieDescriptionLabel)

        ratingStackView.addArrangedSubview(videoIconButton)
        ratingStackView.addArrangedSubview(spacerView)
        ratingStackView.addArrangedSubview(movieRatingLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            moviePosterImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            moviePosterImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            moviePosterImageView.heightAnchor.constraint(equalTo: moviePosterImageView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: Constants.Paddings.mPadding),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Constants.Paddings.mPadding),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Constants.Paddings.mPadding),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Constants.Paddings.mPadding),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -Constants.Paddings.xlPadding),
            
            ratingStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            videoIconButton.heightAnchor.constraint(equalToConstant: Constants.Paddings.xlPadding),
            videoIconButton.widthAnchor.constraint(equalToConstant: Constants.Paddings.xlPadding)
        ])
        
        stackView.setCustomSpacing(Constants.Common.customSpacing, after: movieCountryLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.backButtonDisplayMode = .minimal
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(posterTapped))
        moviePosterImageView.addGestureRecognizer(tapGestureRecognizer)
        
        videoIconButton.addTarget(self, action: #selector(trailerTapped), for: .touchUpInside)
    }

    // MARK: - MovieDetailsViewProtocol

    func showMovieDetails(_ movie: MovieDetailed) {
        self.movie = movie
        if let title = movie.title {
            self.title = title
            movieNameLabel.text = title
        }
        
        if let productionCountries = movie.productionCountries, !productionCountries.isEmpty {
            var countries = [String]()
            productionCountries.forEach({ country in
                countries.append(country.name)
            })
            movieCountryLabel.text = countries.joined(separator: ", ")
        }
        
        if let releaseDate = movie.releaseDate, !releaseDate.isEmpty {
            let countries = movieCountryLabel.text ?? ""
            movieCountryLabel.text = countries + ", " + releaseDate.prefix(4)
        }
        
        if let genres = movie.genres, !genres.isEmpty {
            var genresList = [String]()
            genres.forEach({ genre in
                genresList.append(genre.name)
            })
            movieGenresLabel.text = genresList.joined(separator: ", ")
        }
        
        if let voteAverage = movie.voteAverage {
            movieRatingLabel.text = Strings.rating + ": \(voteAverage)"
        }

        if let posterPath = movie.posterPath, let posterURL = URL(string: Constants.URLs.largePicturePath + posterPath) {
            moviePosterImageView.sd_setImage(with: posterURL, completed: nil)
        } else {
            if let backdropPath = movie.backdropPath, let posterURL = URL(string: Constants.URLs.smallPicturePath + backdropPath) {
                moviePosterImageView.sd_setImage(with: posterURL, completed: nil)
            }
        }
        
        if let overview = movie.overview, !overview.isEmpty {
            movieDescriptionLabel.text = overview
        }
        view.setNeedsLayout()
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showError(_ error: Error) {
        let alertController = UIAlertController(title: Strings.errorTitle, message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Strings.okButton, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func shouldShowTrailerButton(_ videoExists: Bool) {
        videoIconButton.isEnabled = videoExists
    }
    
    @objc private func posterTapped() {
        if let posterPath = movie?.posterPath {
            let view = PosterViewController(path: posterPath)
            present(view, animated: true)
        }
    }
    
    @objc private func trailerTapped() {
        guard let trailerKey = presenter?.trailerKey else { return }
        let view = TrailerPlayer(videoId: trailerKey)
        present(view, animated: true)
    }
}



