//
//  EventDetailTableViewController.swift
//  Event Zone
//
//  Created by Long Wang on 2016-06-22.
//  Copyright © 2016 Long Wang. All rights reserved.
//

import UIKit
import MapKit

protocol HandleLocationSearch {
    func getLocationFromSearch(location: String, placemark: MKPlacemark)
}

class EventDetailTableViewController: UITableViewController {
    
    var isNewEvent = true
    var isEditingEvent = false
    
    var location1StartsDatePickerHidden = true
    var location1EndsDatePickerHidden = true
    var location2StartsDatePickerHidden = true
    var location2EndsDatePickerHidden = true
    
    var eventStartsDate: NSDate? = nil
    var eventEndsDate: NSDate? = nil
    
    var location1TimeZone: NSTimeZone? = nil
    var location2TimeZone: NSTimeZone? = nil
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var rightNavBarButton: UIBarButtonItem!
    
    @IBOutlet weak var location1LocationLabel: UILabel!
    @IBOutlet weak var location1StartsTimeLabel: UILabel!
    @IBOutlet weak var location1EndsTimeLabel: UILabel!
    @IBOutlet weak var location1TimeZoneLabel: UILabel!
    
    @IBOutlet weak var location2LocationLabel: UILabel!
    @IBOutlet weak var location2StartsTimeLabel: UILabel!
    @IBOutlet weak var location2EndsTimeLabel: UILabel!

    @IBOutlet weak var location2TimeZoneLabel: UILabel!
    
    @IBOutlet weak var location1StartsDatePicker: UIDatePicker!
    @IBOutlet weak var location1EndsDatePicker: UIDatePicker!
    
    @IBOutlet weak var location2StartsDatePicker: UIDatePicker!
    @IBOutlet weak var location2EndsDatePicker: UIDatePicker!

    @IBOutlet weak var mapView: MKMapView!
    
