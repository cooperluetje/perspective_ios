//
//  SettingsViewController.swift
//  Perspective
//
//  Created by Cooper Luetje on 12/14/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutButton(_ sender: UIButton)
    {
        let logOutAlert = UIAlertController(title: "Log out", message: "Are you sure you would like to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        logOutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            //Delete the User data
            let defaults = UserDefaults.standard
            let key = "user"
            defaults.removeObject(forKey: key)
            defaults.synchronize()
            
            //Redirect to the log in controller
            self.performSegue(withIdentifier: "logOut", sender: self)
        }))
        
        logOutAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {  (action: UIAlertAction!) in
        }))
        
        present(logOutAlert, animated: true, completion: nil)
    }
}
