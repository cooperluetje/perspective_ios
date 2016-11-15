//
//  LoginViewController.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/14/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    // MARK: Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var sessionService:SessionService!

    override func viewDidLoad() {
        super.viewDidLoad()

        sessionService = SessionService()
    }
    
    @IBAction func loginButton(_ sender: UIButton)
    {
        if usernameTextField.text == "" || passwordTextField.text == ""
        {
            errorLabel.text = "Please enter a correct username and password."
        }
        else
        {
            let user = sessionService.login(username: usernameTextField.text!, password: passwordTextField.text!)
            errorLabel.text = sessionService.error
            
            
            //Go to the logged in views and save user to disk
            if(errorLabel.text == "")
            {
                
                let defaults = UserDefaults.standard
                let key = "user"
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: user)
                
                defaults.setValue(encodedData, forKey: key)
                defaults.synchronize()
                
                performSegue(withIdentifier: "login", sender: self)
                
                usernameTextField.text = ""
                passwordTextField.text = ""
                errorLabel.text = ""
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
