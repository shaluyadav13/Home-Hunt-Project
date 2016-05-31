//
//  MapViewController.swift
//  HomeHunt
//
//  Created by Kurma,Vinod Kumar on 4/14/16.
//  Copyright © 2016 Pullagurla,Mounika. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var homeDescriptionController : HomeDescriptionViewController!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var selectedAddress:String!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        homeDescriptionController = HomeDescriptionViewController()
        let location1:MKPointAnnotation = MKPointAnnotation()
        location1.title = "NorthWest Missouri State University"
        location1.subtitle = "MO"
        location1.coordinate = CLLocationCoordinate2D(latitude: 40.3, longitude: -94.8)
        mapView.addAnnotation(location1)
        self.mapView.region = MKCoordinateRegionMakeWithDistance(
            CLLocationCoordinate2D(latitude: 40.3, longitude: -94.9), 2000, 5000)
        
        
        let location2:MKPointAnnotation = MKPointAnnotation()
        location2.title = appDelegate.address
        selectedAddress = appDelegate.address
        
        let geocoder = CLGeocoder()
        
        
        
        
        geocoder.geocodeAddressString(selectedAddress, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let placemark = placemarks?[0]  {
                let cgpooint = MKPlacemark(placemark: placemark)
                let coordinate = cgpooint.coordinate
                 //self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                let loc1:MKPointAnnotation = MKPointAnnotation()
                loc1.coordinate = coordinate
                self.mapView.addAnnotation(loc1)
                print(loc1.coordinate)
              
                            }
        })
        
        
    
    }

    

}
