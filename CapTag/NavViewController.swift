//
//  NavViewController.swift
//  CapTag
//
//  Created by Edgar Kuskov on 21/11/15.
//  Copyright © 2015 Edgar Kuskov. All rights reserved.
//

import Foundation
import Parse

class NavViewController: UIViewController {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userStatsLabel: UILabel!
    @IBOutlet weak var nextGameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userNameLabel.text = PFUser.currentUser()?.username
        self.revealViewController().rearViewRevealWidth = self.view.frame.width-50
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