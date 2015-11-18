//
//  Game.swift
//  CapTag
//
//  Created by Edgar Kuskov on 15.11.15.
//  Copyright © 2015 Edgar Kuskov. All rights reserved.
//

import Foundation
import Parse

class GameTag: PFObject {
    
    @NSManaged var label: String?
    @NSManaged var game: Game
    @NSManaged var team: PFObject
    @NSManaged var player: PFObject
    @NSManaged var geoPoint: PFGeoPoint
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: GameTag.parseClassName())
        query.orderByDescending("createdAt")
        return query
    }
}

extension GameTag: PFSubclassing {
    // Table view delegate methods here
    //1
    class func parseClassName() -> String {
        return "Tag"
    }
    
    //2
    override class func initialize() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}