//
//  EventListTableViewController.swift
//  Event Zone
//
//  Created by Long Wang on 2016-07-11.
//  Copyright © 2016 Long Wang. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class EventListTableViewController: CoreDataTableViewController {
    
    
    var selectedEvent: Event
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the stack
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        
        //Create a fetchrequest
        
        let fr = NSFetchRequest(entityName: "Event")
        fr.sortDescriptors = [NSSortDescriptor(key: "startsDate", ascending: true), NSSortDescriptor(key: "title", ascending: true)]
        
        //Create the FetchResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
    }
    
}

extension EventListTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        <#code#>
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        <#code#>
    }
    
    
}