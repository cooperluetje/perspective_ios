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
    //var user:Users
    
    init()
    {
        self.session = Session()
    }
    
    struct Session
    {
        let api = "https://perspective-koopaluigi.c9users.io/api/login"       //Testing
        
        var login:String            // POST     ()          (username, password)
        
        init()
        {
            login = api + "/"
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
