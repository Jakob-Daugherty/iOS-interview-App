//
//  Album.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/2/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Query service creates Track objects

class Album {
    
    let artistName: String
    //@NSManaged var artistName: String?
    let id: Int
    //@NSManaged var albumId: Int64?
    let releaseDate: String
    //@NSManaged var releaseDate: String?
    let name: String
    //@NSManaged var name: String?
    let kind: String
    //@NSManaged var kind: String?
    let copyright: String
    //@NSManaged var copyright: String?
    let artistId: Int
    //@NSManaged var artistId: Int64?
    let artistUrl: URL
    //@NSManaged var artistUrl: String?
    let artworkUrl100: String
    //@NSManaged var artworkUrl100: String?
    var genres: [Genre]?
    //@NSManaged var genres: [Genre]?
    let url: URL
    //@NSManaged var url: String?
    let index: Int
    //@NSManaged var index: Int64?
    var artTask: URLSessionDataTask?
    var artworkImage: UIImage?
    var bgURLSession: URLSession?
    var tracks: [Track]? {
        get {
            if self.tracks != nil { return self.tracks} else { return nil }
        }
        set {
            self.tracks = newValue
        }
    }
    var artworkImageId: Double?
    
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
        //self.artworkImage = UIImage(data: try! Data(contentsOf: URL(string: artworkUrl100)!))!
        self.artworkImage = nil
        self.bgURLSession = nil
        self.artworkImageId = nil 
    }
    
    func getAlbumArt() -> UIImage? {
        // Try loading from data store
        
        // End
        return UIImage(data: try! Data(contentsOf: URL(string: artworkUrl100)!))!
//        if (artworkImage != nil) {
//            return artworkImage
//        }
//
//        artTask?.cancel()
//        if var urlComponents = URLComponents(string: artworkUrl100! ) {
//            guard let url = urlComponents.url else { return nil }
//            let defaultSession = URLSession(configuration: .default)
//
////            artTask = defaultSession.dataTask(with: url) { data, response, error in defer { self.artTask = nil}
////                if let error = error {
//////                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
////                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
////                    self.artworkImage = UIImage(data: data)
////                }
////            }
//        }
//        artTask?.resume()
//        return self.artworkImage
    }
}
