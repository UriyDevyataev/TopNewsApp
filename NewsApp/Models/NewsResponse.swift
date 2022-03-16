//
//  News.swift
//  NewsApp
//
//  Created by Юрий Девятаев on 14.03.2022.
//

import Foundation
import UIKit

struct MainModel: Codable {
    var status: String
    var totalResults: Int?
    var articles: [News]
}

struct News: Codable {
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    var imageData: Data?
    var uuid: String? = nil
}
