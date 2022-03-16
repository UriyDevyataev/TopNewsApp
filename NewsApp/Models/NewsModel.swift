//
//  File.swift
//  NewsApp
//
//  Created by Юрий Девятаев on 15.03.2022.
//

import Foundation
import RealmSwift
 
class NewsObject: Object {
    
    @Persisted (primaryKey: true) var idKey: String = UUID().uuidString
    @Persisted var news: Data? = nil
    @Persisted var category = ""
}



