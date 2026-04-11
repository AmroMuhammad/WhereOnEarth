//
//  LocationManager.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    func currentCountry() async -> String?
}

@MainActor
final class LocationManager: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private var continuation: CheckedContinuation<String?, Never>?
    private let timeout: TimeInterval

    init(timeout: TimeInterval = 5) {
        self.timeout = timeout
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func currentCountry() async -> String? {
        await withCheckedContinuation { cont in
            self.continuation = cont

            switch locationManager.authorizationStatus {
                case .notDetermined:
                    locationManager.requestWhenInUseAuthorization()
                case .authorizedWhenInUse, .authorizedAlways:
                    locationManager.requestLocation()
                default:
                    resume(with: nil)
                    return
            }

            let timeout = self.timeout
            Task { @MainActor [weak self] in
                try? await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                self?.timeoutResume()
            }
        }
    }

    private func resume(with value: String?) {
        continuation?.resume(returning: value)
        continuation = nil
    }

    private func timeoutResume() {
        if continuation != nil { resume(with: nil) }
    }

    nonisolated func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }
        Task { @MainActor [weak self] in
            guard let self else { return }
            await self.reverseGeocode(location)
        }
    }

    nonisolated func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        Task { @MainActor [weak self] in
            self?.resume(with: nil)
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            switch manager.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    if self.continuation != nil {
                        self.locationManager.requestLocation()
                    }
                case .denied, .restricted:
                    self.resume(with: nil)
                default:
                    break
            }
        }
    }

    private func reverseGeocode(_ location: CLLocation) async {
        let placemarks = try? await CLGeocoder().reverseGeocodeLocation(location)
        resume(with: placemarks?.first?.country)
    }
}
