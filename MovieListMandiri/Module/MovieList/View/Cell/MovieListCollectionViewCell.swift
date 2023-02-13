//
//  MovieListCollectionViewCell.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCellData(model: ResponseMovieByGenreModel.Result?) {
        if let validModel = model {
            if let validPoster = validModel.posterPath {
                movieImageView.setImage("https://www.themoviedb.org/t/p/w440_and_h660_face\(validPoster)", placeholder: "img_no_image")
            }
        }
    }
}
