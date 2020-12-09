//
//  MoviesViewController.swift
//  Prospera
//
//  Created by Assaf Tayouri on 08/12/2020.
//

import UIKit

// View Controller that responsible for presenting the movies that searched
class MoviesViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet private weak var moviesTableView: UITableView!
    @IBOutlet private weak var noMoviesStack: UIStackView!
    
    private lazy var moviesSearchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.isHidden = true
        return spinner
    }()
    
    private var movies: [Movie] = [] {
        didSet {
            updateUI()
        }
    }
    
    private var searchBarInputBoundTimer: Timer?
    
    // MARK:- View Controller Life-Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupMoviesSearchController()
    }
    
    // MARK:- Methods
    private func setupViews() {
        setupMoviesTableView()
        setupSpinnerView()
        setupNoMoviesStack()
    }
    
    private func setupMoviesSearchController() {
        navigationItem.searchController = moviesSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
        moviesSearchController.hidesNavigationBarDuringPresentation = true
        moviesSearchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setupMoviesTableView() {
        moviesTableView.tableFooterView = UIView()
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        moviesTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        moviesTableView.isHidden = true
    }
    
    private func setupSpinnerView() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        spinner.isHidden = true
    }
    
    private func setupNoMoviesStack() {
        noMoviesStack.isHidden = false
    }
    
    private func startSpinner() {
        moviesTableView.isHidden = true
        noMoviesStack.isHidden = true
        spinner.startAnimating()
        spinner.isHidden = false
    }
    
    private func stopSpinner() {
        moviesTableView.isHidden = false
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    
    private func updateUI() {
        stopSpinner()
        if !movies.isEmpty {
            noMoviesStack.isHidden = true
            moviesTableView.isHidden = false
        } else {
            noMoviesStack.isHidden = false
            moviesTableView.isHidden = true
        }
        moviesTableView.reloadData()
        loadViewIfNeeded()
    }
    
    private func searchMovies(for searchStr: String, completion: @escaping ([Movie]?) -> Void) {
        MovieService.shared.fetchMoviesBy(searchStr: searchStr, completion: completion)
    }
    
    private func pick(movie: Movie) {
        showOverlayAlertWithSpinner {
            MovieService.shared.fetchMovieBy(movieId: movie.movieId) { [weak self] informativeMovie in
                DispatchQueue.main.async {
                    self?.dismisssOverlayAlertWithSpinner {
                        guard let informativeMovie = informativeMovie else {
                            return
                        }
                        
                        self?.pushToMovieDetails(with: informativeMovie)
                    }
                }
            }
        }
    }
    
    private func pushToMovieDetails(with informativeMovie: InformativeMovie) {
        let movieDetailsViewController = initStoryboardViewController(with: MovieDetailsViewController.identifier) as! MovieDetailsViewController
        
        movieDetailsViewController.informativeMovie = informativeMovie
        
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
    
    private func showOverlayAlertWithSpinner(completion: @escaping () -> Void) {
        let alertWithSpinner = UIAlertController(title: nil, message: "Getting The Movie", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(origin: CGPoint(x: 10, y: 5), size: CGSize(width: 50, height: 50)))
        loadingIndicator.hidesWhenStopped = true
        
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        
        alertWithSpinner.view.addSubview(loadingIndicator)
        
        navigationController?.present(alertWithSpinner, animated: true, completion: completion)
    }
    
    private func dismisssOverlayAlertWithSpinner(completion: @escaping () -> Void) {
        navigationController?.dismiss(animated: true, completion: completion)
    }
    
    private func initStoryboardViewController(with identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController
    }
}

// Extension for the search bar events
extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarInputBoundTimer?.invalidate()
        
        searchBarInputBoundTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if !searchText.isEmpty {
                self?.startSpinner()
                self?.searchMovies(for: searchText) { movies in
                    DispatchQueue.main.async {
                        self?.movies = movies ?? []
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.movies = []
                }
            }
        }
    }
}

// Extension for the movies table view information
extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pick(movie: movies[indexPath.item])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        
        let movie = movies[indexPath.item]
        
        cell.favoriteMovieDelegate = self
        
        cell.set(movieId: movie.movieId, movieName: movie.title, movieYear: movie.year, movieImageUrl: movie.imageUrl, isFavorite: movie.isFavorite)
        
        return cell
    }
}

// Extension for setting a favorite movie events
extension MoviesViewController: MovieFavoriteable {
    func addFavoriteMovie(with movieId: String) {
        if let movie = movies.filter({ $0.movieId == movieId }).first {
            movie.isFavorite = true
        }
        MovieService.shared.addMovieToFavorites(movieId)
    }
    
    func removeFavoriteMovie(with movieId: String) {
        if let movie = movies.filter({ $0.movieId == movieId }).first {
            movie.isFavorite = false
        }
        MovieService.shared.removeMovieFromFavorites(movieId)
    }
    
    
}

