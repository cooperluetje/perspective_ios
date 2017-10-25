//
//  CollectionViewController.swift
//  Perspective
//
//  Created by Cooper Luetje on 10/24/17.
//  Copyright © 2017 Cooper Luetje. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class UserPostsCollectionViewController: UICollectionViewController
{
    var user = User(id: -1, name: "", email: "", username: "", created_at: "", updated_at: "", auth_token: "")
    var userService = UserService(user: User(id: -1, name: "", email: "", username: "", created_at: "", updated_at: "", auth_token: ""))
    var apiRoutes = ApiRoutes()
    var feed:[Post] = []
    var feedImages:[UIImage] = []
    var page_num = 1
    var viewAppeared = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        feed = userService.getUserPosts(page_num: page_num)
        for post in feed
        {
            //User Post images
            let url = URL(string: post.picture_url)     //Must add apiRoutes.homeUrl if development server
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
                feedImages.append(UIImage(data: data)!)
            }
        }
        page_num += 1
        
        viewAppeared = true
        if feed == []
        {
            //indicator.isHidden = true
            //noPostsLabel.isHidden = false
        }
        self.collectionView!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return feed.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        cell.backgroundColor = UIColor.black
    
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
