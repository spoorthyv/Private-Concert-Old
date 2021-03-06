//
//  TabBarController.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 7/27/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import Foundation
import UIKit
import Parse
import AVKit
import AVFoundation


class TabBarController: UIViewController {
    
    var currentViewController: UIViewController?
    @IBOutlet var placeholderView: UIView!
    @IBOutlet var tabBarButtons: Array<UIButton>!
    var player = AVPlayer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if(tabBarButtons.count > 0) {
            performSegueWithIdentifier("SecondVCIdentifier", sender: tabBarButtons[1])
        }
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        if (hasPopup){
        } else {
            PFUser.logOut()
            performSegueWithIdentifier("goBackToLogin", sender: self)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let availableIdentifiers = ["FirstVCIdentifier", "SecondVCIdentifier"]
        
        if(!hasPopup && contains(availableIdentifiers, segue.identifier!)) {
            
            for btn in tabBarButtons {
                btn.selected = false
                btn.backgroundColor = UIColor(red: 86/255, green: 163/255, blue: 209/255, alpha: 1.0)
            }
            
            let senderBtn = sender as! UIButton
            senderBtn.selected = true
            senderBtn.backgroundColor = UIColor.whiteColor()
            
        }
    }
    
}