    var location1Placemark: MKPlacemark? = nil
    var location2Placemark: MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        
        location1StartsDatePicker.addTarget(self, action: #selector(self.location1StartsDatePikerChanged(_:)), forControlEvents: .ValueChanged)
        location1EndsDatePicker.addTarget(self, action: #selector(self.location1EndsDatePickerChanged(_:)), forControlEvents: .ValueChanged)
        location2StartsDatePicker.addTarget(self, action: #selector(self.location2StartsDatePickerChanged(_:)), forControlEvents: .ValueChanged)
        location2EndsDatePicker.addTarget(self, action: #selector(self.location2EndsDatePickerChanged(_:)), forControlEvents: .ValueChanged)
        
        initNewEvent()

    }
    
//    override func viewWillAppear(animated: Bool) {
//        datePickerChanged()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initNewEvent() {
        if isNewEvent {
            
            //disable the right button
            rightNavBarButton.title = "Add"
            rightNavBarButton.enabled = false
            

            //initialize the time zone with local time zone
            let timezone = NSTimeZone.localTimeZone()
            location1TimeZone = timezone
            location2TimeZone = timezone
            location1TimeZoneLabel.text = DateTime().presentTimeZoneLabel(timezone)
            location2TimeZoneLabel.text = DateTime().presentTimeZoneLabel(timezone)
            
            //initialize the starts and ends dates with current date
            let date = DateTime().getDateByCurrentSharpHour()
            eventStartsDate = date
            eventEndsDate = date.dateByAddingTimeInterval(60.0*60.0)
            
            updateDatePickerDates()
            updateDatePickerTimeZones()
            
            updateLocationsDateLabel()
            
            
        }
    }
    
    func updateLocationsDateLabel() {
        location1StartsTimeLabel.text = DateTime().presentDateInTimeZone(eventStartsDate!, timezone: location1TimeZone!)
        location1EndsTimeLabel.text = DateTime().presentDateInTimeZone(eventEndsDate!, timezone: location1TimeZone!)
        location2StartsTimeLabel.text = DateTime().presentDateInTimeZone(eventStartsDate!, timezone: location2TimeZone!)
        location2EndsTimeLabel.text = DateTime().presentDateInTimeZone(eventEndsDate!, timezone: location2TimeZone!)
    }
    
    
        
    // Change Starts/Ends DateTime Label by DatePicker Value Change
    func datePickerChanged(row: Row) {
        
        switch row {
        case .Location1StartsDatePicker :
            location1StartsTimeLabel.text = DateTime().presentDateInTimeZone(eventStartsDate!, timezone: location1TimeZone!)
        case .Location1EndsDatePicker :
            location1EndsTimeLabel.text = DateTime().presentDateInTimeZone(eventEndsDate!, timezone: location1TimeZone!)
        case .Location2StartsDatePicker :
            location2StartsTimeLabel.text = DateTime().presentDateInTimeZone(eventStartsDate!, timezone: location2TimeZone!)
        case .Location2EndsDatePicker :
            location2EndsTimeLabel.text = DateTime().presentDateInTimeZone(eventEndsDate!, timezone: location2TimeZone!)
            
        default :
            ()
        
            }
            
    }
    
    func printDatePickers() {
        print("location1 TimeZone: " + (location1TimeZone?.description)!)
        print("location2 TimeZone: " + (location2TimeZone?.description)!)
        print("eventStartsDate: " + (eventStartsDate?.description)!)
        print("eventEndsDate: " + (eventEndsDate?.description)!)
        
        print("location1StartsDatePicker: " + location1StartsDatePicker.timeZone!.description)
        print("location1EndsDatePicker: " + location1EndsDatePicker.timeZone!.description)
        print("location2StartsDatePicker: " + location2StartsDatePicker.timeZone!.description)
        print("location2EndsDatePicker: " + location2EndsDatePicker.timeZone!.description)
        print("location1StartsDatePicker: " + location1StartsDatePicker.date.description)
        print("location1EndsDatePicker: " + location1EndsDatePicker.date.description)
        print("location2StartsDatePicker: " + location2StartsDatePicker.date.description)
        print("location2EndsDatePicker: " + location2EndsDatePicker.date.description)
        print("  \n")
        
    }
    
    
    //Update DatePickerHidden Status
    func toggleDatePicker(indexPath: NSIndexPath) {
        
        let row = Row(indexPath: indexPath)
        
        switch row {
        case .Location1Starts:
            location1StartsDatePickerHidden = !location1StartsDatePickerHidden
            if !location1StartsDatePickerHidden {
                //location1StartsDatePicker.enabled = true
                //location1StartsDatePicker.timeZone = location1TimeZone
                //location1StartsDatePicker.setDate(eventStartsDate!, animated: false)
                //location1StartsDatePicker.addTarget(self, action: #selector(self.location1StartsDatePikerChanged(_:)), forControlEvents: .ValueChanged)
                printDatePickers()
                
            } else {
                //location1StartsDatePicker.enabled = false
            }
            
        case .Location1Ends:
            location1EndsDatePickerHidden = !location1EndsDatePickerHidden
            if !location1EndsDatePickerHidden {
                //location1EndsDatePicker.enabled = true
                //location1EndsDatePicker.timeZone = location1TimeZone
                //location1EndsDatePicker.setDate(eventEndsDate!, animated: false)
                
                //location1EndsDatePicker.addTarget(self, action: #selector(self.location1EndsDatePickerChanged(_:)), forControlEvents: .ValueChanged)
                printDatePickers()
            } else {
                //location1EndsDatePicker.enabled = false
            }
            
        case .Location2Starts:
            location2StartsDatePickerHidden = !location2StartsDatePickerHidden
            if !location2StartsDatePickerHidden {
                //location2StartsDatePicker.enabled = true
                //location2StartsDatePicker.timeZone = location2TimeZone
                //location2StartsDatePicker.setDate(eventStartsDate!, animated: false)
                
                //location2StartsDatePicker.addTarget(self, action: #selector(self.location2StartsDatePickerChanged(_:)), forControlEvents: .ValueChanged)
                printDatePickers()
            } else {
                //location2StartsDatePicker.enabled = false
            }
            
        case .Location2Ends:
            location2EndsDatePickerHidden = !location2EndsDatePickerHidden
            if !location2EndsDatePickerHidden {
                //location2EndsDatePicker.enabled = true
                //location2EndsDatePicker.timeZone = location2TimeZone
                //location2EndsDatePicker.setDate(eventEndsDate!, animated: false)
                
                //location2EndsDatePicker.addTarget(self, action: #selector(self.location2EndsDatePickerChanged(_:)), forControlEvents: .ValueChanged)
                printDatePickers()
            } else {
                //location2EndsDatePicker.enabled = false
            }

            
        default:
            ()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //update map annotations for location1 and location2
    func updateLocationsAnnotation() {
        
        //clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        //var annotations = MKPointAnnotation()[]
        
        for placemark in [location1Placemark, location2Placemark] {
            if placemark != nil {
                let annotation = MKPointAnnotation()
                annotation.coordinate = placemark!.coordinate
                annotation.title = placemark!.name
                
                if let city = placemark!.locality,
                    let country = placemark!.country {
                    annotation.subtitle = "\(city) \(country)"
                }
                mapView.addAnnotation(annotation)

            }
        }
        
        GeoLocation().fitMapViewToAnnotations(mapView)

    }
    

    func updateDatePickerDates() {
        
        dispatch_async(dispatch_get_main_queue(), {
        self.location1StartsDatePicker.setDate(self.eventStartsDate!, animated: false)
        self.location1EndsDatePicker.setDate(self.eventEndsDate!, animated: false)
        self.location2StartsDatePicker.setDate(self.eventStartsDate!, animated: false)
        self.location2EndsDatePicker.setDate(self.eventEndsDate!, animated: false)
        })
    }
    
    func updateDatePickerTimeZones() {
        location1StartsDatePicker.timeZone = location1TimeZone
        location1EndsDatePicker.timeZone = location1TimeZone
        location2StartsDatePicker.timeZone = location2TimeZone
        location2EndsDatePicker.timeZone = location2TimeZone
    }
    
    
    //Location1StartsDatePicker Action of Value Changed
    func location1StartsDatePikerChanged(sender: UIDatePicker) {
        let eventInterval = eventEndsDate?.timeIntervalSinceDate(eventStartsDate!)
        
        eventStartsDate = sender.date
        eventEndsDate = eventStartsDate?.dateByAddingTimeInterval(eventInterval!)
        
        updateLocationsDateLabel()
        updateDatePickerDates()
        print("location1StartsDatePikerChanged")
        printDatePickers()
    }
    


    
    //Location1EndsDatePicker Action of Value Changed
    func location1EndsDatePickerChanged(sender: UIDatePicker) {
        
        eventEndsDate = sender.date
        
        updateLocationsDateLabel()
        updateDatePickerDates()
        print("location1EndsDatePikerChanged")
        printDatePickers()
    }
    
    //Location2StartsDatePicker Action of Value Changed
    func location2StartsDatePickerChanged(sender: UIDatePicker) {
        let eventInterval = eventEndsDate?.timeIntervalSinceDate(eventStartsDate!)
        eventStartsDate = sender.date
        eventEndsDate = eventStartsDate?.dateByAddingTimeInterval(eventInterval!)
        
        updateLocationsDateLabel()
        updateDatePickerDates()
        print("location2StartsDatePikerChanged")
        printDatePickers()
    }
    
    //Location2EndsDatePicker Action of Value Changed
    func location2EndsDatePickerChanged(sender: UIDatePicker) {
        eventEndsDate = sender.date
        
        updateLocationsDateLabel()
        updateDatePickerDates()
        print("location2EndsDatePikerChanged")
        printDatePickers()
    }
    

}

extension EventDetailTableViewController {
    
    //Fold or extend the DatePicker by selecting the Starts/Ends Row
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = Row(indexPath: indexPath)
        
        print(row)
        
        if row == .Location1Starts || row == .Location1Ends || row == .Location2Starts || row == .Location2Ends {
            toggleDatePicker(indexPath)
        } else if row == .Location1Search || row == .Location2Search {
            
            let locationSearchTable = (self.storyboard?.instantiateViewControllerWithIdentifier("LocationSearchTableViewController"))! as! LocationSearchTableViewController
            let location = (row == .Location1Search) ? "location1" : "location2"
            
            locationSearchTable.location = location
            locationSearchTable.handleLocationSearchDelegate = self
            
            self.presentViewController(locationSearchTable, animated: true, completion: nil)
            
        }
    }
    
    //Hide/Unhide DatePicker Row
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let row = Row(indexPath: indexPath)
        
        switch row {
        case .Location1StartsDatePicker:
            return location1StartsDatePickerHidden == true ? 0 : 216
        case .Location1EndsDatePicker:
            return location1EndsDatePickerHidden == true ? 0: 216
        case .Location2StartsDatePicker:
            return location2StartsDatePickerHidden == true ? 0 : 216
        case .Location2EndsDatePicker:
            return location2EndsDatePickerHidden == true ? 0: 216
            
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }

    // Define Table Rows -- reference from : http://manenko.com/2014/12/19/put-uidatepicker-inside-static-uitableview.html
    enum Row: Int {
        case Title
        case Location1Search
        case Location1Starts
        case Location1StartsDatePicker
        case Location1Ends
        case Location1EndsDatePicker
        case Location1TimeZone
        case Location2Search
        case Location2Starts
        case Location2StartsDatePicker
        case Location2Ends
        case Location2EndsDatePicker
        case Location2TimeZone
        case MapView
        
        case UnKnown
        
        init(indexPath: NSIndexPath) {
            var row = Row.UnKnown
            
            switch (indexPath.section, indexPath.row) {
            case(0,0):
                row = Row.Title
            case(1,0):
                row = Row.Location1Search
            case(1,1):
                row = Row.Location1Starts
            case(1,2):
                row = Row.Location1StartsDatePicker
            case(1,3):
                row = Row.Location1Ends
            case(1,4):
                row = Row.Location1EndsDatePicker
            case(1,5):
                row = Row.Location1TimeZone
            case(2,0):
                row = Row.Location2Search
            case(2,1):
                row = Row.Location2Starts
            case(2,2):
                row = Row.Location2StartsDatePicker
            case(2,3):
                row = Row.Location2Ends
            case(2,4):
                row = Row.Location2EndsDatePicker
            case(2,5):
                row = Row.Location2TimeZone
            case(3,0):
                row = Row.MapView
                
            default:
                ()
            }
            
            assert(row != Row.UnKnown)
            
            self = row
        }
    }

}

extension EventDetailTableViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
            pr.lineDashPattern = [2, 5]
            pr.lineWidth = 2
            return pr
        }
        
        return MKPolylineRenderer()
    }

    
}

