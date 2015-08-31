////
////  MediaButton.swift
////  PrivateConcert
////
////  Created by Spoorthy Vemula on 7/28/15.
////  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
////
//
////import UIKit
//
//class MediaButton: UIButton {
//    
////    //images
////    let playImage = UIImage(named: "Play1") as UIImage?
////    let pauseImage = UIImage(named: "Pause2") as UIImage?
////    var buttonRow: Int = 0
//    
////    //setting Boolean
////    var isPaused: Bool = true {
////        didSet {
////            if isPaused == false {
////                //self.setImage(pauseImage, forState: .Normal)
////                println("Row \(buttonRow) is paused")
////            } else {
////                //self.setImage(playImage, forState: .Normal)
////            }
////        }
////    }
////    
////    func buttonClicked (sender: UIButton) {
////        currRow = buttonRow
////        println(currRow)
////        if (sender == self) {
////            if isPaused == false {
////                isPaused = true
////            } else {
////                isPaused = false
////            }
////        }
////    }
//    
//    
//    //load Nib . . .
//    override func awakeFromNib() {
//        //self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
//        //isPaused = true
//    }
//    
//    
//    
//    
//    
//    /*
//    // Only override drawRect: if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//    // Drawing code
//    }
//    */
//    
//}