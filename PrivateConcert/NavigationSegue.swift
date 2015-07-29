//
//  NavigationSegue.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 7/27/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import Foundation
import UIKit

class NavigationSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let tabBarController = self.sourceViewController as! TabBarController
        let destinationController = self.destinationViewController as! UIViewController
        
        for view in tabBarController.placeholderView.subviews as! [UIView] {
            view.removeFromSuperview() // 1
        }
        
        // Add view to placeholder view
        tabBarController.currentViewController = destinationController
        tabBarController.placeholderView.addSubview(destinationController.view) // 2
        
        // Set autoresizing
        tabBarController.placeholderView.setTranslatesAutoresizingMaskIntoConstraints(false)
        destinationController.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[v1]-0-|", options: .AlignAllTop, metrics: nil, views: ["v1": destinationController.view]) // 3
        
        tabBarController.placeholderView.addConstraints(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[v1]-0-|", options: .AlignAllTop, metrics: nil, views: ["v1": destinationController.view]) // 3
        
        tabBarController.placeholderView.addConstraints(verticalConstraint)
        
        tabBarController.placeholderView.layoutIfNeeded() // 3
        destinationController.didMoveToParentViewController(tabBarController) // 4
        
    }
    
}
