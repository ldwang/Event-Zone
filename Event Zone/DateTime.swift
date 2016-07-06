//
//  DateTime.swift
//  Event Zone
//
//  Created by Long Wang on 2016-06-26.
//  Copyright © 2016 Long Wang. All rights reserved.
//

import Foundation

class DateTime {
    
    func getDateByCurrentSharpHour() -> NSDate {
        
        let date = NSDate()
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components([.Hour, .Day, .Month, .Year], fromDate: date)
        let newDate = calendar.dateFromComponents(components)
        return newDate!
    }
    
    func presentTimeZoneLabel(timezone: NSTimeZone) -> String {
        return timezone.name + "("  + timezone.abbreviation! + ")"
    }
    
    func presentDateInTimeZone(date: NSDate, timezone: NSTimeZone) -> String {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.timeZone = timezone
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        //dateFormatter.dateFormat = "yyyy-MMM-dd hh:mm a"
        
        return dateFormatter.stringFromDate(date)
    }
}