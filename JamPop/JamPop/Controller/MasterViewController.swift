//
//  MasterViewController.swift
//  JamPop
//
//  Created by Jakob Daugherty on 3/28/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    let queryService = QueryService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        self.tableView.rowHeight = 100.0 
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        queryService.getAlbumResults() { results, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let results = results {
                self.objects = results
                self.tableView.reloadData()
                //self.tableView.setContentOffset(CGPoint.zero, animated: false)
            }
            if !errorMessage.isEmpty { print("Search error: \n" + errorMessage) }
        }

        let addButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
//        objects.insert(NSDate(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        queryService.getAlbumResults() { results, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let results = results {
                self.objects = results
                self.tableView.reloadData()
                //self.tableView.setContentOffset(CGPoint.zero, animated: false)
            }
            if !errorMessage.isEmpty { print("Search error: \n" + errorMessage) }
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! Album
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row] as! Album
        cell.textLabel!.text = object.name
        cell.detailTextLabel!.text = object.artistName
        //let imageView = UIImageView(frame: CGRectMake(10, 10, cell.frame.width - 10, cell.frame.height - 10))
        
        let image = UIImage(data: try! Data(contentsOf: URL(string: object.artworkUrl100)!))!
        //imageView.image = image
        //Just add imageView as subview of cell
        //cell.addSubview(imageView)
        //cell.sendSubview(toBack: imageView)
        //cell.backgroundView = UIView()
        //cell.backgroundView!.addSubview(imageView)
        //let image = queryService.getAlbumArt(object.artworkUrl100)
        cell.imageView?.image = image
        cell.backgroundColor = colorForIndex(index: indexPath.row)
//        cell.imageView?.image = object.artworkUrl100.
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = objects.count - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 0.0, green: color, blue: 1.0, alpha: 1.0)
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
//                            forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.backgroundColor = colorForIndex(index: indexPath.row)
//    }


}

