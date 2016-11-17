//
//  UserService.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/15/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import Foundation

class UserService
{
    var apiRoutes:ApiRoutes
    var requests:Request
    var params:[String:String]!
    var headers:[String:String]!
    var error:String!
    var user:User!
    
    init(user:User)
    {
        self.apiRoutes = ApiRoutes()
        self.requests = Request()
        self.params = [:]
        self.headers = [:]
        self.error = ""
        self.user = user
    }
    
    func getUser(user_id:Int) -> User
    {
        let request = DispatchGroup.init()
        
        var url = apiRoutes.user.getUser
        
        //Add id to url
        let id = ("/" + String(user_id)).characters.reversed()
        
        for i in id.indices
        {
            url.insert(id[i], at: apiRoutes.user.indexForId())
        }
        
        request.enter()
        
        requests.getRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        
        // If user exist in the returned data from POST
        if requests.getDictionary["user"] != nil && (requests.getDictionary["user"]! as AnyObject).count != 0
        {
            let val = requests.postDictionary.value(forKey: "user")! as AnyObject
            let id = val.value(forKey: "id") as! Int
            let name = val.value(forKey: "name")! as! String
            let email = val.value(forKey: "email")! as! String
            let username = val.value(forKey: "username")! as! String
            let created_at = val.value(forKey: "created_at")! as! String
            let updated_at = val.value(forKey: "updated_at") as! String
            user = User(id: id, name: name, email: email, username: username, created_at: created_at, updated_at: updated_at, auth_token: "")
        }
        
        if requests.getDictionary["error"] != nil
        {
            error = requests.getDictionary.value(forKey: "error")! as! String
        }
        else
        {
            error = ""
        }
        
        return user
    }
    
    func getUserPosts(page_num:Int) -> [Post]
    {
        var posts:[Post] = []
        let request = DispatchGroup.init()
        
        var url = apiRoutes.posts.getUserMicroposts
        
        //Add page to url
        let page = ("?page=" + String(page_num)).characters.reversed()
        
        for i in page.indices
        {
            url.insert(page[i], at: apiRoutes.posts.indexForId())
        }
        
        request.enter()
        
        requests.getRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        
        // If user exist in the returned data from POST
        if requests.getDictionary["microposts"] != nil && (requests.getDictionary["microposts"]! as AnyObject).count != 0
        {
            let val = requests.getDictionary.value(forKey: "microposts")! as AnyObject
            for i in 0...(val.count-1)
            {
                let innerVal = val[i]! as AnyObject
                
                let id = innerVal.value(forKey: "id")! as! Int
                let content = innerVal.value(forKey: "content")! as! String
                let user_id = innerVal.value(forKey: "user_id")! as! Int
                let created_at = innerVal.value(forKey: "created_at")! as! String
                let updated_at = innerVal.value(forKey: "updated_at") as! String
                let picture = innerVal.value(forKey: "picture")! as AnyObject
                let picture_url = picture.value(forKey: "url") as! String
                let post = Post(id: id, content: content, user_id: user_id, created_at: created_at, updated_at: updated_at, picture_url: picture_url)
                posts.append(post)
            }
        }
        
        if requests.postDictionary["error"] != nil
        {
            error = requests.postDictionary.value(forKey: "error")! as! String
        }
        else
        {
            error = ""
        }
        
        return posts
    }
    
    func getUserFeed(user_id:Int, page_num:Int) -> [Post]
    {
        var posts:[Post] = []
        let request = DispatchGroup.init()
        
        var url = apiRoutes.user.getFeed
        
        //Add id and page to url
        let page = ("/" + String(user_id) + "/feed?page=" + String(page_num)).characters.reversed()
        
        for i in page.indices
        {
            url.insert(page[i], at: apiRoutes.user.indexForId())
        }
        
        request.enter()
        
        requests.getRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        
        // If user exist in the returned data from POST
        if requests.getDictionary["feed"] != nil && (requests.getDictionary["feed"]! as AnyObject).count != 0
        {
            let val = requests.getDictionary.value(forKey: "feed")! as AnyObject
            for i in 0...(val.count-1)
            {
                let innerVal = val[i]! as AnyObject
                
                let id = innerVal.value(forKey: "id")! as! Int
                let content = innerVal.value(forKey: "content")! as! String
                let user_id = innerVal.value(forKey: "user_id")! as! Int
                let created_at = innerVal.value(forKey: "created_at")! as! String
                let updated_at = innerVal.value(forKey: "updated_at") as! String
                let picture = innerVal.value(forKey: "picture")! as AnyObject
                let picture_url = picture.value(forKey: "url") as! String
                let post = Post(id: id, content: content, user_id: user_id, created_at: created_at, updated_at: updated_at, picture_url: picture_url)
                posts.append(post)
            }
        }
        
        if requests.getDictionary["error"] != nil
        {
            error = requests.getDictionary.value(forKey: "error")! as! String
        }
        else
        {
            error = ""
        }
        
        return posts
    }
    
}
