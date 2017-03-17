//
//  LocationManager.swift
//  Maze
//
//  Created by Cristian Bellomo on 16/03/2017.
//  Copyright © 2017 Cristian Bellomo. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    
    static let shared = { return LocationManager()}()
    
    static var locationUpdates:Observable<CLLocation?> {
        let locations = self.shared.rx.methodInvoked(#selector(locationManager(_:didUpdateLocations:))).map{ $0.last as! [CLLocation] }.map { $0.last }
        return locations
                .do(onSubscribe: {
                    LocationManager.shared.requestWhenInUseAuthorization()
                    LocationManager.shared.startUpdatingLocation()
                })
                .do(onDispose:{LocationManager.shared.stopUpdatingLocation()})
                .shareReplay(1)
    }
    
    override init() {
        super.init()
        self.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
    
}
