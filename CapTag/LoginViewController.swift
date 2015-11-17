//
//  LoginViewController.swift
//  CapTag
//
//  Created by Edgar Kuskov on 12.11.15.
//  Copyright © 2015 Edgar Kuskov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    /** VIEWS **/
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var registerView: UIView!
    
    /** LOGIN VIEW **/
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    /** REGISTER VIEW **/
    @IBOutlet weak var regUserTextField: UITextField!
    @IBOutlet weak var regEmailTextField: UITextField!
    @IBOutlet weak var regPasswordTextField: UITextField!
    
    let loginSuccessSegue = "LoginSuccesful"
    var showingLogin = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        dispatch_async(dispatch_get_main_queue()) {
            if(PFUser.currentUser() != nil) {
                self.performSegueWithIdentifier(self.loginSuccessSegue, sender: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Hide register view
        if(showingLogin) {
            self.registerView.alpha = 0
            self.registerView.frame.origin.x -= self.view.frame.width
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        // LOGIN
        if(textField === userTextField) {
            userTextField.resignFirstResponder();
            passwordTextField.becomeFirstResponder();
        } else if(textField == passwordTextField) {
            passwordTextField.resignFirstResponder();
        }
        
        // REGISTER
        if(textField === regUserTextField) {
            regUserTextField.resignFirstResponder();
            regEmailTextField.becomeFirstResponder();
        } else if(textField == regEmailTextField) {
            regEmailTextField.resignFirstResponder();
            regPasswordTextField.becomeFirstResponder();
        } else if(textField == regPasswordTextField) {
            regPasswordTextField.resignFirstResponder();
        }
        return true
    }
    
    @IBAction func logInPressed(sender: AnyObject) {
        self.view.endEditing(true)
        let login =  userTextField.text!
        if(login.characters.count == 0) {
            userTextField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.8)
            userTextField.textColor = UIColor.whiteColor()

            return;
        }
        
        PFUser.logInWithUsernameInBackground(userTextField.text!, password: passwordTextField.text!) { user, error in
            if user != nil {
                self.performSegueWithIdentifier(self.loginSuccessSegue, sender: nil)
            } else if let error = error {
                self.showErrorView(error)
            }
        }
    }

    
    @IBAction func flipRegisterLoginView(sender: AnyObject) {
        self.view.endEditing(true)
        if (showingLogin) {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.loginView.frame.origin.x += self.view.frame.width
                self.registerView.frame.origin.x += self.view.frame.width
                
                self.loginView.alpha = 0
                self.registerView.alpha = 1
                
                }, completion: nil)
            showingLogin = false
        } else {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.loginView.frame.origin.x -= self.view.frame.width
                self.registerView.frame.origin.x -= self.view.frame.width
                
                self.loginView.alpha = 1
                self.registerView.alpha = 0
                
                }, completion: nil)
            showingLogin = true
        }
    }
    
    
    @IBAction func signUpPressed(sender: AnyObject) {
        self.view.endEditing(true)
        let user = PFUser()
        user.username = regUserTextField.text
        user.email = regEmailTextField.text
        user.password = regPasswordTextField.text
        user.signUpInBackgroundWithBlock { succeeded, error in
            if (succeeded) {
                //The registration was successful, go to the wall
                self.performSegueWithIdentifier(self.loginSuccessSegue, sender: self)
            } else if let error = error {
                //Something bad has occurred
                self.showErrorView(error)
            }
        }
    }
    
   

}

