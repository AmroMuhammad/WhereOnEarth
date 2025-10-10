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
    private let cachingManager: CachingManagerContract
    @Published var locationManager: LocationManager
    
    @Published  var currentUserCountry: String = ""
    @Published var allCountries: Countries = []
    @Published var isSuccess: Bool?
    @Published var showError: Bool?
    @Published var searchQuery = ""
    @Published var exceedMaxSelectedCountries: Bool = false
    @Published var selectedCountriesList: Countries = []
    @Published var selectedCountry: Country?
    @Published var shouldNavigateToCountryDetail: Bool = false

    private let maxSelectedCountries = 5
    var errorMessage: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    var searchList: Countries {
        searchQuery.isEmpty ? allCountries : allCountries.filter {$0.name.localizedCaseInsensitiveContains(searchQuery)}
    }
    
    init(countriesUseCase: FetchCountriesUseCaseContract = FetchCountriesUseCase(),
         locationManager: LocationManager = LocationManager(),
         cachingManager: CachingManagerContract = CachingManager()
    ) {
        self.countriesUseCase = countriesUseCase
        self.locationManager = locationManager
        self.cachingManager = cachingManager
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
        return allCountries.first(where: { $0.name == currentUserCountry }) ??
        allCountries.first(where: { $0.name == Constants.Localization.egypt })
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
        cachingManager.save(selectedCountriesList)
    }
    
    func saveSelectedCountries() {
        cachingManager.save(selectedCountriesList)
    }
    
    func loadCachedCountries() {
        selectedCountriesList = cachingManager.load()
    }
}
