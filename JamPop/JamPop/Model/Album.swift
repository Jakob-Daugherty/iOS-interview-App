//
//  Album.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/2/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import Foundation
import UIKit

// Query service creates Track objects

class Album {
    
    let artistName: String
    let id: Int
    let releaseDate: String
    let name: String
    let kind: String
    let copyright: String
    let artistId: Int
    let artistUrl: URL
    let artworkUrl100: String
    let genres: [Genre]
    let url: URL
    let index: Int
    let artworkImage: UIImage
    var bgURLSession: URLSession?
    
    init(artistName: String, id: Int, releaseDate: String, name: String, kind: String, copyright: String, artistId: Int, artistUrl: URL, artworkUrl100: String, genres: [Genre], url: URL, index: Int) {
        self.artistName = artistName
        self.id = id
        self.releaseDate = releaseDate
        self.name = name
        self.kind = kind
        self.copyright = copyright
        self.artistId = artistId
        self.artistUrl = artistUrl
        self.artworkUrl100 = artworkUrl100
        self.genres = genres
        self.url = url
        self.index = index
        self.artworkImage = UIImage(data: try! Data(contentsOf: URL(string: artworkUrl100)!))!
        self.bgURLSession = nil 
    }
}
