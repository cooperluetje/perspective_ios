//
//  TabBarController.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/18/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        if item.tag == 0
        {
            let navController = self.viewControllers?.first as! UINavigationController
            let homeController = navController.viewControllers.first as! HomeTableViewController
            if homeController.feed.count > 0
            {
                let indexPath = IndexPath.init(row: 0, section: 0)
                homeController.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
                homeController.tableView.reloadData()
            }
        }
    }

}
