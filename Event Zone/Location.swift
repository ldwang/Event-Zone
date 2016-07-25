//
//  Location.swift
//  Event Zone
//
//  Created by Long Wang on 2016-07-10.
//  Copyright © 2016 Long Wang. All rights reserved.
//

import Foundation
import CoreData


class Location: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    convenience init(dictionary: [String : AnyObject], context: NSManagedObjectContext){
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        if let ent = NSEntityDescription.entityForName("Location",
                                                       inManagedObjectContext: context){
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.title = dictionary["title"] as? String
            self.latitude = dictionary["latitude"] as? NSNumber
            self.longitude = dictionary["longitude"] as? NSNumber
            self.timezone = dictionary["timezone"] as? String
            self.locationId = dictionary["locationId"] as? NSNumber
            self.locality = dictionary["locality"] as? String
            self.administrativeArea = dictionary["administrativeArea"] as? String
            self.country = dictionary["country"] as? String
            
        }else{
            fatalError("Unable to find Entity name!")
        }
        
        
        
    }
    


}
