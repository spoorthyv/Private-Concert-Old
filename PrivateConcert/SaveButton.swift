//
//  TitleButton.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 8/9/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import Foundation
import UIKit



class SaveButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        let redColor = UIColor(red: 250/255, green: 105/255, blue: 105/255, alpha: 0.7)
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = redColor.CGColor
        self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor.clearColor()
        self.tintColor = UIColor.whiteColor()
        self.setTitleColor(redColor, forState: .Normal)
        
    }
}

