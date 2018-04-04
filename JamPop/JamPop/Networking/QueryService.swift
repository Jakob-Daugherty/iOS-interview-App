//
//  QueryService.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/2/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import Foundation
import UIKit

// Runs query data task, and stores results in array of Albums
class QueryService {
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Album]?, String) -> ()
    typealias TrackQueryResult = ([Track]?, String) -> ()
    
    var tracks: [Track] = []
    var albums: [Album] = []
    var errorMessage = ""
    
    // 1
    let defaultSession = URLSession(configuration: .default)
    // 2
    var dataTask: URLSessionDataTask?
    var artTask: URLSessionDataTask?
    var trackTask: URLSessionDataTask?
    
    func getSearchResults(searchTerm: String, completion: @escaping TrackQueryResult) {
        // 1 - For a new user query, you can cancel the data task if it already exists, because you want to resue the data task object for this new query.
        trackTask?.cancel()
        // 2 - To include the user's search string in the query URL, you create a URLComponents object from the iTunes Search base URL, then set its query string: this ensures that characters in the search string are properly escaped.
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
            // 3 - The url property of urlComponents might be nil, so you optional-bind it to url.
            guard let url = urlComponents.url else { return }
            // 4 - From the session you created, you initialize a URLSessionDataTask with the query url and a completion handler to call when the data task completes.
            trackTask = defaultSession.dataTask(with: url) { data, response, error in defer { self.trackTask = nil }
                // 5 - If the HTTP request is successful, you call the helper method updateSearchResults(_:), which parses the response data into the tracks array.
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    self.updateSearchResults(data)
                    // 6 - You switch the main queue to pass tracks to the completion handler in SearchVC+SearchBarDelegate.swift
                    DispatchQueue.main.async {
                        completion(self.tracks, self.errorMessage)
                    }
                }
            }
            // 7 - All tasks start in a suspended by default; calling resume() starts the data task.
            trackTask?.resume()
        }
    }
    
    fileprivate func updateSearchResults(_ data: Data) {
        var response: JSONDictionary?
        tracks.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response!["results"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        var index = 0
        for trackDictionary in array {
            if let trackDictionary = trackDictionary as? JSONDictionary,
                let previewURLString = trackDictionary["previewUrl"] as? String,
                let previewURL = URL(string: previewURLString),
                let name = trackDictionary["trackName"] as? String,
                let artist = trackDictionary["artistName"] as? String {
                tracks.append(Track(name: name, artist: artist, previewURL: previewURL, index: index))
                index += 1
            } else {
                errorMessage += "Problem parsing trackDictionary\n"
            }
        }
    }
    
    func getAlbumArt(_ url: String) -> UIImage? {
        var image: UIImage?
        artTask?.cancel()
        if var urlComponents = URLComponents(string: url ) {
            guard let url = urlComponents.url else { return nil }
            artTask = defaultSession.dataTask(with: url) { data, response, error in defer { self.artTask = nil}
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    image = UIImage(data: data)
                    
                    }
                }
            }
            artTask?.resume()
        return image
        }
    
    
    func getAlbumResults(completion: @escaping QueryResult) {
        // 1
        dataTask?.cancel()
        // 2
        if var urlComponents = URLComponents(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/10/explicit.json") {
            // 3
            guard let url = urlComponents.url else { return }
            // 4
            dataTask = defaultSession.dataTask(with: url) { data, response, error in defer { self.dataTask = nil }
                // 5
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    self.updateAlbumResults(data)
                    // 6
                    DispatchQueue.main.async {
                        completion(self.albums, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
//    fileprivate func updateImage(_ data: Data) -> UIImage {
//        return UIImage
//    }
    
    fileprivate func updateAlbumResults(_ data: Data) {
        var response: JSONDictionary?
        //var arrayRaw: JSONDictionary?
        albums.removeAll()
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        //response.
        let value = "feed"
        guard let responseData = response![value] as? JSONDictionary else {
            print("\n<-- -->\n")
            print("\(String(describing: response))")
            print("\n<-- -->\n")
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
//        do {
//            arrayRaw = try JSONSerialization.jsonObject(with: responseData, options: []) as? JSONDictionary
//        } catch let parseError as NSError {
//            errorMessage += "JSON is working? \(parseError.localizedDescription)"
//        }

        guard let array = responseData["results"] as? [Any] else {
            print("\n<-- -->\n")
            print("\(String(describing: responseData))")
            print("\n<-- -->\n")
            errorMessage += "Dictionary does not AGAIN contain results key\n"
            return
        }
        
//        print("\n<-- -->\n")
//        print("\(String(describing: array))")
//        print("\n<-- -->\n")
        
        var index = 0
        for albumDictionary in array {
            
//            print("\n<-- -->\n")
//            print("\(String(describing: albumDictionary))")
//            print("\n<-- -->\n")
            
            if let albumDictionary = albumDictionary as? JSONDictionary,
                let artistName = albumDictionary["artistName"] as? String,
                let idString = albumDictionary["id"] as? String,
                let id = Int(idString),
                let releaseDate = albumDictionary["releaseDate"] as? String,
                let name = albumDictionary["name"] as? String,
                let kind = albumDictionary["kind"] as? String,
                let copyright = albumDictionary["copyright"] as? String,
                let artistIdstr = albumDictionary["artistId"] as? String,
                let artistId = Int(artistIdstr),
                let artistUrlstr = albumDictionary["artistUrl"] as? String,
                let artistUrl = URL(string: artistUrlstr),
                let artworkUrl100 = albumDictionary["artworkUrl100"] as? String,
                //let artworkUrl100 = URL(string: artworkUrl100str),
                let genresArray = albumDictionary["genres"] as? [Any],
                let urlstr = albumDictionary["url"] as? String,
                let url = URL(string: urlstr) {
                var genres: [Genre] = []
                var gindex = 0
                
//                print("\n<-- -->\n")
//                print("\(String(describing: albumDictionary))")
//                print("\n<-- -->\n")
                
                for genreDict in genresArray {
                    if let genreDict = genreDict as? JSONDictionary,
                        let genreIdstr = genreDict["genreId"] as? String,
                        let genreId = Int(genreIdstr),
                        let name = genreDict["name"] as? String,
                        let urlStr = genreDict["url"] as? String,
                        let url = URL(string: urlStr) {
                        genres.append(Genre(genreId: genreId, name: name, url: url, index: gindex))
                        gindex += 1
                    }
                }
                albums.append(Album(artistName: artistName, id: id, releaseDate: releaseDate, name: name, kind: kind, copyright: copyright, artistId: artistId, artistUrl: artistUrl, artworkUrl100: artworkUrl100, genres: genres, url: url, index: index))
                index += 1
            } else {
                errorMessage += "Problem parsing albumDictionary\n"
            }
        }
    }
}
