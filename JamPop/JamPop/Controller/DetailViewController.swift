//
//  DetailViewController.swift
//  JamPop
//
//  Created by Jakob Daugherty on 3/28/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailArtistLabel: UILabel!
    @IBOutlet weak var detailReleaseLabel: UILabel!
    @IBOutlet weak var detailArtworkView: UIImageView!
    @IBOutlet weak var detailGenreLabel: UILabel!
    @IBOutlet weak var detailTableView: UITableView!
    
    var searchResults: [Track] = []
    let queryService = QueryService()
    let downloadService = DownloadService()
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    
    // Get local file path: download task stores tune here; AV player plays it.
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    // Note the lazy creation of downloadsSession: this lets you delay the creation of the session until after the view controller is initialized, which allows you to pass self as the delegate parameter to the session initializer.
    lazy var downloadsSession: URLSession = {
        //let configuration = URLSessionConfiguration.default
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    func playDownload(_ track: Track) {
        print("\n<-- Setting up -->\n")
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
        
        playerViewController = AVPlayerViewController()
        present(playerViewController, animated: true, completion: nil)
        playerViewController.updateViewConstraints()
        let url = localFilePath(for: track.previewURL)
        player = AVPlayer(url: url)
        playerViewController.player = player
        print("\n<-- About to play... -->\n")
        do {
            player.play()
            print("\n<-- ...and we're playing! -->\n")
        }
        //player.play()
        //print("\n<-- ...and we're playing! -->\n")
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.name
            }
            if let artistLabel = detailArtistLabel {
                artistLabel.text = "By: " + detail.artistName
            }
            if let releaseLabel = detailReleaseLabel {
                releaseLabel.text = detail.releaseDate
            }
            if let artView = detailArtworkView {
                let image = UIImage(data: try! Data(contentsOf: URL(string: detail.artworkUrl100)!))!
                artView.image = image
            }
            if let genreLabel = detailGenreLabel {
                let genre = detail.genres.first
                genreLabel.text = genre?.name
            }
            let searchText = detail.name
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            queryService.getSearchResults(searchTerm: searchText) { results, errorMessage in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let results = results {
                    self.searchResults = results
//                    print("\n<-- -->\n")
//                    print("\(String(describing: results))")
//                    print("\n<-- --> \n")
                    self.detailTableView.reloadData()
                    //self.detailTableView.setContentOffset(CGPoint.zero, animated: false)
                }
                if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
            }
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailTableView.dataSource = self
        self.detailTableView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        downloadService.downloadsSession = downloadsSession
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Album? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

// MARK: - UITableView

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell: TrackCell = tableView.dequeueReusableCell(for: indexPath)
        let cell: TrackCell = tableView.dequeueReusableCell(withIdentifier: "TrackCell") as! TrackCell
        
        // Delegate cell button tap events to this view controller
        cell.delegate = self
        
        let track = searchResults[indexPath.row]
        //cell.configure(track: track, downloaded: track.downloaded, download: downloadService.activeDownloads[track.previewURL])
        //cell.titleLabel.text = track.name
        cell.titleLabel.text = track.name
        cell.artistLabel.text = track.artist
        
        // show/hide download controls Pause/Resume, Cancel buttons, progress info
        var showDownloadControls = false
        // Non-nil Download object means a download is in progress
        if let download = downloadService.activeDownloads[track.previewURL] {
            showDownloadControls = true
            let title = download.isDownloading ? "Pause" : "Resume"
            cell.pauseButton.setTitle(title, for: .normal)
            cell.progressLabel.text = download.isDownloading ? "Downloading..." : "Paused"
        }
        
        cell.pauseButton.isHidden = !showDownloadControls
        cell.cancelButton.isHidden = !showDownloadControls
        cell.progressView.isHidden = !showDownloadControls
        cell.progressLabel.isHidden = !showDownloadControls
        
        // If the track is already downloaded, enable cell selection and hide the download button
        cell.selectionStyle = track.downloaded ? UITableViewCellSelectionStyle.gray : UITableViewCellSelectionStyle.none
        cell.downloadButton.isHidden = track.downloaded || showDownloadControls
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    // When user taps cell, play the local file, if it's downloaded
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = searchResults[indexPath.row]
        if track.downloaded {
            playDownload(track)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - TrackCellDelegate
// Called by track cell to identify track for index path row,
// then pass this to download service method.
extension DetailViewController: TrackCellDelegate {
    
    func downloadTapped(_ cell: TrackCell) {
        if let indexPath = detailTableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.startDownload(track)
            reload(indexPath.row)
        }
    }
    
    func pauseTapped(_ cell: TrackCell) {
        if let indexPath = detailTableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.pauseDownload(track)
            reload(indexPath.row)
        }
    }
    
    func resumeTapped(_ cell: TrackCell) {
        if let indexPath = detailTableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.resumeDownload(track)
            reload(indexPath.row)
        }
    }
    
    func cancelTapped(_ cell: TrackCell) {
        if let indexPath = detailTableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.cancelDownload(track)
            reload(indexPath.row)
        }
    }
    
    // Update track cell's buttons
    func reload(_ row: Int) {
        detailTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
}

