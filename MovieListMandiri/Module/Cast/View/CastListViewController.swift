//
//  CastListViewController.swift
//  MovieListMandiri
//
//  Created by SehatQ on 13/02/23.
//

import UIKit

class CastListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var model: ResponseCreditModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Cast List"
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: String(describing: CastTableViewCell.self), bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: String(describing: CastTableViewCell.self))
    }
}

extension CastListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.cast?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CastTableViewCell.self)) as? CastTableViewCell {
            if let validModel = model {
                cell.configureCellData(validModel.cast?[indexPath.row])
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
