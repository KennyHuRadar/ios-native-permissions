import SwiftUI
import CoreLocation
import RadarSDK

struct ContentView: View {
    @ObservedObject var permissionsManager = PermissionsManager.shared
    var body: some View {
        NavigationView {
            Group {
                switch permissionsManager.viewState {
                case .NoPermissionsGranted:
                    GetForegroundPermissionStateView()
                case .ForegroundPermissionsPending:
                    WaitingForForegroundPermissionView()
                case .ForegroundPermissionsRejected:
                    GoToSettingsViewForegroundDenied()
                case .ForegroundPermissionsGranted:
                    GetBackgroundPermissionStateView()
                case .BackgroundPermissionsPending:
                    WaitingForBackgroundPermissionView()
                case .BackgroundPermissionsRejected:
                    GoToSettingsViewBackgroundDenied()
                case .BackgroundPermissionsGranted:
                    SuccessView()
                default:
                    GoToSettingsView()
                }
            }
        }
    }
}

struct GetForegroundPermissionStateView: View {
    @ObservedObject var permissionsManager = PermissionsManager.shared
    var body: some View {
        VStack {
            Text("Get foreground location permissions, explain why you need them here.")
            Button("Request Foreground Permission") {
                permissionsManager.requestLocationPermissions(background: false)
            }
        }.navigationBarTitle("Get foreground", displayMode: .inline)
    }
}

struct GetBackgroundPermissionStateView: View {
    @ObservedObject var permissionsManager = PermissionsManager.shared
    var body: some View {
        VStack {
            Text("Get background location permissions, explain why you need them here")
            Button("Request Background Permission") {
                permissionsManager.requestLocationPermissions(background: true)
            }
        }.navigationBarTitle("Get background", displayMode: .inline)
    }
}

struct GoToSettingsView: View {
    var body: some View {
        VStack {
            Text("Go to settings, you cannot proceed without the permissions")
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }.navigationBarTitle("Go to settings", displayMode: .inline)
    }
}

struct GoToSettingsViewForegroundDenied: View {
    var body: some View {
        VStack {
            Text("Go to settings, you cannot proceed without the  foreground permissions")
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }.navigationBarTitle("Go to settings", displayMode: .inline)
    }
}

struct GoToSettingsViewBackgroundDenied: View {
    var body: some View {
        VStack {
            Text("Go to settings, you cannot proceed without the background permissions")
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }.navigationBarTitle("Go to settings", displayMode: .inline)
    }
}

struct SuccessView: View {
    var body: some View {
        Text("We got the location permissions!")
            .navigationTitle("Success")
    }
}

struct FailureView: View {
    var body: some View {
        Text("Failure View")
            .navigationTitle("Failure")
    }
}
struct WaitingForBackgroundPermissionView: View {
    var body: some View {
        Text("Waiting for background permission")
        .navigationBarTitle("Waiting", displayMode: .inline)
    }
}

struct WaitingForForegroundPermissionView: View {
    var body: some View {
        Text("Waiting for foreground permission")
        .navigationBarTitle("Waiting", displayMode: .inline)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
