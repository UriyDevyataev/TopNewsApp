//
//  CashImage.swift
//  NewsApp
//
//  Created by Юрий Девятаев on 15.03.2022.
//

import Foundation
import UIKit

protocol CashProtocol {
    var imageCache: NSCache<NSString, UIImage> {get}
    var cachNews: [String: [News]] {get}
    
    func setObject(news: [News], forKey: String)
    func setObject(image: UIImage, forKey: String)
    
    func objectNews(forKey: String) -> [News]?
    func objectImage(forKey: String) -> UIImage?
}

class CashNewsImp: CashProtocol {
    
    init() {
        imageCache.countLimit = 100
    }
    
    static let shared: CashProtocol = CashNewsImp()
    
    var imageCache = NSCache<NSString, UIImage>()
    var cachNews = [String: [News]]()
    
    func setObject(news: [News], forKey: String) {
        cachNews[forKey] = news
    }
    
    func setObject(image: UIImage, forKey: String) {
        let key = NSString(string: forKey)
        imageCache.setObject(image, forKey: key)
    }
    
    func objectNews(forKey: String) -> [News]? {
        return cachNews[forKey]
    }
    
    func objectImage(forKey: String) -> UIImage? {
        let key = NSString(string: forKey)
        return imageCache.object(forKey: key)
    }
}
