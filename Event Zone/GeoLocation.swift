//
//  GeoLocation.swift
//  Event Zone
//
//  Created by Long Wang on 2016-07-02.
//  Copyright © 2016 Long Wang. All rights reserved.
//

import Foundation
import MapKit

class GeoLocation : NSObject {
    // Reference from http://cungcode.com/how-to-find-midpoint-between-coordinates/
    //  /** Degrees to Radian **/
    
    func degreeToRadian(angle:CLLocationDegrees) -> CGFloat{
        return ((CGFloat(angle)) / 180.0 * CGFloat(M_PI))
    }
    
    //        /** Radians to Degrees **/
    func radianToDegree(radian:CGFloat) -> CLLocationDegrees{
        return CLLocationDegrees(radian * CGFloat(180.0 / M_PI))
    }
    
    func middlePointOfListMarkers(listCoords: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D{
        var x = 0.0 as CGFloat
        var y = 0.0 as CGFloat
        var z = 0.0 as CGFloat
        for coordinate in listCoords{
            let lat:CGFloat = degreeToRadian(coordinate.latitude)
            let lon:CGFloat = degreeToRadian(coordinate.longitude)
            x = x + cos(lat) * cos(lon)
            y = y + cos(lat) * sin(lon)
            z = z + sin(lat)
        }
        x = x/CGFloat(listCoords.count)
        y = y/CGFloat(listCoords.count)
        z = z/CGFloat(listCoords.count)
        
        let resultLon: CGFloat = atan2(y, x)
        let resultHyp: CGFloat = sqrt(x*x+y*y)
        let resultLat:CGFloat = atan2(z, resultHyp)
        let newLat = radianToDegree(resultLat)
        let newLon = radianToDegree(resultLon)
        let result:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: newLat, longitude: newLon)
        return result
    }
    
    func fitMapViewToAnnotations(mapView: MKMapView) -> Void {
        let mapEdgePadding = UIEdgeInsets(top:20, left: 20, bottom: 20, right: 20)
        var zoomRect: MKMapRect = MKMapRectNull
        
        switch mapView.annotations.count {
        case 1:
            let span = MKCoordinateSpanMake(0.5, 0.5)
            let annotation = mapView.annotations.first! as MKAnnotation
            let region = MKCoordinateRegionMake(annotation.coordinate, span)
            mapView.setRegion(region, animated: true)
        case 2:
            var coordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
            for annotation in mapView.annotations as [MKAnnotation] {
                let aPoint: MKMapPoint = MKMapPointForCoordinate(annotation.coordinate)
                coordinates.append(annotation.coordinate)
                let rect:MKMapRect = MKMapRectMake(aPoint.x, aPoint.y, 0.1, 0.1)
                
                if MKMapRectIsNull(zoomRect) {
                    zoomRect = rect
                } else {
                    zoomRect = MKMapRectUnion(rect, zoomRect)
                }
            }
            mapView.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
            
            //clear existing polyline
            mapView.removeOverlays(mapView.overlays)
            let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
            
            let lat = mapView.centerCoordinate.latitude
            
            let middleCoordinate: CLLocationCoordinate2D = GeoLocation().middlePointOfListMarkers(coordinates)
            
            let long = middleCoordinate.longitude
            
            mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: lat, longitude: long), animated: true)
            
        default:
            ()
        }
    }


}
