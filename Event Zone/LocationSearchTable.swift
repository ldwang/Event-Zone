//
//  LocationSearchTable.swift
//  Event Zone
//
//  Created by Long Wang on 2016-06-29.
//  Copyright © 2016 Long Wang. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class LocationSearchTableViewController : UITableViewController {
    
    
    var matchingItems : [MKMapItem] = []
    var handleLocationSearchDelegate: HandleLocationSearch? = nil
    var location: String? = nil
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    
    //@IBOutlet weak var tableView: UITableView!
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: View Setup
    
    override func viewDidLoad() {
        
        //self.tableView.allowsSelection = true
        
        super.viewDidLoad()
        
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        //https://stackoverflow.com/a/33316474/6647937 solve the popViewControllerAnimated issue "while an existing transition or presentation is occurring; the navigation stack will not be updated"
        searchController.definesPresentationContext = true

        
        tableView.tableHeaderView = searchController.searchBar

        //set up activityIndicator
        //activityIndicator.color = UIColor.magentaColor()
        activityIndicator.frame = CGRectMake(0.0, 0.0, 10.0, 10.0)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }
    
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        //put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        //put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        //put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? " " : ""
        let addressline = String(
            format: "%@%@%@%@%@%@%@ %@",
            //street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            //stree name
            selectedItem.thoroughfare ?? "",
            comma,
            //city
            selectedItem.locality ?? "",
            secondSpace,
            //state
            selectedItem.administrativeArea ?? "",
            //country
            selectedItem.country ?? ""
        )
        return addressline
    }

}

extension LocationSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        guard let searchBarText = self.searchController.searchBar.text
            else { return }
        
        guard searchBarText.characters.count > 1
            else {return}
        
        activityIndicator.bringSubviewToFront(self.view)
        activityIndicator.startAnimating()
        
        let request = MKLocalSearchRequest()
        
        request.naturalLanguageQuery = searchBarText
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { response, error in
            guard let response = response
                else {
                    print(error?.localizedDescription)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                    return }
            
            self.matchingItems = response.mapItems
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
            self.tableView.reloadData()
        }
    }
    
}


extension LocationSearchTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(matchingItems)
        return matchingItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        let selectedItem = matchingItems[indexPath.row].placemark
        
        cell!.textLabel!.text = selectedItem.name
        cell!.detailTextLabel!.text = parseAddress(selectedItem)
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        //print(selectedItem)
        
        searchController.active = false
        handleLocationSearchDelegate?.getLocationFromSearch(location!, placemark: selectedItem)
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

   
}