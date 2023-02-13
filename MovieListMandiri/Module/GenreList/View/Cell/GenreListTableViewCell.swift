//
//  GenreListTableViewCell.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import UIKit

class GenreListTableViewCell: UITableViewCell {
    @IBOutlet weak var genreNameContentView: UIView!
    @IBOutlet weak var genreNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        genreNameContentView.layer.cornerRadius = 8
        let grayColor = UIColor.init(red: 218/255, green: 218/255, blue: 218/255, alpha: 1.0)
        genreNameContentView.layer.borderColor = grayColor.cgColor
        genreNameContentView.layer.applySketchShadow(color: grayColor, alpha: 1.0, x: 0, y: 1, blur: 4, spread: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureDataCell(model: ResponseGenreModel.Genre?) {
        genreNameLabel.text = model?.name
    }
}
