//
//  Song.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 7/27/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Song: NSObject {
    var name: String
    var tags: [String]
    var score: Int
    var user: PFUser
    
    //change audio later
    var audio: NSData
    
    init (title: String, tags: [String], musicData: NSData) {
        self.name = title
        self.tags = tags
        self.audio = NSData()
        self.score = 0
        self.user = PFUser.currentUser()!
    }
    
    func tagLine() -> String {
        var tagLine = ""
        if tags.count > 0 {
            tagLine = tags[0]
            for var i = 1; i<tags.count; ++i {
                tagLine += " | " + tags[i]
            }
        }
        
        return tagLine
    }
}
