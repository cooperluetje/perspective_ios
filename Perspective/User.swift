//
//  User.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/14/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import Foundation

class User: NSObject , NSCoding
{
    var id:Int
    var name:String
    var email:String
    var username:String
    var created_at:String
    var updated_at:String
    var auth_token:String
    
    init(id:Int, name:String, email:String, username:String, created_at:String, updated_at:String, auth_token:String)
    {
        self.id = id
        self.name = name
        self.email = email
        self.username = username
        self.created_at = created_at
        self.updated_at = updated_at
        self.auth_token = auth_token
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let id = aDecoder.decodeInteger(forKey: "id")
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let username = aDecoder.decodeObject(forKey: "username") as! String
        let created_at = aDecoder.decodeObject(forKey: "created_at") as! String
        let updated_at = aDecoder.decodeObject(forKey: "updated_at") as! String
        let auth_token = aDecoder.decodeObject(forKey: "auth_token") as! String
        
        self.init(id:id, name:name, email:email, username:username, created_at:created_at, updated_at:updated_at, auth_token:auth_token)
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")        
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.username, forKey: "username")
        aCoder.encode(self.created_at, forKey: "created_at")
        aCoder.encode(self.updated_at, forKey: "updated_at")
        aCoder.encode(self.auth_token, forKey: "auth_token")
    }
    
}