extension EventDetailTableViewController: HandleLocationSearch {
    func getLocationFromSearch(location: String, placemark: MKPlacemark) {
        
        
        if location == "location1" {
            location1Placemark = placemark
            location1LocationLabel.text = placemark.title
            
        } else if location == "location2" {
            location2Placemark = placemark
            location2LocationLabel.text = placemark.title
        }
        
        updateLocationsAnnotation()
        
        if eventStartsDate != nil {
            GoogleMapsAPI().getTimeZoneForLocation(placemark.coordinate, date: eventStartsDate!) { timezone, error in
                
                if error != nil {
                    //print(error?.localizedDescription)
                    showAlert(self, alertString: error?.localizedDescription)
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                    
                        if location == "location1" {
                            self.location1TimeZone = timezone
                            self.location1TimeZoneLabel.text = DateTime().presentTimeZoneLabel(timezone!)
                            //self.location1StartsDatePicker.timeZone = self.location1TimeZone
                            //self.datePickerChanged(.Location1StartsDatePicker)
                            //self.location1EndsDatePicker.timeZone = self.location1TimeZone
                            //self.datePickerChanged(.Location1EndsDatePicker)
                            self.updateLocationsDateLabel()
                            self.updateDatePickerTimeZones()
                            self.updateDatePickerDates()
                            
                        } else if location == "location2" {
                            self.location2TimeZone = timezone
                            self.location2TimeZoneLabel.text = DateTime().presentTimeZoneLabel(timezone!)
                            //self.location2StartsDatePicker.timeZone = self.location2TimeZone
                            //self.datePickerChanged(.Location2StartsDatePicker)
                            //self.location2EndsDatePicker.timeZone = self.location2TimeZone
                            //self.datePickerChanged(.Location2EndsDatePicker)
                            self.updateLocationsDateLabel()
                            self.updateDatePickerTimeZones()
                            self.updateDatePickerDates()
                        }
                    })
                }
            }
            
        }
        
    }
}