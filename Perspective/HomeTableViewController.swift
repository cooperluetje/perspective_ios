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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        userService.getUserFeed(user_id: user.id, page_num: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        if indexPath.row % 3 == 0
        {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! HeaderTableViewCell
            headerCell.userImage.image = #imageLiteral(resourceName: "HomeIcon")
            headerCell.usernameLabel.text = "USERNAME"
            return headerCell
        }
        else if indexPath.row % 3 == 1
        {
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageTableViewCell
            imageCell.mainImage.image = #imageLiteral(resourceName: "HomeIcon")
            return imageCell
        }
        else if indexPath.row % 3 == 2
        {
            let footerCell = tableView.dequeueReusableCell(withIdentifier: "footerCell", for: indexPath) as! FooterTableViewCell
            footerCell.dateLabel.text = "DATE"
            
            let bottom_border = UIView(frame: CGRect(x: 0, y: 40, width: self.view.bounds.width, height: 1))
            bottom_border.backgroundColor = UIColor.lightGray
            footerCell.addSubview(bottom_border)
            
            return footerCell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row % 3 == 0
        {
            return 44
        }
        else if indexPath.row % 3 == 1
        {
            return 376
        }
        else if indexPath.row % 3 == 2
        {
            return 44
        }
        return 44
    }

}
