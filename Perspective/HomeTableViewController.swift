//
//  HomeTableViewController.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/15/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import UIKit
import CoreLocation

class HomeTableViewController: UITableViewController, CLLocationManagerDelegate
{
    var user = User(id: -1, name: "", email: "", username: "", created_at: "", updated_at: "", auth_token: "")
    var userService = UserService(user: User(id: -1, name: "", email: "", username: "", created_at: "", updated_at: "", auth_token: ""))
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let locationManager = CLLocationManager()
    var apiRoutes = ApiRoutes()
    var time = Time()
    var feed:[Post] = []
    var feedImages:[UIImage] = []
    var userImages:[UIImage] = []
    var page_num = 1
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(HomeTableViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)

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
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            let location:CLLocationCoordinate2D = (locationManager.location?.coordinate)!
            userService.updateLocation(latitude: "\(location.latitude)", longitude: "\(location.longitude)", auth_token: user.auth_token)
        }
        
        feed = userService.getUserFeed(user_id: user.id, page_num: page_num)
        for post in feed
        {
            let user = userService.getUser(user_id: post.user_id)
            let gravatarData = MD5(string: user.email)
            let gravatarHex = gravatarData!.map { String(format: "%02hhx", $0) }.joined()
            var url = URL(string: apiRoutes.gravatarUrl + gravatarHex)
            
            //User profile images
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
                userImages.append(UIImage(data: data)!)
            }
            
            //Feed images
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
                feedImages.append(UIImage(data: data)!)
            }
        }
        page_num += 1
        
        indicator.center = CGPoint.init(x: self.view.bounds.width / 2.0, y: indicator.center.y + 11)        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        //let location = manager.location?.coordinate
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row == feed.count
        {
            let newFeed:[Post] = userService.getUserFeed(user_id: user.id, page_num: page_num)
            if newFeed != []
            {
                feed.append(contentsOf: newFeed)
                for post in newFeed
                {
                    let user = userService.getUser(user_id: post.user_id)
                    let gravatarData = MD5(string: user.email)
                    let gravatarHex = gravatarData!.map { String(format: "%02hhx", $0) }.joined()
                    var url = URL(string: apiRoutes.gravatarUrl + gravatarHex)
                    
                    //User profile images
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
                        userImages.append(UIImage(data: data)!)
                    }
                    
                    //Feed images
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
                        feedImages.append(UIImage(data: data)!)
                    }
                }
                page_num += 1
                tableView.reloadData()
            }
            else
            {
                // End of data
                indicator.stopAnimating()
            }
        }
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
        return feed.count+1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row <= feed.count-1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
            let post = feed[indexPath.row]
            let user = userService.getUser(user_id: post.user_id)
            
            cell.userImage.contentMode = UIViewContentMode.scaleAspectFit
            cell.userImage.image = userImages[indexPath.row]
            
            cell.usernameLabel.text = user.username
            
            cell.mainImage.image = feedImages[indexPath.row]
            
            cell.dateLabel.text = time.timeAgoInWords(dateString: post.created_at)
            
            let bottom_border = UIView(frame: CGRect(x: 0, y: 463, width: self.view.bounds.width, height: 1))
            bottom_border.backgroundColor = UIColor.lightGray
            cell.addSubview(bottom_border)
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) 
            
            indicator.startAnimating()
            cell.addSubview(indicator)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row > feed.count-1
        {
            return 44
        }
        else
        {
            return 464
        }
    }
    
    func handleRefresh(refreshControl:UIRefreshControl)
    {
        page_num = 1
        feed = userService.getUserFeed(user_id: user.id, page_num: page_num)
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
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
