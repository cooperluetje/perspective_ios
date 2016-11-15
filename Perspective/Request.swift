//
//  Request.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/14/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import Foundation

class Request
{
    var getDictionary:NSDictionary!
    var postDictionary:NSDictionary!
    
    init()
    {
        
    }
    
    func getRequest(url:String, params: [String:AnyObject], headers: [String:String]?, finished: @escaping () -> Void)
    {
        guard let thisUrl = URL(string: url) else
        {
            print("Error: URL is invalid")
            return
        }
        
        var request = URLRequest(url: thisUrl)
        
        request.httpMethod = "GET"
        
        for header in headers!
        {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            
            //Check for an error
            if error != nil
            {
                print("Error in GET: \(error)")
                return
            }
            
            /*
             //Print out the response from the server for debugging
             let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
             print("responseString = \(responseString)")
             */
            
            var get:NSDictionary = [:]
            
            //Convert json into NSDictionary
            do
            {
                get = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
            self.getDictionary = get
            
            finished()
        }
        
        task.resume()
    }
    
    func postRequest(url:String, params: [String:AnyObject]?, headers: [String:String]?, jsonData: Data?, finished: @escaping () -> Void)
    {
        guard let thisUrl = URL(string: url) else
        {
            print("Error: URL is invalid")
            return
        }
        
        var request = URLRequest(url: thisUrl)
        
        request.httpMethod = "POST"
        
        //Set parameters
        var body = ""
        //Combines parameters into string to be placed into the body
        if jsonData?.count == 0
        {
            for (i, param) in (params?.enumerated())!
            {
                body += "\(param.key)=\(param.value)"
                if i != (params?.count)!-1
                {
                    body += "&"
                }
            }
            request.httpBody = body.data(using: String.Encoding.utf8)
        }
        else
        {
            request.httpBody = jsonData
        }
        
        for header in headers!
        {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        let task = URLSession.shared.dataTask(with: request)
        {
            data, response, error -> Void in
            
            //Check for an error
            if error != nil
            {
                print("Error in POST: \(error)")
                return
            }
            
            
             //Print out the response from the server for debugging
             let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
             print("responseString = \(responseString)")
 
            
            var post:NSDictionary = [:]
            
            //Convert json into NSDictionary
            do
            {
                post = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
            }
            catch let error as NSError
            {
                print("ERROR: \(error.localizedDescription)")
            }
            self.postDictionary = post
            
            //Task is finished
            finished()
        }
        
        task.resume()
        
    }
    
}
