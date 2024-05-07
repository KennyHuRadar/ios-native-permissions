//
//  SPMExampleApp.swift
//  SPMExample
//
//  Created by Kenny Hu on 4/26/24.
//

import SwiftUI
import RadarSDK

@main
struct SPMExampleApp: App {
    init(){
        Radar.initialize(publishableKey: "prj_test_pk_9d109308613d4a820294c0f17f3febe6d0063318")
        Radar.setUserId("usingSPM")
        Radar.trackOnce()
        print(Radar.sdkVersion)
        
        
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
