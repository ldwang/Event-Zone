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
    
    var event: Event?
    
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
            
            updateDatePickerTimeZones()
            updateDatePickerDates()
            updateLocationsDateLabel()
            
            
        }
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
        
        print("--------TimeStamp:" + NSDate().description + "---------")
        
        print("\n---------------TimeZone-----------------")
        print("location1 TimeZone: \t\t" + (location1TimeZone?.description)!)
        
        print("location1StartsDatePicker: \t" + location1StartsDatePicker.timeZone!.description)
        print("location1EndsDatePicker: \t" + location1EndsDatePicker.timeZone!.description)
        print("location2 TimeZone: \t\t" + (location2TimeZone?.description)!)
        print("location2StartsDatePicker: \t" + location2StartsDatePicker.timeZone!.description)
        print("location2EndsDatePicker: \t" + location2EndsDatePicker.timeZone!.description)
        
        print("\n---------------Starts Date-----------------")
        print("eventStartsDate: \t\t\t" + (eventStartsDate?.description)!)
        print("location1StartsDatePicker: \t" + location1StartsDatePicker.date.description)
        print("location2StartsDatePicker: \t" + location2StartsDatePicker.date.description)

        print("\n---------------Ends Date-----------------")
        print("eventEndsDate: \t\t\t\t" + (eventEndsDate?.description)!)
        print("location1EndsDatePicker: \t" + location1EndsDatePicker.date.description)
        print("location2EndsDatePicker: \t" + location2EndsDatePicker.date.description)
        print("\n")
    }
    
    
    //Update DatePickerHidden Status
    func toggleDatePicker(indexPath: NSIndexPath) {
        
        let row = Row(indexPath: indexPath)
        
        switch row {
        case .Location1Starts:
            location1StartsDatePickerHidden = !location1StartsDatePickerHidden
            
        case .Location1Ends:
            location1EndsDatePickerHidden = !location1EndsDatePickerHidden
            
        case .Location2Starts:
            location2StartsDatePickerHidden = !location2StartsDatePickerHidden

            
        case .Location2Ends:
            location2EndsDatePickerHidden = !location2EndsDatePickerHidden
            
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
    
    //Update all the DatePickers' date to sync with each locations
    func updateDatePickerDates() {
        
            location1StartsDatePicker.date = showDatePickerDateWithTimeZone(eventStartsDate!, timezone: location1TimeZone!)
            location1EndsDatePicker.date = showDatePickerDateWithTimeZone(eventEndsDate!, timezone: location1TimeZone!)
            location2StartsDatePicker.date = showDatePickerDateWithTimeZone(eventStartsDate!, timezone: location2TimeZone!)
            location2EndsDatePicker.date = showDatePickerDateWithTimeZone(eventEndsDate!, timezone: location2TimeZone!)
    }
    

    
    
    func updateLocationsDateLabel() {
        location1StartsTimeLabel.text = DateTime().presentDateInTimeZone(eventStartsDate!, timezone: location1TimeZone!)
        location1EndsTimeLabel.text = DateTime().presentDateInTimeZone(eventEndsDate!, timezone: location1TimeZone!)
        location2StartsTimeLabel.text = DateTime().presentDateInTimeZone(eventStartsDate!, timezone: location2TimeZone!)
        location2EndsTimeLabel.text = DateTime().presentDateInTimeZone(eventEndsDate!, timezone: location2TimeZone!)
        
        if eventEndsDate!.timeIntervalSince1970 <= eventStartsDate!.timeIntervalSince1970 {
            location1EndsTimeLabel.attributedText = setLabelStrikeThroughAttribute(location1EndsTimeLabel)
            location2EndsTimeLabel.attributedText = setLabelStrikeThroughAttribute(location2EndsTimeLabel)
            
        } else {
            location2EndsTimeLabel.attributedText = nil
            location2EndsTimeLabel.attributedText = nil
        }
    }
    
    func setLabelStrikeThroughAttribute(label: UILabel)-> NSMutableAttributedString{
        let labelText = label.text
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: labelText!)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }

    /* There is an issue when two or more datePickers in the same viewController with different timezone settings, they couldn't display the correct date and time and sometimes behave with mulfuction. To aviod this issue, all the 4 datepicker's timezone are set to "GMT" and use two functions "showDatePickerDateWithTimeZone" and "setDateFromDatePicker" to present the dataPiker date and set the event dates from datePicker.
     */
    func updateDatePickerTimeZones() {
        location1StartsDatePicker.timeZone = NSTimeZone(name: "GMT")
        location1EndsDatePicker.timeZone = NSTimeZone(name: "GMT")
        location2StartsDatePicker.timeZone = NSTimeZone(name: "GMT")
        location2EndsDatePicker.timeZone = NSTimeZone(name: "GMT")
        
    }
    
    //Shift the datePicker date to sync with location's timezone date&time display
    func showDatePickerDateWithTimeZone(date: NSDate, timezone: NSTimeZone) -> NSDate {
        
        let shiftFromGMT =  Double(timezone.secondsFromGMTForDate(date))
        return date.dateByAddingTimeInterval(shiftFromGMT)
        
    }
    
    //return the date from shifted datePicker date
    func setDateFromDatePicker(date: NSDate, timezone: NSTimeZone) -> NSDate {
        let shiftFromGMT =  Double(timezone.secondsFromGMTForDate(date))
        return date.dateByAddingTimeInterval( -shiftFromGMT)
    }
    
    //Location1StartsDatePicker Action of Value Changed
    @IBAction func location1StartsDatePickerValueChanged(sender: UIDatePicker) {
        let eventInterval = eventEndsDate?.timeIntervalSinceDate(eventStartsDate!)
        
        eventStartsDate = setDateFromDatePicker(sender.date, timezone: location1TimeZone!)
        eventEndsDate = eventStartsDate?.dateByAddingTimeInterval(eventInterval!)
        
        updateLocationsDateLabel()
        updateDatePickerDates()
        print("location1StartsDatePikerChanged")
        printDatePickers()
    }
    
    
    //Location1EndsDatePicker Action of Value Changed
    
    @IBAction func location1EndsDatePickerValueChanged(sender: UIDatePicker) {
        
        eventEndsDate = setDateFromDatePicker(sender.date, timezone: location1TimeZone!)
        
        updateDatePickerDates()
        updateLocationsDateLabel()
//        location1EndsDatePicker.minimumDate = location1StartsDatePicker.date
//        location2EndsDatePicker.minimumDate = location2StartsDatePicker.date
        
        print("location1EndsDatePikerChanged")
        printDatePickers()
    }
    
    //Location2StartsDatePicker Action of Value Changed
    
    @IBAction func location2StartsDatePickerValueChanged(sender: UIDatePicker) {

        let eventInterval = eventEndsDate?.timeIntervalSinceDate(eventStartsDate!)
        eventStartsDate = setDateFromDatePicker(sender.date, timezone: location2TimeZone!)
        eventEndsDate = eventStartsDate?.dateByAddingTimeInterval(eventInterval!)
        
        updateLocationsDateLabel()
        updateDatePickerDates()
        print("location2StartsDatePikerChanged")
        printDatePickers()
    }
    
    //Location2EndsDatePicker Action of Value Changed
    
    @IBAction func location2EndsDatePickerValueChanged(sender: UIDatePicker) {

        eventEndsDate = setDateFromDatePicker(sender.date, timezone: location2TimeZone!)
        
        updateLocationsDateLabel()
        updateDatePickerDates()
//        location1EndsDatePicker.minimumDate = location1StartsDatePicker.date
//        location2EndsDatePicker.minimumDate = location2StartsDatePicker.date
//        
        print("location2EndsDatePikerChanged")
        printDatePickers()
    }
    

}

