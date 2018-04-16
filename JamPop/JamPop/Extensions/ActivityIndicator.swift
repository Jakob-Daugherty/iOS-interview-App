//
//  ActivityIndicator.swift
//  JamPop
//
//  Created by Jakob Daugherty on 4/15/18.
//  Copyright © 2018 Jakob Daugherty. All rights reserved.
//

import Foundation
import UIKit

extension MasterViewController {
    
    func startActivity() {
        Run.main {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            //elf.activityIndicator.isHidden = false
            //self.activityIndicator.startAnimating()
        }
    }
    
    func stopActivity() {
        Run.main {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            self.activityIndicator.isHidden = true
//            self.activityIndicator.stopAnimating()
        }
    }
}
