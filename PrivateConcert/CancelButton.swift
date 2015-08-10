//
//  CancelButton.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 8/9/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import Foundation
import UIKit



class CancelButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.clearColor()
        self.tintColor = UIColor.whiteColor()
        self.setTitleColor(UIColor.grayColor(), forState: .Normal)
        
    }
}

