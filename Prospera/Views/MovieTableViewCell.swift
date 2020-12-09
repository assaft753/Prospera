//
//  MovieTableViewCell.swift
//  Prospera
//
//  Created by Assaf Tayouri on 08/12/2020.
//

import UIKit
import SDWebImage

// Table View Cell that responsible for presenting
// a movie cell in a movies table view
class MovieTableViewCell: UITableViewCell {
    
    // MARK:- Static Property
    static let identifier = "movieTableViewCell"
    
    // MARK:- Properties
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var movieYearLabel: UILabel!
    @IBOutlet private weak var favoriteImageView: UIImageView!
    
    private var isFavorite = false
    private var movieId: String!
    
    private let isFavoriteTransformation = CGAffineTransform.identity
    private let isNotFavoriteTransformation = CGAffineTransform(scaleX: 0.8, y: 0.8)
    
    weak var favoriteMovieDelegate: MovieFavoriteable?
    
    // MARK:- Computed properties
    private var outlineHeartImage: UIImage {
        return UIImage(systemName: "heart")!
    }
    
    private var filledHeartImage: UIImage {
        return UIImage(systemName: "heart.fill")!
    }
    
    // MARK:- View Life-Cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        setupMovieImageView()
        setupFavoriteImageView()
    }
    
    private func setupMovieImageView() {
        movieImageView.clipsToBounds = true
        movieImageView.layer.cornerRadius = 8
    }
    
    private func setupFavoriteImageView() {
        favoriteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favoriteImageTapped)))
        favoriteImageView.transform = isNotFavoriteTransformation
    }
    
    @objc private func favoriteImageTapped() {
        isFavorite.toggle()
        if isFavorite {
            favoriteMovieDelegate?.addFavoriteMovie(with: movieId)
            animateIsFavorite()
        } else {
            favoriteMovieDelegate?.removeFavoriteMovie(with: movieId)
            animateIsNotFavorite()
        }
    }
    
    private func animateIsFavorite() {
        favoriteImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        favoriteImageView.image = filledHeartImage
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 30, initialSpringVelocity: 70, options: .curveEaseIn) { [unowned self] in
            self.favoriteImageView.transform = isFavoriteTransformation
        }
    }
    
    private func animateIsNotFavorite() {
        favoriteImageView.image = outlineHeartImage
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 30, initialSpringVelocity: 70, options: .curveEaseIn) { [unowned self] in
            self.favoriteImageView.transform = self.isNotFavoriteTransformation
        }
    }
    
    func set(movieId: String, movieName: String, movieYear: Int, movieImageUrl: String, isFavorite: Bool) {
        self.movieId = movieId
        set(movieName: movieName)
        set(movieYear: movieYear)
        set(isFavorite: isFavorite)
        set(movieImage: movieImageUrl)
    }
    
    private func set(isFavorite: Bool) {
        self.isFavorite = isFavorite
        
        if self.isFavorite {
            favoriteImageView.transform = isFavoriteTransformation
            favoriteImageView.image = filledHeartImage
        } else {
            favoriteImageView.transform = isNotFavoriteTransformation
            favoriteImageView.image = outlineHeartImage
        }
    }
    
    private func set(movieName: String) {
        self.movieNameLabel.text = movieName
    }
    
    private func set(movieYear: Int) {
        self.movieYearLabel.text = "\(movieYear)"
    }
    
    private func set(movieImage: String) {
        movieImageView.sd_setImage(with: URL(string: movieImage), placeholderImage: UIImage(systemName: "ticket.fill"))
    }
    
}
