//
//  UITableView+Extension.swift
//  MovieListMandiri
//
//  Created by SehatQ on 12/02/23.
//

import Foundation
import UIKit

extension UITableView {
    
    func showLoadingFooter(){
        let loadingFooter = UIActivityIndicatorView(style: .gray)
        loadingFooter.frame.size.height = 60
        loadingFooter.hidesWhenStopped = true
        loadingFooter.startAnimating()
        tableFooterView = loadingFooter
    }
    
    func showLoadingHeader(){
        let loadingFooter = UIActivityIndicatorView(style: .gray)
        loadingFooter.frame.size.height = 60
        loadingFooter.hidesWhenStopped = true
        loadingFooter.startAnimating()
        tableHeaderView = loadingFooter
    }
    
    func hideLoadingFooter(){
        let tableContentSufficentlyTall = (contentSize.height > frame.size.height)
        let atBottomOfTable = (contentOffset.y >= contentSize.height - frame.size.height)
        if atBottomOfTable && tableContentSufficentlyTall {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentOffset.y = self.contentOffset.y - 60
            }, completion: { _ in
                self.tableFooterView = UIView()
            })
        } else {
            self.tableFooterView = UIView()
        }
    }
    
    func hideLoadingHeader(){
        let tableContentSufficentlyTall = (contentSize.height > frame.size.height)
        let atBottomOfTable = (contentOffset.y >= contentSize.height - frame.size.height)
        if atBottomOfTable && tableContentSufficentlyTall {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentOffset.y = self.contentOffset.y - 60
            }, completion: { _ in
                self.tableHeaderView = UIView()
            })
        } else {
            self.tableHeaderView = UIView()
        }
    }
}
