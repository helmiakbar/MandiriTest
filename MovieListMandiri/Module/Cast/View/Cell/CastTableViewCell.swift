//
//  CastTableViewCell.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit

class CastTableViewCell: UITableViewCell {
    @IBOutlet weak var castContentView: UIView!
    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var castNameLabel: UILabel!
    @IBOutlet weak var castCharacterLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        castContentView.layer.cornerRadius = 8
        let grayColor = UIColor.init(red: 218/255, green: 218/255, blue: 218/255, alpha: 1.0)
        castContentView.layer.borderColor = grayColor.cgColor
        castContentView.layer.applySketchShadow(color: grayColor, alpha: 1.0, x: 0, y: 1, blur: 4, spread: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCellData(_ model: ResponseCreditModel.Cast?) {
        if let validModel = model {
            castNameLabel.text = validModel.name
            castCharacterLbl.text = validModel.character
            if let validPath = validModel.profile_path {
                castImageView.setImage("https://www.themoviedb.org/t/p/w440_and_h660_face\(validPath)", placeholder: "img_no_image")
            }
        }
    }
    
}