extension EventDetailTableViewController {
    
    //Fold or extend the DatePicker by selecting the Starts/Ends Row
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = Row(indexPath: indexPath)
        
        
        if row == .Location1Starts || row == .Location1Ends || row == .Location2Starts || row == .Location2Ends {
            toggleDatePicker(indexPath)

        } else if row == .Location1Search || row == .Location2Search {
            
            let locationSearchTable = (self.storyboard?.instantiateViewControllerWithIdentifier("LocationSearchTableViewController"))! as! LocationSearchTableViewController
            let location = (row == .Location1Search) ? "location1" : "location2"
            
            locationSearchTable.location = location
            locationSearchTable.handleLocationSearchDelegate = self
            
            self.presentViewController(locationSearchTable, animated: true, completion: nil)
            
        }
        
        print(row)
        printDatePickers()
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
        
        print(placemark.name)
        print(placemark.title)
        print(placemark.thoroughfare)
        print(placemark.subThoroughfare)
        print(placemark.locality)
        print(placemark.subLocality)
        print(placemark.administrativeArea)
        print(placemark.subAdministrativeArea)
        print(placemark.country)
        print(placemark.postalCode)
        print(placemark.timeZone)
        
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
                            self.datePickerChanged(.Location1StartsDatePicker)
                            self.datePickerChanged(.Location1EndsDatePicker)
//                            self.updateLocationsDateLabel()
//                            self.updateDatePickerTimeZones()
                            self.updateDatePickerDates()
                            
                        } else if location == "location2" {
                            self.location2TimeZone = timezone
                            self.location2TimeZoneLabel.text = DateTime().presentTimeZoneLabel(timezone!)
                            self.datePickerChanged(.Location2StartsDatePicker)
                            self.datePickerChanged(.Location2EndsDatePicker)
//                            self.updateLocationsDateLabel()
//                            self.updateDatePickerTimeZones()
                            self.updateDatePickerDates()
                        }
                    })
                }
            }
            
        }
        
    }
}