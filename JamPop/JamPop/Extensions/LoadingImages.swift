//
//  LoadingImages.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/15/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import Foundation
import UIKit
import CoreData


extension MasterViewController {
    
    /**
     Load all images saved by the App
     
     - parameter fetched: Completion Block for the background fetch.
     */
    func loadImages(_ fetched:@escaping (_ images:[Thumbnail]) -> Void) {
        
        startActivity()
        
        Run.async(coreDataQueue) {
            
            guard let moc = self.managedContext else {
                return
            }
            
            let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateMOC.parent = moc
            
            privateMOC.perform {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Const.CoreData.Thumbnail)
                
                do {
                    let results = try privateMOC.fetch(fetchRequest)
                    let maybeImageData = results as? [Thumbnail]
                    
                    guard let imageData = maybeImageData else {
                        Run.main {
                            self.noImagesFound()
                        }
                        return
                    }
                    
                    self.stopActivity()
                    Run.main {
                        fetched(imageData.filter { thumbnail in
                            return thumbnail.imageData != nil && thumbnail.id != nil
                        })
                    }
                } catch {
                    
                    self.stopActivity()
                    
                    Run.main {
                        self.noImagesFound()
                    }
                    return
                }
            }
        }
    }
}
