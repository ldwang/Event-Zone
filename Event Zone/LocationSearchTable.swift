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


class LocationSearchTableViewController : UIViewController {
    
    
    var matchingItems : [MKMapItem] = []
    var handleLocationSearchDelegate: HandleLocationSearch? = nil
    var location: String? = nil
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: View Setup
    
    override func viewDidLoad() {
        
        self.tableView.allowsSelection = true
        
        super.viewDidLoad()
        
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.delegate = self
        tableView.dataSource = self
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
        
        let request = MKLocalSearchRequest()
        
        request.naturalLanguageQuery = searchBarText
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { response, _ in
            guard let response = response
                else { return }
            
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
    
}


extension LocationSearchTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        let selectedItem = matchingItems[indexPath.row].placemark
        
        cell?.textLabel?.text = selectedItem.name
        cell?.detailTextLabel?.text = parseAddress(selectedItem)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        //print(selectedItem)
        searchController.active = false
        handleLocationSearchDelegate?.getLocationFromSearch(location!, placemark: selectedItem)
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }

   
}