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
    
    
    var selectedEvent: Event?
    
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

    
    @IBAction func addEvent(sender: AnyObject) {
        
        selectedEvent = nil
        performSegueWithIdentifier("EventDetailViewController", sender: self)
    }
    
    
}

extension EventListTableViewController {

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        selectedEvent = fetchedResultsController?.objectAtIndexPath(indexPath) as? Event
        
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        <#code#>
//    }
//    
    
}

extension EventListTableViewController {
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier! == "EventDetailViewController"{
            
            if let EventDetailVC = segue.destinationViewController as? EventDetailTableViewController {
                
                let indexPath = tableView.indexPathForSelectedRow!
                
                selectedEvent = fetchedResultsController?.objectAtIndexPath(indexPath) as? Event
                
                EventDetailVC.event = selectedEvent!
                
            }
        }
    }

}