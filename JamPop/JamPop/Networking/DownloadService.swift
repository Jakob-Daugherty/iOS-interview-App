//
//  DownloadService.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/3/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import Foundation

// Downloads song snippets, and stores in local file.
// Allows cancel, pause, resume download.
class DownloadService {
    
    // Dictionary that maintains a mapping between a URL and its active Download, if any.
    var activeDownloads: [URL: Download] = [:]
    
    // SearchViewController creates downloadsSession
    var downloadsSession: URLSession!
    
    // MARK: - Download methods called by TrackCell delegate methods
    
    func startDownload(_ track: Track) {
        // 1 - You first initialize the Download with the track.
        let download = Download(track: track)
        // 2 - Using your new session object, you create a URLSessionDownloadtask with the track's preview URL, and set it to the task property of the Download
        download.task = downloadsSession.downloadTask(with: track.previewURL)
        // 3 - You start the download task by calling resume() on it.
        download.task!.resume()
        // 4 - You indicate that the download is in progress.
        download.isDownloading = true
        // 5 - Finally, you map the download URL to its Download in the activeDownloads dictionary.
        activeDownloads[download.track.previewURL] = download
    }
    // TODO: previewURL is http://a902.phobos.apple.com/...
    // why doesn't ATS prevent this download?
    
    func pauseDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewURL] else { return }
        if download.isDownloading {
            download.task?.cancel(byProducingResumeData: { data in download.resumeData = data })
            download.isDownloading = false
        }
    }
    
    func cancelDownload(_ track: Track) {
        if let download = activeDownloads[track.previewURL] {
            download.task?.cancel()
            activeDownloads[track.previewURL] = nil
        }
    }
    
    func resumeDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewURL] else { return }
        if let resumeData = download.resumeData {
            download.task = downloadsSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = downloadsSession.downloadTask(with: download.track.previewURL)
        }
        download.task!.resume()
        download.isDownloading = true
    }
    
}
