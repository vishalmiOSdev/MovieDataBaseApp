//
//  MovieDetailVC.swift
//  MovieDataBaseApp
//
//  Created by Vishal Manhas on 18/10/24.
//

import UIKit
import SDWebImage

class MovieDetailVC: UIViewController {
    
//    Poster, title, plot, cast & crew, released date, genre and rating
    var movie: Movie?

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var languageLabel:UILabel!
    @IBOutlet weak var plotLabel : UILabel!
    @IBOutlet weak var posterImageView :UIImageView!
    @IBOutlet weak var castAndCrewLabel :UILabel!
    @IBOutlet weak var releasedLabel : UILabel!
    @IBOutlet weak var genreLabel : UILabel!
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        configureUI()
    }
    
    func configureUI(){
        titleLabel.text = movie?.title
        languageLabel.text = "Language : \(movie?.language ?? "")"
        plotLabel.text = movie?.plot
        posterImageView.sd_setImage(with: URL(string: movie?.poster ?? ""), placeholderImage: UIImage(systemName: "person"))
        castAndCrewLabel.text = "Director: \(movie?.director ?? "") \nActors: \(movie?.actors ?? "")"
        releasedLabel.text = movie?.released
        genreLabel.text = movie?.genre
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc private func handleTapOutside() {
        dismiss(animated: false, completion: nil)
    }
  
    @IBAction func viewRatingClick(_ sender:UIButton){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "RatingVC") as? RatingVC {
            vc.ratingSource = movie?.ratings
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
}
