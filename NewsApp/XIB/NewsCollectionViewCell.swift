//
//  NewsCollectionViewCell.swift
//  NewsApp
//
//  Created by Юрий Девятаев on 14.03.2022.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var customContentView: UIView!
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var textNews: UILabel!
    
    static let identifier = "NewsCollectionViewCell"
    
    var cellTap: (() -> ())?
    var indexPath: IndexPath?
    
    static func nib() -> UINib {
        return UINib(nibName: "NewsCollectionViewCell",
                     bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createGradient()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepare()
    }
    
    func prepare(){
        indexPath = nil
        imageNews.image = nil
    }
    
    //MARK: - Funcs Configurations
    
    func config() {
        configContentView()
        configTextNews()
        imageNews.contentMode = .scaleAspectFill
    }
    
    func configContentView() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        customContentView.clipsToBounds = true
        customContentView.corner(withRadius: 7)
    }
    
    func configTextNews() {
        textNews.numberOfLines = 0
        textNews.backgroundColor = .clear
        textNews.textColor = .white
    }
    
    func createGradient() {
        let gradientLayer = CAGradientLayer()
        imageNews.layer.sublayers?.removeAll()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        imageNews.layer.insertSublayer(gradientLayer, at: 0)
    }
}
