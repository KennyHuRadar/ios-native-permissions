import SwiftUI
import CoreLocation
import RadarSDK

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var locationAuthorized: Bool = false

    override init() {
        super.init()
        self.locationManager.delegate = self
    }

    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationAuthorized = true
        default:
            self.locationAuthorized = false
        }
    }
}

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear(perform: {
            //let location = CLLocation(latitude: 49.68956683045484, longitude: -107.27634218307078)
            locationManager.requestLocationAuthorization()
            let location = CLLocation(latitude: 49.68956683045484, longitude: -107.27634218307078)
           Radar.getContext(location: location) { status, location, context in
                // Handle the result
                if status == .success {
                    print("Context: \(String(describing: context))")
                } else {
                    print("Failed to get context")
                }
            }
        })
        .onChange(of: locationManager.locationAuthorized) { newValue in
            if newValue {
                // Location permission was granted, do something here
                print("Location permission was granted")
                print(Radar.sdkVersion)
                Radar.trackOnce()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
