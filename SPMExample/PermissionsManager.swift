//
//  File.swift
//  SPMExample
//
//  Created by Kenny Hu on 5/7/24.
//

import Foundation
import CoreLocation
import RadarSDK

class PermissionsManager: NSObject, RadarDelegate, ObservableObject  {
    
    @Published var viewState:RadarLocationPermissionState
    
    private override init() {
        viewState = RadarLocationPermissionState.NoPermissionsGranted
        super.init()
        Radar.initialize(publishableKey: "000")
        viewState = Radar.getLocationPermissionsStatus().locationPermissionState
        Radar.setDelegate(self)
    }
    
    func didReceiveEvents(_ events: [RadarEvent], user: RadarUser?) {
        // do nothing
    }
    
    func didUpdateLocation(_ location: CLLocation, user: RadarUser) {
        // do nothing
    }
    
    func didUpdateClientLocation(_ location: CLLocation, stopped: Bool, source: RadarLocationSource) {
        // do nothing
    }
    
    func didFail(status: RadarStatus) {
        // do nothing
    }
    
    func didLog(message: String) {
        // do nothing
    }
    
    func didUpdateClientLocationPermissionsStatus(status: RadarLocationPermissionsStatus) {
        viewState = status.locationPermissionState
    }

    static let shared = PermissionsManager()
            
}
