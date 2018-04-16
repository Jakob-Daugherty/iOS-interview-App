//
//  Alert.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/15/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import Foundation
import UIKit

extension MasterViewController {
    
    /**
     Display Alert when the ImagePicker sourceType is unavailable
     
     - parameter source: UIImagePickerControllerSourceType
     */
//    func cantOpenPicker(withSource source:UIImagePickerControllerSourceType) {
//        
//        let sourceName : String
//        
//        switch source {
//        case .camera : sourceName = "Camera"
//        case .photoLibrary : sourceName = "Photo Library"
//        case .savedPhotosAlbum : sourceName = "Saved Photos Album"
//        }
//        
//        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        
//        let alertVC = UIAlertController(title: "Sorry", message: "Can't access your \(sourceName)", preferredStyle: .alert)
//        
//        alertVC.addAction(alertAction)
//        
//        self.present(alertVC, animated: true, completion: nil)
//    }
    
    /**
     Display Alert when loadImages had no results
     */
    func noImagesFound() {
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        let alertVC = UIAlertController(title: "No Images Found", message: "There were no images saved in Core Data", preferredStyle: .alert)
        
        alertVC.addAction(alertAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
}
