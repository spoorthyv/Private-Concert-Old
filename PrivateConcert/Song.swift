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
    //change audio later
    var audio: String
    var score: Int
    
    init (title: String, tags: [String]) {
        self.name = title
        self.tags = tags
        self.audio = "Blank"
        self.score = 0
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
