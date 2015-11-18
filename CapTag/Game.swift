//
//  Game.swift
//  CapTag
//
//  Created by Edgar Kuskov on 15.11.15.
//  Copyright © 2015 Edgar Kuskov. All rights reserved.
//

import Foundation
import Parse

class Game: PFObject {
    
    @NSManaged var icon: String?
    @NSManaged var gameTemplate: PFRelation
    @NSManaged var name: String?
    @NSManaged var status: String?
    @NSManaged var startAt: NSDate?
    
    override class func query() -> PFQuery? {
        //1
        let query = PFQuery(className: Game.parseClassName())
        //2
        query.includeKey("gameTemplate")
        //3
        query.orderByDescending("createdAt")
        return query
    }
}

extension Game: PFSubclassing {
    // Table view delegate methods here
    //1
    class func parseClassName() -> String {
        return "Game"
    }
    //2
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}