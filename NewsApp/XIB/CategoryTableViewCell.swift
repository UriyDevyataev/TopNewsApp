//
//  CategoryTableViewCell.swift
//  NewsApp
//
//  Created by Юрий Девятаев on 14.03.2022.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let identifier = "CategoryTableViewCell"
    
//    var indexPath: IndexPath?
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryTableViewCell",
                     bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepare()
    }
    
    func prepare() {
//        indexPath = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
