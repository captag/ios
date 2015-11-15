//
//  StartViewController.swift
//  CapTag
//
//  Created by Edgar Kuskov on 12.11.15.
//  Copyright © 2015 Edgar Kuskov. All rights reserved.
//

import UIKit

class StartViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logout(sender: UIBarButtonItem) {
        PFUser.logOutInBackground();
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(next, animated: true, completion: nil)
    }
}

