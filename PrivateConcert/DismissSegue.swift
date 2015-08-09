//
//  DismissSegue.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 8/4/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {
    override func perform() {
        var sourceViewController: UIViewController = self.sourceViewController as! UIViewController
        sourceViewController.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

