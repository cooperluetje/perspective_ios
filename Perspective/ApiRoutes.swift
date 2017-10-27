//
//  ApiRoutes.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/14/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import Foundation

class ApiRoutes
{
    var session:Session
    var user:User
    var posts:Posts
    var homeUrl:String
    var gravatarUrl:String
    
    init()
    {
        self.session = Session()
        self.user = User()
        self.posts = Posts()
        //self.homeUrl = "https://perspective-koopaluigi.c9users.io"
        self.homeUrl = "https://infinite-brushlands-36763.herokuapp.com"
        self.gravatarUrl = "https://www.gravatar.com/avatar/"
    }
    
    struct Session
    {
        //let api = "https://perspective-koopaluigi.c9users.io/api/login"       //Testing
        let api = "https://infinite-brushlands-36763.herokuapp.com/api/login"
        
        var login:String                    // POST     ()          (username, password)
        var verify:String                   // POST     ()          (username, token)
        
        init()
        {
            login = api + "/"
            verify = "https://infinite-brushlands-36763.herokuapp.com/api/verify"
        }
        
        func indexForId() -> String.Index
        {
            return api.endIndex
        }
    }
    
    struct User
    {
        //let api = "https://perspective-koopaluigi.c9users.io/api/users"       //Testing
        let api = "https://infinite-brushlands-36763.herokuapp.com/api/users"
        
        var getAllUsers:String              // GET     ()          ()
        var getUser:String                  // GET     (use id)    ()
        var createUser:String               // POST    ()          (name, email, username, password, password_confirmation)
        var getFeed:String                  // GET     (id and page)
        var updateLocation:String           // POST    ()          (latitude, longitude)
        
        init()
        {
            getAllUsers = api + "/"
            getUser = api + "/"
            createUser = api + "/"
            getFeed = api + ""
            //updateLocation = "https://perspective-koopaluigi.c9users.io/api/locations"
            updateLocation = "https://infinite-brushlands-36763.herokuapp.com/api/locations"
        }
        
        func indexForId() -> String.Index
        {
            return api.endIndex
        }
    }
    
    struct Posts
    {
        //let api = "https://perspective-koopaluigi.c9users.io/api/microposts"       //Testing
        let api = "https://infinite-brushlands-36763.herokuapp.com/api/microposts"
        
        var getUserMicroposts:String        // GET     (use page)  ()
        var createPost:String               // POST    ()          (picture-base64, location)
        
        init()
        {
            getUserMicroposts = api + ""
            createPost = api + "/"
        }
        
        func indexForId() -> String.Index
        {
            return api.endIndex
        }
    }
}
