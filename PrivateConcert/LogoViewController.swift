//
//  LogoViewController.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 8/9/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import Parse
import UIKit
import ParseUI

class LogoViewController : PFLogInViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGrayColor()
        let logoView = UIImageView(image: UIImage(named:"Loading Screen"))
        self.logInView!.logo = logoView
    }
}
