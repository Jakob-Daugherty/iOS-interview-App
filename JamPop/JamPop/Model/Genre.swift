//
//  Genre.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/2/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import Foundation

class Genre {
    let genreId: Int
    let name: String
    let url: URL
    let index: Int
    
    init( genreId: Int, name: String, url: URL, index: Int ) {
        self.genreId = genreId
        self.name = name
        self.url = url
        self.index = index
    }
    
//    static func initFromRaw(_ dict: [Any]) -> [Genre]? {
//        var temp: [Genre] = []
//        var index = 0
//        for item in dict {
//            if let item = item as? JSONDictionary,
//            let strGenreId = item["genreId"] as? String,
//            let genreId = Int(strGenreId),
//            let name = item["name"] as? String,
//            let strUrl = item["url"] as? String,
//                let url = URL(string: strUrl) {
//                temp.append(Genre(genreId: genreId, name: name, url: url, index: index))
//                index += 1
//            }
//        }
//        return temp
//    }
}
