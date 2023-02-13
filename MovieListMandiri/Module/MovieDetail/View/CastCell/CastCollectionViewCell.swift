//
//  CastCollectionViewCell.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var castShadowView: UIView!
    @IBOutlet weak var castContentView: UIView!
    @IBOutlet weak var castIimageView: UIImageView!
    @IBOutlet weak var castNameLabel: UILabel!
    @IBOutlet weak var castCharacterLabel: UILabel!
    @IBOutlet weak var seeMoreContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        castShadowView.layer.cornerRadius = 8
        let grayColor = UIColor.init(red: 218/255, green: 218/255, blue: 218/255, alpha: 1.0)
        castShadowView.layer.borderColor = grayColor.cgColor
        castShadowView.layer.applySketchShadow(color: grayColor, alpha: 1.0, x: 0, y: 1, blur: 4, spread: 0)
    }
    
    func configureCellData(_ model: ResponseCreditModel.Cast?) {
        castContentView.isHidden = false
        seeMoreContentView.isHidden = true
        if let validModel = model {
            castNameLabel.text = validModel.name
            castCharacterLabel.text = validModel.character
            if let validPath = validModel.profile_path {
                castIimageView.setImage("https://www.themoviedb.org/t/p/w440_and_h660_face\(validPath)", placeholder: "img_no_image")
            }
        }
    }
    
    func configureSeeMore() {
        castContentView.isHidden = true
        seeMoreContentView.isHidden = false
    }

}
