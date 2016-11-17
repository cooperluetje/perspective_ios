//
//  Post.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/17/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import Foundation

class Post: NSObject , NSCoding
{
    var id:Int
    var content:String
    var user_id:Int
    var created_at:String
    var updated_at:String
    var picture_url:String
    
    init(id:Int, content:String, user_id:Int, created_at:String, updated_at:String, picture_url:String)
    {
        self.id = id
        self.content = content
        self.user_id = user_id
        self.created_at = created_at
        self.updated_at = updated_at
        self.picture_url = picture_url
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let id = aDecoder.decodeInteger(forKey: "id")
        let content = aDecoder.decodeObject(forKey: "content") as! String
        let user_id = aDecoder.decodeObject(forKey: "user_id") as! Int
        let created_at = aDecoder.decodeObject(forKey: "created_at") as! String
        let updated_at = aDecoder.decodeObject(forKey: "updated_at") as! String
        let picture_url = aDecoder.decodeObject(forKey: "picture_url") as! String
        
        self.init(id:id, content:content, user_id:user_id, created_at:created_at, updated_at:updated_at, picture_url:picture_url)
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.content, forKey: "content")
        aCoder.encode(self.user_id, forKey: "user_id")
        aCoder.encode(self.created_at, forKey: "created_at")
        aCoder.encode(self.updated_at, forKey: "updated_at")
        aCoder.encode(self.picture_url, forKey: "picture_url")
    }
    
}
