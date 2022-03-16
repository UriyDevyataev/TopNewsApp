//
//  NewsDataBase.swift
//  NewsApp
//
//  Created by Юрий Девятаев on 15.03.2022.
//

import Foundation
import RealmSwift

protocol NewsDataBase {
    func fetchNewsFor(category: String) -> [News]
    func addToList(category: String, news: [News])
    func updateNews(id: String, news: News)
    func clearCategory(category: String)
}

final class NewsDataBaseImp: NewsDataBase  {

    func fetchNewsFor(category: String) -> [News] {
        var news = [News]()
        guard let realm = try? Realm() else {return news}
                
        let objects = realm.objects(NewsObject.self)
        
        let categoryObjects = objects.where{
            $0.category == category
        }
        
        categoryObjects.forEach{ object in
            guard let data: Data = object.news else {return}
            let decoder = JSONDecoder()
            guard let new = try? decoder.decode(
                News.self,
                from: data
            ) else {
                return
            }
            news.append(new)
        }
        return news
    }
    
    func addToList(category: String, news: [News]) {
        guard let realm = try? Realm() else {return}
        do {
            try realm.write {
                
                let encoder = JSONEncoder()
                news.forEach { new in
                    
                    guard let data: Data = try? encoder.encode(new) else {
                        return
                    }
                    
                    guard let uuid = new.uuid else {return}
                    
                    let object = NewsObject()
                    object.idKey = uuid
                    object.news = data
                    object.category = category
                    realm.add(object)
                }
            }
        } catch _{
//            print(err)
        }
    }
    
    func updateNews(id: String, news: News) {
        guard let realm = try? Realm() else {return}
        guard let object = realm.object(
            ofType: NewsObject.self,
            forPrimaryKey: id)
        else {return}
        
        do {
            try realm.write {
                
                let encoder = JSONEncoder()
                guard let data: Data = try? encoder.encode(news) else {
                    return
                }
                object.news = data
            }
        } catch _{
//            print(err)
        }
    }
    
    func clearCategory(category: String) {
        
//        print(Realm.Configuration.defaultConfiguration.fileURL?.path)
        
        guard let realm = try? Realm() else {return}

        let objects = realm.objects(NewsObject.self)
        let categoryObjects = objects.where{
            $0.category == category
        }
        do {
            try realm.write {
                realm.delete(categoryObjects)
            }
        } catch _{
//            print(err)
        }
    }
}
