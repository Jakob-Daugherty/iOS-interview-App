//
//  UIImageExtensions.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/15/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /**
     Scales the image to a target size
     
     - parameter newSize: the target size
     
     - returns: the scaled image
     */
    func scale(toSize newSize:CGSize) -> UIImage {
        
        // make sure the new size has the correct aspect ratio
        let aspectFill = self.size.resizeFill(newSize)
        
        UIGraphicsBeginImageContextWithOptions(aspectFill, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: aspectFill.width, height: aspectFill.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
