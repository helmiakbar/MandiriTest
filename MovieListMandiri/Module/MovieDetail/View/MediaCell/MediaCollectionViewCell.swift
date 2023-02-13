//
//  MediaCollectionViewCell.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit
import WebKit

class MediaCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mediaPlayerView: UIView!
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        return webView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mediaPlayerView.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.bottomAnchor.constraint(equalTo: mediaPlayerView.bottomAnchor),
            webView.topAnchor.constraint(equalTo: mediaPlayerView.topAnchor),
            webView.leftAnchor.constraint(equalTo: mediaPlayerView.leftAnchor),
            webView.rightAnchor.constraint(equalTo: mediaPlayerView.rightAnchor)
        ])
    }
    
    func loadURLString(_ urlString: String?) {
        if let webUrlString = urlString, let webURL = URL(string: webUrlString) {
            webView.load(URLRequest(url: webURL))
        }
    }
    
    func configureCellData(_ model: ResponseVideoModel.Result?) {
        if let validModel = model, let validKey = validModel.key {
            loadURLString("https://www.youtube.com/embed/\(validKey)")
        }
    }
}

extension MediaCollectionViewCell: WKNavigationDelegate {
    
}
