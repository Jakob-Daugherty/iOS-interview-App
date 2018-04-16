//
//  FullRes+CoreDataClass.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/15/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//
//

import Foundation
import UIKit

extension FullRes {
    
    /// Convenience Property to get set the imageDate with a UIImage
    var image : UIImage? {
        get {
            if let imageData = imageData {
                return UIImage(data: imageData as Data)
            }
            return nil
        }
        set(value) {
            if let value = value {
                imageData = UIImageJPEGRepresentation(value, 1)! as? NSData
            }
        }
    }
}
