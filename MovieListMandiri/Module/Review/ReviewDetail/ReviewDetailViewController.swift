//
//  ReviewDetailViewController.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit

class ReviewDetailViewController: UIViewController {
    @IBOutlet weak var reviewContentView: UIView!
    @IBOutlet weak var reviewAvatarImageView: UIImageView!
    @IBOutlet weak var reviewNameLabel: UILabel!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var reviewDescriptionLabel: UILabel!
    
    var reviewerData: ResponseReviewModel.Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropShadow()
        setupData()
    }
    
    private func dropShadow() {
        reviewContentView.layer.cornerRadius = 8
        let grayColor = UIColor.init(red: 218/255, green: 218/255, blue: 218/255, alpha: 1.0)
        reviewContentView.layer.borderColor = grayColor.cgColor
        reviewContentView.layer.applySketchShadow(color: grayColor, alpha: 1.0, x: 0, y: 1, blur: 4, spread: 0)
    }
    
    private func setupData() {
        if let validReviewer = reviewerData {
            var avatarUrl = ""
            if let validaAthorDetails = validReviewer.authorDetails, let validAvatarPath = validaAthorDetails.avatarPath {
                if validAvatarPath.contains("https://") {
                    avatarUrl = validAvatarPath
                } else {
                    avatarUrl = "https://www.themoviedb.org/t/p/w440_and_h660_face\(validAvatarPath)"
                }
                self.reviewAvatarImageView.setImage("https://www.themoviedb.org/t/p/w440_and_h660_face\(avatarUrl)", placeholder: "img_no_image")
                self.reviewNameLabel.text = "A Review by \(validaAthorDetails.username ?? "")"
                if let validCreatedDate = validReviewer.createdAt, let validDate = CustomDateFormatter.yyyy_dash_MM_dash_dd_T_HH_colon_mm_colon_ss_dot_SSSZ.dateFromString(validCreatedDate) {
                    let validCreatedString = CustomDateFormatter.MMM_dd_comma_yyyy.stringFromDate(validDate)
                    reviewDateLabel.text = "Written by \(validaAthorDetails.username ?? "") on \(validCreatedString)"
                }
            }
            if let htmlString = validReviewer.content, let attrString = htmlString.htmlToAttributedString {
                let attributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.foregroundColor: UIColor.black,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)
                ] as [NSAttributedString.Key: Any]
                attrString.addAttributes(attributes, range: NSMakeRange(0, attrString.length))
                reviewDescriptionLabel.attributedText = attrString
            } else {
                reviewDescriptionLabel.text = nil
            }
        }
    }
}
