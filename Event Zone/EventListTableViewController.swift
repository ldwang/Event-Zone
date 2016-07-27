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
    
    var stack : CoreDataStack? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the stack
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        stack = delegate.stack
        
        //Create a fetchrequest
        
        let fr = NSFetchRequest(entityName: "Event")
        fr.sortDescriptors = [NSSortDescriptor(key: "startsDate", ascending: true), NSSortDescriptor(key: "title", ascending: true)]
        
        //Create the FetchResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack!.context, sectionNameKeyPath: nil, cacheName: nil)
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addEvent(sender: AnyObject) {
        
        selectedEvent = nil
        performSegueWithIdentifier("EventDetailViewController", sender: self)
    }
    
    
}

extension EventListTableViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EventListTableViewCell", forIndexPath: indexPath) as! EventListTableViewControllerCell
        selectedEvent = fetchedResultsController?.objectAtIndexPath(indexPath) as? Event
        let locations = selectedEvent?.locations
        //Set the Event Title and Locations Info
        
        cell.title.text = selectedEvent?.title
        
        for loc in locations! {
                        
            let location = (loc as! Location)

            if (location.timezone != nil) {
                let timezone = NSTimeZone(name: location.timezone!)
                let startsLocalDate = DateTime().presentDateInTimeZone((selectedEvent?.startsDate)!, timezone: timezone!)
                if location.locationId == 1 {
                    cell.location1.text = parseLocationTitle(location) + "\t " + startsLocalDate + "  " + (timezone!.abbreviation)!
                } else if location.locationId == 2 {
                    cell.location2.text = parseLocationTitle(location) + "\t " + startsLocalDate + "  " + (timezone!.abbreviation)!
                }
            }
        }
     
        
        
        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let context = fetchedResultsController?.managedObjectContext,
            selectedEvent = fetchedResultsController?.objectAtIndexPath(indexPath) as? Event
            where editingStyle == .Delete{
            
            context.deleteObject(selectedEvent)
            
            stack!.save()
            
        }
        
    }
    
    func parseLocationTitle(location: Location) -> String {
        //put a space between "Washington" and "DC"
        let firstSpace = (location.administrativeArea != nil) ? " " : ""
        let addressline = String(
            format: "%@%@%@,%@",
            //city
            location.locality ?? "",
            firstSpace,
            //state
            location.administrativeArea ?? "",
            //countryCode
            location.countryCode ?? ""
        )
        return addressline
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedEvent = fetchedResultsController?.objectAtIndexPath(indexPath) as? Event
        performSegueWithIdentifier("EventDetailViewController", sender: self)
        
    }
    
    
}

extension EventListTableViewController {
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier! == "EventDetailViewController"{
            
            if let EventDetailVC = segue.destinationViewController as? EventDetailTableViewController {
                
                EventDetailVC.event = selectedEvent
                
                if selectedEvent == nil {
                    EventDetailVC.isNewEvent = true
                } else {
                    EventDetailVC.isNewEvent = false
                }
            }
        }
    }

}