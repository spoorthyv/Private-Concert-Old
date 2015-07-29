//
//  TabBarController.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 7/27/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UIViewController {
    
    var currentViewController: UIViewController?
    @IBOutlet var placeholderView: UIView!
    @IBOutlet var tabBarButtons: Array<UIButton>!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if(tabBarButtons.count > 0) {
            performSegueWithIdentifier("SecondVCIdentifier", sender: tabBarButtons[1])
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let availableIdentifiers = ["FirstVCIdentifier", "SecondVCIdentifier", "ThirdVCIdentifier"]
        
        if(contains(availableIdentifiers, segue.identifier!)) {
            
            for btn in tabBarButtons {
                btn.selected = false
            }
            
            let senderBtn = sender as! UIButton
            senderBtn.selected = true
            
        }
    }
    
}

