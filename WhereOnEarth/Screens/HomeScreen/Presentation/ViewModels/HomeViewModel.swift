//
//  HomeViewModel.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    private let countriesUseCase: FetchCountriesUseCaseContract
    @Published var locationManager: LocationManager
    
    @Published  var currentUserCountry: String = ""
    @Published var allCountries: [Country] = []
    @Published var isSuccess: Bool?
    @Published var showError: Bool?
    @Published var searchQuery = ""
    @Published var exceedMaxSelectedCountries: Bool = false
    @Published var selectedCountriesList: [Country] = []
    @Published var selectedCountry: Country?

    private let maxSelectedCountries = 5
    private static let fallbackCountryCode = "EG"
    @Published var errorMessage: String = ""

    var searchList: [Country] {
        searchQuery.isEmpty ? allCountries : allCountries.filter {$0.name?.common?.localizedCaseInsensitiveContains(searchQuery) ?? false}
    }

    init(countriesUseCase: FetchCountriesUseCaseContract = FetchCountriesUseCase(),
         locationManager: LocationManager = LocationManager()) {
        self.countriesUseCase = countriesUseCase
        self.locationManager = locationManager
        self.currentUserCountry = locationManager.userCountry
        bindLocationUpdates()
    }
    
    private func bindLocationUpdates() {
        locationManager.$userCountry
            .receive(on: DispatchQueue.main)
            .sink { [weak self] country in
                guard let self else { return }
                if !country.isEmpty {
                    self.currentUserCountry = country
                }
            }
            .store(in: &cancellables)
    }
    
    func getAllCountries() {
        Task {
            do {
                let countries = try await countriesUseCase.executeFetchCountries()
                self.allCountries = countries
                self.isSuccess = true
            } catch let error as APIClientError {
                self.errorMessage = error.errorDescription ?? ""
                self.showError = true
            } catch {
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
}
