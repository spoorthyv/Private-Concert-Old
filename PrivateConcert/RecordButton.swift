//
//  RecordButton.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 7/29/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import UIKit

class RecordButton: UIButton {
    
    //images
    let recordImage = UIImage(named: "Record") as UIImage?
    let stopRecordImage = UIImage(named: "RecordStop") as UIImage?
    
    
    //setting Boolean
    var isRecording: Bool = false {
        didSet {
            if isRecording == false {
                self.setImage(recordImage, forState: .Normal)
            } else {
                self.setImage(stopRecordImage, forState: .Normal)
            }
        }
    }
    
    
    //load Nib . . .
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.isRecording = false
    }
    
    
    func buttonClicked (sender: UIButton){
        
        if(sender == self) {
            if isRecording == false {
                isRecording = true
            } else {
                isRecording = false
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
