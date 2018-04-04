//
//  Download.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/3/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import Foundation

class Download {
    
    var track: Track
    init(track: Track) {
        self.track = track
    }
    
    // Download service sets these valuse:
    var task: URLSessionDownloadTask?
    var isDownloading = false
    var resumeData: Data?
    
    // Download delegate sets this value:
    var progress: Float = 0
}
