//
//  CoreDataSetup.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/15/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import Foundation
import CoreData
import UIKit


extension MasterViewController {
    
    /**
     Start Core Data managed context on the correct queue
     */
    func coreDataSetup() {
        Run.sync(coreDataQueue) {
            self.managedContext = AppDelegate().managedObjectContext
        }
        
    }
}
