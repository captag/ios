//
//  MenuViewController.swift
//  CapTag
//
//  Created by Edgar Kuskov on 15.11.15.
//  Copyright © 2015 Edgar Kuskov. All rights reserved.
//

import UIKit
import Parse

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOutInBackground();
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(next, animated: true, completion: nil)
    }
}

