//
//  CGSizeExtension.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/15/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    
    /**
     Calculate scaled size with the same aspect ratio
     
     - parameter toSize: target size
     
     - returns: scaled size
     */
    func resizeFill(_ toSize: CGSize) -> CGSize {
        
        let scale : CGFloat = (self.height / self.width) < (toSize.height / toSize.width) ? (self.height / toSize.height) : (self.width / toSize.width)
        return CGSize(width: (self.width / scale), height: (self.height / scale))
        
    }
}
