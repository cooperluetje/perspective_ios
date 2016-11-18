//
//  HomeTableViewController.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/15/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController
{
    var user = User(id: -1, name: "", email: "", username: "", created_at: "", updated_at: "", auth_token: "")
    var userService = UserService(user: User(id: -1, name: "", email: "", username: "", created_at: "", updated_at: "", auth_token: ""))
    var apiRoutes = ApiRoutes()
    var feed:[Post] = []
    var page_num = 1
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set title font
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "CaviarDreams", size: 20)!]

        //Get user info
        let defaults = UserDefaults.standard
        let key = "user"
        if defaults.object(forKey: key) != nil
        {
            if let value = defaults.object(forKey: key) as? NSData
            {
                user = NSKeyedUnarchiver.unarchiveObject(with: value as Data) as! User
                userService = UserService(user: user)
            }
        }
        
        feed = userService.getUserFeed(user_id: user.id, page_num: page_num)
        page_num += 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return feed.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        let post = feed[indexPath.row]
        let user = userService.getUser(user_id: post.user_id)
        let gravatarData = MD5(string: user.email)
        let gravatarHex = gravatarData!.map { String(format: "%02hhx", $0) }.joined()
        var url = URL(string: apiRoutes.gravatarUrl + gravatarHex)
        var data = Data()
        do
        {
            data = try Data(contentsOf: url!)
        }
        catch let error as NSError
        {
            print("ERROR: \(error.localizedDescription)")
        }
        if data.count != 0
        {
            cell.userImage.contentMode = UIViewContentMode.scaleAspectFit
            cell.userImage.image = UIImage(data: data)
        }
        cell.usernameLabel.text = user.username
        
        url = URL(string: apiRoutes.homeUrl + post.picture_url)
        data = Data()
        do
        {
            data = try Data(contentsOf: url!)
        }
        catch let error as NSError
        {
            print("ERROR: \(error.localizedDescription)")
        }
        if data.count != 0
        {
            cell.mainImage.contentMode = UIViewContentMode.scaleAspectFit
            cell.mainImage.image = UIImage(data: data)
        }
        
        /*
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sssz"
         let date = dateFormatter!.date(from: post.created_at)!
         dateFormatter.dateFormat = "MM-dd-yyyy"
         */
        cell.dateLabel.text = post.created_at
        
        let bottom_border = UIView(frame: CGRect(x: 0, y: 463, width: self.view.bounds.width, height: 1))
        bottom_border.backgroundColor = UIColor.lightGray
        cell.addSubview(bottom_border)
        
        return cell
    }
    
    //For gravatar
    func MD5(string: String) -> Data?
    {
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil}
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in messageData.withUnsafeBytes {messageBytes in CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData
    }

}
