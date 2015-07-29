//
//  MediaButton.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 7/28/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import UIKit

class MediaButton: UIButton {

    //images
    let playImage = UIImage(named: "GreenPlay") as UIImage?
    let pauseImage = UIImage(named: "PurplePause") as UIImage?
    var cellRow: Int = 0
    
    
    //setting Boolean
    var isPaused: Bool = true{
        didSet{
            if isPaused == false{
                
                self.setImage(pauseImage, forState: .Normal)
                
            } else {
                self.setImage(playImage, forState: .Normal)
            }
            
        }
        
    }
    
    
    //load Nib . . .
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.isPaused = true
    }
    
    
    func buttonClicked (sender: UIButton){
                
        if(sender == self)
         {
           if isPaused == false
         {
            isPaused = true
                        
            } else{
                 isPaused = false
             }
           }
        }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
