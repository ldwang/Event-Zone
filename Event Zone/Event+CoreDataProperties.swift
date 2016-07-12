//
//  Event+CoreDataProperties.swift
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

extension Event {

    @NSManaged var endsDate: NSDate?
    @NSManaged var startsDate: NSDate?
    @NSManaged var title: String?
    @NSManaged var locations: NSSet?

}
