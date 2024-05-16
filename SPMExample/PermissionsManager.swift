//
//  File.swift
//  SPMExample
//
//  Created by Kenny Hu on 5/7/24.
//

import Foundation
import CoreLocation
import RadarSDK

class PermissionsManager: NSObject, RadarDelegate, ObservableObject, CLLocationManagerDelegate {
    
    @Published var viewState:RadarLocationPermissionState

    var locationManager: CLLocationManager

    var danglingBackgroundPermissionsRequest = false
    var inBackgroundLocationPopUp = false

    // hold status of location permissions
    var foregroundPopupAvailable = true
    var backgroundPopupAvailable = true
    var userRejectedBackgroundPermissions = false

    
    private override init() {
        locationManager = CLLocationManager()
        viewState = RadarLocationPermissionState.NoPermissionsGranted
        super.init()
        //Radar.initialize(publishableKey: "000")
        viewState = Radar.getLocationPermissionsStatus().locationPermissionState
        //Radar.setDelegate(self)
        locationManager.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
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
        // do nothing
    }

    func requestLocationPermissions(background: Bool) {
        if background && self.locationManager.authorizationStatus == .authorizedWhenInUse {
            danglingBackgroundPermissionsRequest = true
            backgroundPopupAvailable = false
            updateStatus()
            locationManager.requestAlwaysAuthorization()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if self.danglingBackgroundPermissionsRequest {
                    print("pop-up did not show")
                    self.userRejectedBackgroundPermissions = true
                    self.updateStatus()
                }
                self.danglingBackgroundPermissionsRequest = false
            }
        }
        
        if !background {
            foregroundPopupAvailable = false
            updateStatus()
            locationManager.requestWhenInUseAuthorization()
        }
    }

    @objc func applicationDidBecomeActive() {
        if inBackgroundLocationPopUp {
            userRejectedBackgroundPermissions = true
            updateStatus()
        }
        inBackgroundLocationPopUp = false
    }
    
    @objc func applicationWillResignActive() {
        if danglingBackgroundPermissionsRequest {
            inBackgroundLocationPopUp = true
            updateStatus()
        }
        danglingBackgroundPermissionsRequest = false
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        userRejectedBackgroundPermissions = userRejectedBackgroundPermissions || status == .denied
        //let newStatus = RadarLocationPermissionsStatus(status: status, backgroundPopupAvailable: self.status.backgroundPopupAvailable, foregroundPopupAvailable: self.status.foregroundPopupAvailable, userRejectedBackgroundPermissions: self.status.userRejectedBackgroundPermissions || status == .denied)
        updateStatus()
    }

    func updateStatus(){
        let permissionStatus = self.locationManager.authorizationStatus
        if permissionStatus == .notDetermined {
            viewState = foregroundPopupAvailable ? RadarLocationPermissionState.NoPermissionsGranted : RadarLocationPermissionState.ForegroundPermissionsPending;
        } else if permissionStatus == .denied {
            viewState = RadarLocationPermissionState.ForegroundPermissionsRejected
        } else if permissionStatus == .authorizedAlways {
            viewState = RadarLocationPermissionState.BackgroundPermissionsGranted
        } else if permissionStatus == .authorizedWhenInUse {
            if userRejectedBackgroundPermissions {
                viewState = RadarLocationPermissionState.BackgroundPermissionsRejected
            } else {
                viewState = backgroundPopupAvailable ? RadarLocationPermissionState.ForegroundPermissionsGranted : RadarLocationPermissionState.BackgroundPermissionsPending
            }
        } 
        else if permissionStatus == .restricted {
            viewState = RadarLocationPermissionState.PermissionsRestricted
        }
        else {
            viewState = RadarLocationPermissionState.Unknown
        }
        print("Permissions status updated to: ")
        print(viewState.rawValue)
        print("Foreground popup available: ")
        print(foregroundPopupAvailable)
        print("Background popup available: ")
        print(backgroundPopupAvailable)
        print("User rejected background permissions: ")
        print(userRejectedBackgroundPermissions)
    }



    static let shared = PermissionsManager()
            
}
