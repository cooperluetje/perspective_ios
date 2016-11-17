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
    
    init()
    {
        self.session = Session()
        self.user = User()
        self.posts = Posts()
        self.homeUrl = "https://perspective-koopaluigi.c9users.io"
    }
    
    struct Session
    {
        let api = "https://perspective-koopaluigi.c9users.io/api/login"       //Testing
        
        var login:String                    // POST     ()          (username, password)
        
        init()
        {
            login = api + "/"
        }
        
        func indexForId() -> String.Index
        {
            return api.endIndex
        }
    }
    
    struct User
    {
        let api = "https://perspective-koopaluigi.c9users.io/api/users"       //Testing
        
        var getAllUsers:String              // GET     ()          ()
        var getUser:String                  // GET     (use id)    ()
        var createUser:String               // POST    ()          (name, email, username, password, password_confirmation)
        var getFeed:String                  // GET     (id and page)
        
        init()
        {
            getAllUsers = api + "/"
            getUser = api + "/"
            createUser = api + "/"
            getFeed = api + ""
        }
        
        func indexForId() -> String.Index
        {
            return api.endIndex
        }
    }
    
    struct Posts
    {
        let api = "https://perspective-koopaluigi.c9users.io/api/microposts"       //Testing
        
        var getUserMicroposts:String        // GET     (use page)  ()
        var createPost:String               // POST    ()          (name, email, username, password, password_confirmation)
        
        init()
        {
            getUserMicroposts = api + "/"
            createPost = api + "/"
        }
        
        func indexForId() -> String.Index
        {
            return api.endIndex
        }
    }
    
    /*
    struct Users
    {
        let api = "https://baseballsim-koopaluigi.c9users.io/api/users"       //Testing
        //let api = "https://baseballsim.herokuapp.com/api/users"                 //Heroku
        
        var getUsers:String         // GET      ()          ()
        var getUserTeams:String     // GET      (use id)    ()
        var getUserGames:String     // GET      (use id)    ()
        var createUser:String       // POST     ()          (username, password, firstname, lastname, email)
        var token:String            // POST     ()          (username, password)
        var validate:String         // POST     ()          (token)
        var deleteUserById:String   // DELETE   (use id)    ()
        
        init()
        {
            getUsers = api + "/"
            getUserTeams = api + "/teams"
            getUserGames = api + "/games"
            createUser = api + "/"
            token = api + "/token"
            validate = api + "/validate"
            deleteUserById = api + "/"
        }
        
        func indexForId() -> String.Index
        {
            return api.endIndex
        }
    }
    */
}
