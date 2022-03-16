//
//  ViewController.swift
//  NewsApp
//
//  Created by Юрий Девятаев on 14.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    var categories = ["technology", "sports", "science", "health", "general", "entertainment", "business"]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        configTableView()
        sortArray()
    }
    
    func sortArray() {
        categories = categories.sorted{$0 < $1}
    }
    
    func configTableView() {
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CategoryTableViewCell.nib(),
                           forCellReuseIdentifier: CategoryTableViewCell.identifier)
    }
    
    func fill(cell: CategoryTableViewCell, indexPath: IndexPath) -> CategoryTableViewCell {
        
        let controller = CollectionViewController()
        controller.category = categories[indexPath.section]
        addChildViewController(container: cell.contentView, controller: controller)
        return cell
    }
    
    func addChildViewController(container: UIView, controller: UIViewController) {
        
        container.subviews.forEach { view in
            view.removeFromSuperview()
            view.findViewController()?.removeFromParent()
        }
        
        addChild(controller)
    
        container.addSubview(controller.view)
        controller.view.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        controller.didMove(toParent: self)
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contentCell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.identifier,
            for: indexPath) as? CategoryTableViewCell else {return UITableViewCell()}
    
        let cell = fill(cell: contentCell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].uppercased()
    }


//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//
//    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3
    }
    
}



