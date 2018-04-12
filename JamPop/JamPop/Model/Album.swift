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
    var artTask: URLSessionDataTask?
    var artworkImage: UIImage?
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
    
    func getAlbumArt() -> UIImage? {
        if (artworkImage != nil) {
            return artworkImage
        }
        
        artTask?.cancel()
        if var urlComponents = URLComponents(string: artworkUrl100 ) {
            guard let url = urlComponents.url else { return nil }
            let defaultSession = URLSession(configuration: .default)
            
//            artTask = defaultSession.dataTask(with: url) { data, response, error in defer { self.artTask = nil}
//                if let error = error {
////                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
//                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
//                    self.artworkImage = UIImage(data: data)
//                }
//            }
        }
        artTask?.resume()
        return self.artworkImage
    }
}
