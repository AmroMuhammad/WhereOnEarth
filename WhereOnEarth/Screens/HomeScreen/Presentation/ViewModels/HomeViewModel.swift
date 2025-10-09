//
//  HomeViewModel.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 09/10/2025.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
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
    var errorMessage: String = ""
    private var cancellables = Set<AnyCancellable>()
    
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
    
    func getAllCountries(){
        countriesUseCase.executeFetchCountries()
            .sink { [weak self] completion in
                guard let self else { return }
                if case .failure(let error) = completion {
                    self.errorMessage = error.errorDescription
                    self.showError = true
                }
            } receiveValue: { [weak self] countries in
                guard let self else { return }
                self.isSuccess = true
                self.allCountries = countries
            }.store(in: &cancellables)
    }
    
    func getCurrentUserCountry() -> Country? {
        return allCountries.first(where: { $0.name?.common == currentUserCountry }) ??
        allCountries.first(where: { $0.name?.common == Constants.Localization.egypt })
    }
    
    func countrySelection(_ country: Country) {
        if selectedCountriesList.contains(country) {
            selectedCountriesList.removeAll { $0 == country }
            exceedMaxSelectedCountries = false
        } else {
            if selectedCountriesList.count < maxSelectedCountries {
                selectedCountriesList.append(country)
                exceedMaxSelectedCountries = false
            }else{
                exceedMaxSelectedCountries = true
            }
        }
    }
    
    func deleteCountry(_ country: Country) {
        selectedCountriesList.removeAll { $0 == country }
    }
}
