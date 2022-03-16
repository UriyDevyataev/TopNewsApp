//
//  DataService.swift
//  NewsApp
//
//  Created by Юрий Девятаев on 14.03.2022.
//

import Foundation
import UIKit

private enum Constants {
    static var apiKey = "c03faf132fb64ec2ad82f5665df75df7"
    static var baseUrl = "https://newsapi.org/v2/top-headlines?"
}

private enum Params {
    static var auth = "apiKey"
    static var category = "category"
}

protocol DataService {
    func receiveData(category: String, success: @escaping ([News]) -> Void, error: @escaping (Error?) -> Void)
    func loadImage(url: String, success: @escaping (Data) -> Void, error: @escaping (Error?) -> Void)
}

class DataServiceImp: DataService {
    
    func receiveData(category: String, success: @escaping ([News]) -> Void, error: @escaping (Error?) -> Void) {
        let session = URLSession.shared
        let request = URLRequest(url: prepareLoadDataRequest(forCategories: category)!)
        
        let task = session.dataTask(with: request) { data, response, err in
            guard let data = data, err == nil else {
                error(err)
                return}
            do {
                let mapped = try JSONDecoder().decode(MainModel.self, from: data)
                var array = [News]()
                
                mapped.articles.forEach{ object in
                    var unicObject = object
                    unicObject.uuid = UUID().uuidString
                    array.append(unicObject)
                }
                success(array)
            } catch let errorData {
                error(errorData)
            }
        }
        task.resume()
    }
    
    private func prepareLoadDataRequest(forCategories: String) -> URL? {
        var components = URLComponents(string: Constants.baseUrl)
        components?.queryItems = [
            URLQueryItem(name: Params.category, value: forCategories),
            URLQueryItem(name: Params.auth, value: Constants.apiKey)
        ]
//        print(components?.url)
        return components?.url
    }
    
    func loadImage(url: String, success: @escaping (Data) -> Void, error: @escaping (Error?) -> Void) {
        guard let url = URL.init(string: url) else { return}
        let request: URLRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, err in
            guard let data = data, err == nil else {
                error(err)
                return}
            do {
                success(data)
            }
        }
        task.resume()
    }
}
