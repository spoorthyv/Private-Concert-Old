//
//  File.swift
//  PrivateConcert
//
//  Created by Spoorthy Vemula on 8/13/15.
//  Copyright (c) 2015 Spoorthy Vemula. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    
    func flagPost(objectID: String) {
        let flagObject = PFObject(className: "Flag")
        flagObject.setObject(PFUser.currentUser()!, forKey: "fromUser")
        flagObject.setObject(objectID, forKey: "toSong")
        
        let ACL = PFACL(user: PFUser.currentUser()!)
        ACL.setPublicReadAccess(true)
        flagObject.ACL = ACL
        
        flagObject.save()
    }
}