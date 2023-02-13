//
//  UIImageView+Extension.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import Kingfisher
import UIKit

extension UIImageView {
    
    func setImage(_ url: String, placeholder: String? = "") {
        self.kf.setImage(with: URL(string: url), placeholder: UIImage(named: placeholder ?? ""))
    }
    
    func setImageColor(color: UIColor) {
      let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
      self.image = templateImage
      self.tintColor = color
    }
    
    func setQRCodeImage(with text: String) {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        
        let qrData = text.data(using: .utf8)
        qrFilter.setValue(qrData, forKey: "inputMessage")
        
        let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
        if let ciImage = qrFilter.outputImage?.transformed(by: qrTransform) {
            self.image = UIImage(ciImage: ciImage)
        }
    }
    
    func loadImage(url: URL?, placeholder: String = "") {
        kf.setImage(with: url, placeholder: UIImage(named: placeholder),
                    options: [.transition(.fade(0.33)),
                              .memoryCacheExpiration(.seconds(60))])
    }
    
    func loadImage(url: URL?, size: CGSize, placeholder: String = "") {
        let actualSize = CGSize(
            width: size.width * UIScreen.main.scale,
            height: size.height * UIScreen.main.scale)
        
        let imageProcessor = ResizingImageProcessor(referenceSize: actualSize)
        kf.setImage(with: url, placeholder: UIImage(named: placeholder),
                    options: [.transition(.fade(0.33)),
                              .processor(imageProcessor),
                              .memoryCacheExpiration(.seconds(60))])
    }
}

