//
//  ViewController.swift
//  AngelicChat
//
//  Created by angel gonzalez on 2/23/18.
//  Copyright © 2018 angel gonzalez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        if(passwordField.text == "" || usernameField.text == ""){
            let alertController = UIAlertController(title: "Fields Empty", message: "Username or Password is empty", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            // Add the actions
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!){(
                user, error) -> Void in
                if user != nil {
                    print("logged in")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                else{
                    let alertController = UIAlertController(title: "Wrong Credentials", message: "User not found", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("Failed Login Ok Pressed")
                    }
                    // Add the actions
                    alertController.addAction(okAction)
                   self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackground() { (success, error) in
            if success
            {
                print("Created a badass user")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else
            {
                let alertController = UIAlertController(title: "Failed to make account", message: "Username taken", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    NSLog("Failed Sign Up Ok Pressed")
                }
                // Add the actions
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                let e = error! as NSError
                print(e.localizedDescription as Any)
                
                if e.code == 202 {
                    print("User name is taken")
                }
            }
        }
    }
    

}

