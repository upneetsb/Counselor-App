//
//  Locationer.swift
//  final_project
//
//  Created by Upneet Bir on 12/1/21.
//

import Foundation
import CoreLocation

class Locationer: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var lm = CLLocationManager()
    @Published var location = CLLocationCoordinate2D(latitude: 38, longitude: -76)
//    var l_values:[CLLocationCoordinate2D] = []
//    var to_track: Bool = false
//    var total_tracks_to_map:[CLLocationCoordinate2D] = []
    override init() {
        super.init()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.distanceFilter = 4
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let loc = locations.last {
            location = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        }
    }
}
