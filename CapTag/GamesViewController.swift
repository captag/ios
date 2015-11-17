//
//  StartViewController.swift
//  CapTag
//
//  Created by Edgar Kuskov on 12.11.15.
//  Copyright © 2015 Edgar Kuskov. All rights reserved.
//

import UIKit

class GamesViewController: PFQueryTableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        loadObjects()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func queryForTable() -> PFQuery {
        let query = Game.query()
        return query!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {
        // 1
        let cell = tableView.dequeueReusableCellWithIdentifier("GameCell", forIndexPath: indexPath) as! PFTableViewCell
        
        // 2
        let game = object as! Game
        
        // 4
        let creationDate = game.startAt
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm dd/MM yyyy"
        let dateString = dateFormatter.stringFromDate(creationDate!)
        
        if let nameLabel = cell.viewWithTag(10) as? UILabel { //3
            nameLabel.text = game.name
        }
        if let startLabel = cell.viewWithTag(20) as? UILabel {
            startLabel.text = dateString
        }
        if let iconView = cell.viewWithTag(30) as? UIImageView {
            iconView.downloadedFrom(link: game.icon!, contentMode: UIViewContentMode.ScaleAspectFit)
        }
        return cell
    }
}

