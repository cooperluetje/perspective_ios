//
//  SessionService.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/14/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import Foundation

class SessionService
{
    var apiRoutes:ApiRoutes
    var requests:Request
    var params:[String:String]!
    var headers:[String:String]!
    var error:String!
    
    init()
    {
        self.apiRoutes = ApiRoutes()
        self.requests = Request()
        self.params = [:]
        self.headers = [:]
        self.error = ""
    }
    
    func login(username:String, password:String) -> User
    {
        var user = User(id: -1, name: "", email: "", username: "", created_at: "", updated_at: "")
        let request = DispatchGroup.init()
        
        let url = apiRoutes.session.login
        
        let innerParams = ["username" : username, "password" : password, "remember_me" : "0"]
        
        let params = ["session" : innerParams]
        
        var jsonData:Data = Data()
        do
        {
            jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        catch let error as NSError
        {
            print("ERROR: \(error.localizedDescription)")
        }
        
        let headers = ["Content-Type" : "application/json"]
        
        request.enter()
        
        requests.postRequest(url: url, params: (params as [String : AnyObject]?)!, headers: headers, jsonData: jsonData, finished: {
            () in
            request.leave()
        })
        
        request.wait()
        
        // If user exist in the returned data from POST
        if requests.postDictionary["user"] != nil && (requests.postDictionary["user"]! as AnyObject).count != 0
        {
            let val = requests.postDictionary.value(forKey: "user")! as AnyObject
            let id = val.value(forKey: "id") as! Int
            let name = val.value(forKey: "name")! as! String
            let email = val.value(forKey: "email")! as! String
            let username = val.value(forKey: "username")! as! String
            let created_at = val.value(forKey: "created_at")! as! String
            let updated_at = val.value(forKey: "updated_at") as! String
            user = User(id: id, name: name, email: email, username: username, created_at: created_at, updated_at: updated_at)
        }
        
        if requests.postDictionary["error"] != nil
        {
            error = requests.postDictionary.value(forKey: "error")! as! String
        }
        else
        {
            error = ""
        }
        
        return user
    }
    
}
