//
//  Event.swift
//  Event Zone
//
//  Created by Long Wang on 2016-07-10.
//  Copyright © 2016 Long Wang. All rights reserved.
//

import Foundation
import CoreData


class Event: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    convenience init(dictionary: [String : AnyObject], context: NSManagedObjectContext){
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        if let ent = NSEntityDescription.entityForName("Event",
                                                       inManagedObjectContext: context){
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.title = dictionary["title"] as? String
            self.startsDate = dictionary["startsDate"] as? NSDate
            self.endsDate = dictionary["endsDate"] as? NSDate
            
        }else{
            fatalError("Unable to find Entity name!")
        }
        
        
        
    }


}
