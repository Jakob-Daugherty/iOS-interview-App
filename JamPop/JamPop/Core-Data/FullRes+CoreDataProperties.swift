//
//  FullRes+CoreDataProperties.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/15/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//
//

import Foundation
import CoreData


extension FullRes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FullRes> {
        return NSFetchRequest<FullRes>(entityName: "FullRes")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var thumbnail: Thumbnail?

}
