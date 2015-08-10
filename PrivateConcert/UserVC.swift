//
//  UserVC.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 8/10/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import Foundation
import UIKit
import Parse

class UserVC: UIViewController {
    @IBAction func Logout(sender: AnyObject) {
        if (hasPopup){
        } else {
            PFUser.logOut()
            performSegueWithIdentifier("goBackToLogin2", sender: self)
        }
    }
    
}