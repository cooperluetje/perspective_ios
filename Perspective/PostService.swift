//
//  PostService.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/19/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import Foundation
import UIKit

class PostService
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
    
    func createPost(image:UIImage, latitude:String, longitude:String, auth_token:String) -> Int
    {
        var micropost_id = -1
        //Create base64 data of image
        let imageData:Data = UIImageJPEGRepresentation(image, 1)!
        let base64Data:String = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        
        let request = DispatchGroup.init()
        
        let url = apiRoutes.posts.createPost
        
        let locationParams = ["latitude" : latitude, "longitude" : longitude]
        
        let innerParams = ["picture" : "data:image/jpg;base64,(\(base64Data))"]
        
        let params = ["authenticity_token" : auth_token, "micropost" : innerParams, "location" : locationParams] as [String : Any]
        
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
        
        if requests.postDictionary["error"] != nil
        {
            error = requests.postDictionary.value(forKey: "error")! as! String
        }
        else
        {
            error = ""
            if requests.postDictionary["micropost_id"] != nil
            {
                micropost_id = requests.postDictionary.value(forKey: "micropost_id") as! Int
            }
        }
        return micropost_id
    }
    
    func updateLocation(latitude:String, longitude:String, auth_token:String)
    {
        let request = DispatchGroup.init()
        
        let url = apiRoutes.user.updateLocation
        
        let innerParams = ["latitude" : latitude, "longitude" : longitude]
        
        let params = ["authenticity_token" : auth_token, "location" : innerParams] as [String : Any]
        
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
        
        if requests.postDictionary["error"] != nil
        {
            error = requests.postDictionary.value(forKey: "error")! as! String
        }
        else
        {
            error = ""
        }
    }
    
}
