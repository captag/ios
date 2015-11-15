//
//  LoginViewController.swift
//  CapTag
//
//  Created by Edgar Kuskov on 12.11.15.
//  Copyright © 2015 Edgar Kuskov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let scrollViewWallSegue = "LoginSuccesful"
    let tableViewWallSegue = "LoginSuccesfulTable"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dispatch_async(dispatch_get_main_queue()) {
            if(PFUser.currentUser() != nil) {
                self.performSegueWithIdentifier("LoginSuccesful", sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if(textField === userTextField) {
            userTextField.resignFirstResponder();
            passwordTextField.becomeFirstResponder();
        } else if(textField == passwordTextField) {
            passwordTextField.resignFirstResponder();
        }
        return true
    }
    
    @IBAction func logInPressed(sender: AnyObject) {
        let login =  userTextField.text!
        if(login.characters.count == 0) {
            userTextField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.8)
            userTextField.textColor = UIColor.whiteColor()

            return;
        }
        
        PFUser.logInWithUsernameInBackground(userTextField.text!, password: passwordTextField.text!) { user, error in
            if user != nil {
                self.performSegueWithIdentifier(self.scrollViewWallSegue, sender: nil)
            } else if let error = error {
                self.showErrorView(error)
            }
        }
    }
    
    @IBAction func signUpPressed(sender: AnyObject) {
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterViewController") as! RegisterViewController
        self.presentViewController(secondViewController, animated: true, completion: nil)
    }


}

