
//
//  TabBar.swift
//  Private Concert
//
//  Created by Spoorthy Vemula on 7/14/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import UIKit

class TabBar: UITabBar {
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 100
        
        return sizeThatFits
    }
}
