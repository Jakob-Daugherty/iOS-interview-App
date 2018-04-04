//
//  Track.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/3/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import Foundation

// Query service creates Track objects
class Track {
    
    let name: String
    let artist: String
    let previewURL: URL
    let index: Int
    var downloaded = false
    
    init(name: String, artist: String, previewURL: URL, index: Int) {
        self.name = name
        self.artist = artist
        self.previewURL = previewURL
        self.index = index
    }
    
}
