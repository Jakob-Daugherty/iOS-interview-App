//
//  DetailVC+URLSessionDelegates.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/3/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import Foundation
import UIKit

extension DetailViewController: URLSessionDelegate {
    
    // Standard background session handler
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                completionHandler()
            }
        }
    }
}
extension DetailViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //print("Finished downloading to \(location).")
        // 1 - You extract the original request URL from the task, look up the corresponding Download in your active downloads, and remove it from that dictionary.
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        let download = downloadService.activeDownloads[sourceURL]
        downloadService.activeDownloads[sourceURL] = nil
        // 2 - You then pass the URL to the localFilePath(for:) helper method in SearchViewController.swift, which generates a permanent local file path to save to, by appending the lastPathComponent of the URL (the file name and extension of the file) to the path of the app's Documents directory.
        let destinationURL = localFilePath(for: sourceURL)
        print(destinationURL)
        // 3 - Using FileManager, you move the downloaded file from its temporary file location to the desired destination file path, first clearing out any item at that location before you start the copy task. You also set the download track's downloaded property to true.
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            download?.track.downloaded = true
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
        // 4 - Finally, you use the download track's index property to reload the corresponding cell.
        if let index = download?.track.index {
            DispatchQueue.main.async {
                self.detailTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        // 1 - You extract the URL of the provided downloadTask, and use it to find the matching Download in your dictionary of active downloads.
        guard let url = downloadTask.originalRequest?.url,
            let download = downloadService.activeDownloads[url]  else { return }
        // 2 - The method also provides the total bytes written and the total bytes expected to be written. You calculate the progress as the ratio of these two values, and save the result in the Download. The track cell will use this value to update the progress view.
        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        // 3 - ByteCountFormatter takes a byte value and generates a human-redable string showing the total download file size. You'ss use this string to show the size of the download alongside the percentage complete.
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
        // 4 - Finally, you find the cell responsible for displaying the Track, and call the cell's helper method to update its progress view and progress lavle with the values derived from the previous steps. This involves the UI, so you can do it on the main queue.
        DispatchQueue.main.async {
            if let trackCell = self.detailTableView.cellForRow(at: IndexPath(row: download.track.index,
                                                                       section: 0)) as? TrackCell {
                trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
            }
        }
    }
}
