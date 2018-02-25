//
//  Post.swift
//  AngelicChat
//
//  Created by Sarah Villegas  on 2/24/18.
//  Copyright © 2018 angel gonzalez. All rights reserved.
//

import UIKit
import Parse

class Message: PFObject, PFSubclassing {

    @NSManaged var text: String?
    @NSManaged var user: PFUser
    @NSManaged var avatar: String?
    
    class func parseClassName() -> String {
        return "Message"
    }
    
    override class func query() -> PFQuery<PFObject>?{
        
        let query = PFQuery(className: Message.parseClassName())
        query.includeKey("text")
        query.includeKey("user")
        query.includeKey("avatarURL")
        query.addDescendingOrder("createdAt")
        
        return query
        
    }
    
//    class func fetchNewMessage() -> [Message]?{
//        
//        let query = Message.query()!
//        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
//            
//            if messages != nil{
//                
//                print(messages)
//            }
//            else{
//                print(error?.localizedDescription)
//            }
//        }
//        return mess
//    }
    
    
}
