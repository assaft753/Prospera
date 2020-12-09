//
//  MovieDetailsViewController.swift
//  Prospera
//
//  Created by Assaf Tayouri on 09/12/2020.
//

import UIKit
import SDWebImage
import TagListView

// View Controller that responsible for presenting informative details of movie
class MovieDetailsViewController: UIViewController {
    
    // MARK:- Static Property
    static let identifier = "movieDetailsViewController"
    
    // MARK:- Properties
    @IBOutlet private weak var movieDirectorLabel: UILabel!
    @IBOutlet private weak var movieYearLabel: UILabel!
    @IBOutlet private weak var movieRuntimeLabel: UILabel!
    @IBOutlet private weak var movieRatingStackView: UIStackView!
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var favoriteStackView: UIStackView!
    @IBOutlet private weak var genresTagListView: TagListView!
    @IBOutlet private weak var moviePlotTextView: UITextView!
    
    var informativeMovie: InformativeMovie!
    
    // MARK:- View Controller Life-Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateUI()
        
    }
    
    // MARK:- Methods
    private func setupViews() {
        setupTagListView()
        setupMoviePlotTextView()
    }
    
    private func setupTagListView() {
        genresTagListView.textFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
        genresTagListView.alignment = .leading
    }
    
    private func setupMoviePlotTextView() {
        moviePlotTextView.layer.cornerRadius = 10
        moviePlotTextView.layer.masksToBounds = true
    }
    
    private func updateUI() {
        favoriteStackView.isHidden = !informativeMovie.isFavorite
        
        genresTagListView.addTags(informativeMovie.genres)
        
        set(movieDirector: informativeMovie.director)
        set(movieYear: informativeMovie.year)
        set(movieRuntime: informativeMovie.runtime)
        set(movieRating: informativeMovie.rating)
        set(movieImage: informativeMovie.imageUrl)
        set(movieTitle: informativeMovie.title)
        set(moviePlot: informativeMovie.plot)
    }
    
    private func set(movieDirector: String) {
        movieDirectorLabel.text = movieDirector
    }
    
    private func set(movieYear: Int) {
        movieYearLabel.text = "\(movieYear)"
    }
    
    private func set(movieRuntime: String) {
        movieRuntimeLabel.text = movieRuntime
    }
    
    private func set(movieTitle: String) {
        navigationItem.title = movieTitle
    }
    
    private func set(moviePlot: String) {
        moviePlotTextView.text = moviePlot
    }
    
    private func set(movieImage: String) {
        movieImageView.sd_setImage(with: URL(string: movieImage), placeholderImage: UIImage(systemName: "ticket.fill"))
    }
    
    private func set(movieRating: Float) {
        let startViews = movieRatingStackView.arrangedSubviews as! [UIImageView]
        
        let fullNumber = Int(movieRating)
        let fractionNumber = movieRating - Float(fullNumber)
        
        startViews[0...(fullNumber - 1)].forEach { $0.image = UIImage(systemName: "star.fill")  }
        
        if fractionNumber != 0 {
            startViews[fullNumber].image = UIImage(systemName: "star.lefthalf.fill")
        }
    }
}
