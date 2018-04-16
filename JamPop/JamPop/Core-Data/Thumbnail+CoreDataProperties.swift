//
//  Thumbnail+CoreDataProperties.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/15/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//
//

import Foundation
import CoreData

extension Thumbnail {
    
    @NSManaged var imageData: Data?
    @NSManaged var id: NSNumber?
    @NSManaged var fullRes: NSManagedObject?
    
}
//import Foundation
//import CoreData
//
//
//extension Thumbnail {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Thumbnail> {
//        return NSFetchRequest<Thumbnail>(entityName: "Thumbnail")
//    }
//
//    @NSManaged public var id: Double
//    @NSManaged public var imageData: NSData?
//    @NSManaged public var fullRes: FullRes?
//
//}

