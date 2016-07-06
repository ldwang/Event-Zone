//
//  GoogleMapsAPI.swift
//  Event Zone
//
//  Created by Long Wang on 2016-07-03.
//  Copyright © 2016 Long Wang. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class GoogleMapsAPI : NSObject {
    
    var session: NSURLSession
    
    //    var config = Config.unarchivedInstance() ?? Config()
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    // MARK: - All purpose task method for data
    
    func taskForGetMethod(parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        
        let urlString = Constants.BaseUrl + escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        print(url)
        
        let task = session.dataTaskWithRequest(request) {data, response, error in
            
            if error !== nil {
                print("There was an error with your request: \(error)")
                completionHandler(result: nil, error: error)
            } else {
                
                let statusCode = (response as? NSHTTPURLResponse)?.statusCode
                
                if  statusCode >= 200 && statusCode <= 299 {
                    
                    if let data = data {
                        /* Parse the data and use the data (happens in completion handler) */
                        parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
                    } else {
                        let errorObject = NSError(domain: "DomainError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data was returned by the request!"])
                        completionHandler(result: nil, error: errorObject)
                    }
                } else  {
                    let errorObject = NSError(domain: "DomainError", code: statusCode!, userInfo: [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code \(statusCode)"])
                    completionHandler(result: nil, error: errorObject)
                }
            }
        }
        
        task.resume()
        
        return task
        
    }
    
    
    func getTimeZoneForLocation(coordinate: CLLocationCoordinate2D, date: NSDate, completionHandler: (timezone: NSTimeZone?, error: NSError?) -> Void ) {
        
        let location = String(coordinate.latitude) + "," + String(coordinate.longitude)
        let timestamp = date.timeIntervalSince1970
        
        let parameters = [
            "location" : location,
            "timestamp" : timestamp,
            "key": Constants.ApiKey
        ]
        
        taskForGetMethod(parameters as! [String : AnyObject]) { result, error in
            
            guard error == nil, let result = result as? NSDictionary else {
                print(error)
                completionHandler(timezone: nil, error: error)
                return
            }
            
            guard let status = result["status"] as? String where status == "OK" else {
                let errorObject = NSError(domain: "GoogleMapAPIError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Google Maps TimeZone Status: \(result["status"]!). Error Message : \(result["error_message"])"])
                completionHandler(timezone: nil, error: errorObject)
                return
            }
            
            guard let timeZoneId = result["timeZoneId"] as? String else {
                let errorObject = NSError(domain: "GoogleMapAPIError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Google Maps TimeZoneID Error - Empty"])
                completionHandler(timezone: nil, error: errorObject)
                return
                
            }
            
            guard let timezone = NSTimeZone(name: timeZoneId) else {
                let errorObject = NSError(domain: "TimeZoneError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Couldn't find Time Zone by Google Maps API timeZoneId: \(timeZoneId)"])
                completionHandler(timezone: nil, error: errorObject)
                return
            }
            print(timezone)
            completionHandler(timezone:  timezone, error: nil)
            }
        }
    }
    

    /* Helper: Given raw JSON, return a usable Foundation object */
    func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
            return
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    // URL Encoding a dictionary into a parameter string
    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            // make sure that it is a string value
            let stringValue = "\(value)"
            
            // Escape it
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            // Append it
            
            if let unwrappedEscapedValue = escapedValue {
                urlVars += [key + "=" + "\(unwrappedEscapedValue)"]
            } else {
                print("Warning: trouble excaping string \"\(stringValue)\"")
            }
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    
    // MARK: - Shared Instance
    
    let sharedInstance = GoogleMapsAPI()

    
    //MARK: show alert controller
    func showAlert(hostViewController: UIViewController, alertString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let alertString = alertString {
                let alertController = UIAlertController(title: "", message: "\(alertString)", preferredStyle: .Alert)
                let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel) { (action) -> Void in }
                alertController.addAction(dismiss)
                hostViewController.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }


extension GoogleMapsAPI {
    struct Constants {
        
        //MARK: API Key
        static let ApiKey = "AIzaSyDD0iHfn55A0qElEufnpcQobbwkbZZP7e0"
        
        //MARK: - URLs
        static let BaseUrl = "https://maps.googleapis.com/maps/api/timezone/json"
    }

}