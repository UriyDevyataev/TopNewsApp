//
//  Extensions.swift
//  NewsApp
//
//  Created by Юрий Девятаев on 14.03.2022.
//

import Foundation
import UIKit

extension UIView {
    
    func corner(withRadius: CGFloat) {
        layer.cornerRadius = withRadius
//        if self is UIImageView || self is UITextField || self is UILabel {
//            clipsToBounds = true
//        }
    }
        
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

extension String {
    
    func dateFromUTC() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: self) else {return Date.now}
        return date
    }
}
