//
//  ViewController.swift
//  MoviesApp
//
//  Created by anduser on 23.10.2023.
//

import Reachability
import UIKit

protocol MoviesListViewProtocol: AnyObject {
    func showMovies(_ movies: [Movie])
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showError(_ error: Error)
    func backupMovies()
}

final class MoviesListView: UIViewController, MoviesListViewProtocol {
    
    // MARK: - Properties
    
    var presenter: MoviesListPresenter?
    
    private var currentSort: SortStyle = .descending
    private var movies = [Movie]() {
        didSet {
            emptyStateLabel.isHidden = !movies.isEmpty
        }
    }
    private var moviesBackup = [Movie]()
    private var page = 1
    private var isOffline = false
    private var reachability: Reachability?
    
    // MARK: - UI Elements
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: Constants.ImageNames.sort), style: .plain, target: nil, action: nil)
        button.tintColor = .label
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSizes.medium)
        label.numberOfLines = Constants.Common.numberOfLinesLimited
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.noDataForDisplay
        return label
    }()
    
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        tableView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        listenForNetworkChanges()
        presenter?.fetchMovies(page: page, sorting: currentSort)
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        title = Strings.popularMoviesTitle
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = sortButton
        definesPresentationContext = true
        
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchBar.delegate = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseIdentifier)
        
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .label
        
        sortButton.target = self
        sortButton.action = #selector(showSortOptions)
    }
    
    // MARK: - UI Actions
    
    @objc private func refreshMovies() {
        refreshControl.endRefreshing()
        setToDefaults()
        presenter?.fetchMovies(page: page, sorting: currentSort)
    }
    
    @objc private func showSortOptions() {
        guard !isOffline else {
            showOfflineAlert()
            return
        }
        let actionSheet = UIAlertController(title: Strings.sortByRating, message: nil, preferredStyle: .actionSheet)
        for option in SortStyle.allCases {
            let action = UIAlertAction(title: currentSort == option ? "‣ " + option.name : option.name, style: .default) { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.currentSort = option
                strongSelf.setToDefaults()
                strongSelf.presenter?.fetchMovies(page: strongSelf.page, sorting: strongSelf.currentSort)
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(title: Strings.cancel, style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        if let reachability = note.object as? Reachability {
            if reachability.connection == .unavailable {
                isOffline = true
                showOfflineAlert()
            } else {
                if isOffline {
                    isOffline = false
                    refreshMovies()
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func listenForNetworkChanges() {
        reachability = try? Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        try? reachability?.startNotifier()
        
        if reachability?.connection == .unavailable {
            isOffline = true
            showOfflineAlert()
        }
    }
    
    func backupMovies() {
        moviesBackup = movies
    }
    
    func showMovies(_ movies: [Movie]) {
        self.movies += movies
        tableView.reloadData()
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
    
    private func showOfflineAlert() {
        let alertController = UIAlertController(title: Strings.offlineAlertTitle,
                                                message: Strings.offlineAlertMessage,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Strings.okButton, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func setToDefaults() {
        movies.removeAll()
        page = 1
    }
    
    deinit {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
}

extension MoviesListView: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell else { fatalError() }
        cell.prepareForReuse()
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.width * 2 / 3
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard !isOffline else {
            showOfflineAlert()
            return
        }
        if let id = movies[indexPath.row].id {
            presenter?.didSelectMovie(id)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSection = tableView.numberOfSections - 1
        let lastRowInSection = tableView.numberOfRows(inSection: lastSection) - 3
        
        if indexPath.section == lastSection && indexPath.row == lastRowInSection {
            guard !isOffline else {
                showOfflineAlert()
                return
            }
            page += 1
            if let text = searchController.searchBar.text, !text.isEmpty {
                presenter?.searchForMovie(name: text, page: page)
            } else {
                presenter?.fetchMovies(page: page, sorting: currentSort)
            }
        }
    }
}

extension MoviesListView: UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !isOffline else {
            guard let text = searchController.searchBar.text, !text.isEmpty else {
                setToDefaults()
                movies = moviesBackup
                tableView.reloadData()
                return
            }
            movies = moviesBackup.filter({ movie in
                if let title = movie.title?.lowercased() {
                    return title.contains(text.lowercased())
                } else {
                    return false
                }
            })
            tableView.reloadData()
            return
        }
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            setToDefaults()
            presenter?.fetchMovies(page: page, sorting: currentSort)
            return
        }
        setToDefaults()
        presenter?.searchForMovie(name: text, page: page)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard !isOffline else {
            setToDefaults()
            movies = moviesBackup
            tableView.reloadData()
            return
        }
        setToDefaults()
        presenter?.fetchMovies(page: page, sorting: currentSort)
    }
}
