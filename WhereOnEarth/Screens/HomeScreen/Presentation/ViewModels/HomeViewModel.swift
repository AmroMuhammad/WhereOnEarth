//
//  HomeViewModel.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 10/04/2026.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {

    private let countriesUseCase: FetchCountriesUseCaseContract
    private let locationService: LocationServiceProtocol

    @Published var allCountries: [Country] = []
    @Published var defaultCountry: Country?
    @Published var isSuccess: Bool?
    @Published var showError: Bool?
    @Published var searchQuery = ""
    @Published var exceedMaxSelectedCountries: Bool = false
    @Published var selectedCountriesList: [Country] = []
    @Published var selectedCountry: Country?

    private let maxSelectedCountries = 5
    private static let fallbackCountryCode = "EG"
    var errorMessage: String = ""

    var searchList: [Country] {
        searchQuery.isEmpty ? allCountries : allCountries.filter {$0.name?.common?.localizedCaseInsensitiveContains(searchQuery) ?? false}
    }

    init(countriesUseCase: FetchCountriesUseCaseContract = FetchCountriesUseCase(),
         locationService: LocationServiceProtocol? = nil) {
        self.countriesUseCase = countriesUseCase
        self.locationService = locationService ?? LocationManager()
    }

    func getAllCountries() {
        Task {
            do {
                let countries = try await countriesUseCase.executeFetchCountries()
                self.allCountries = countries
                await self.resolveDefaultCountry()
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

    private func resolveDefaultCountry() async {
        let country = await locationService.currentCountry()
        if let country, let match = allCountries.first(where: { $0.name?.common == country }) {
            defaultCountry = match
            return
        }
        defaultCountry = allCountries.first(where: { $0.cca2 == Self.fallbackCountryCode })
    }

    func countrySelection(_ country: Country) {
        if selectedCountriesList.contains(country) {
            selectedCountriesList.removeAll { $0 == country }
            exceedMaxSelectedCountries = false
        } else {
            if selectedCountriesList.count < maxSelectedCountries {
                selectedCountriesList.append(country)
                exceedMaxSelectedCountries = false
            } else {
                exceedMaxSelectedCountries = true
            }
        }
    }

    func deleteCountry(_ country: Country) {
        selectedCountriesList.removeAll { $0 == country }
    }
}
