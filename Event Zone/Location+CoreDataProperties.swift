//
//  Location+CoreDataProperties.swift
//  Event Zone
//
//  Created by Long Wang on 2016-07-10.
//  Copyright © 2016 Long Wang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var timezone: String?
    @NSManaged var title: String?
    @NSManaged var locality: String?
    @NSManaged var administrativeArea: String?
    @NSManaged var country: String?
    @NSManaged var locationId: NSNumber?
    @NSManaged var event: Event?

}
