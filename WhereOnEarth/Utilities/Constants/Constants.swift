//
//  Constants.swift
//  WhereOnEarth
//
//  Created by Amr Muhammad on 08/10/2025.
//

import Foundation

struct Constants {
    struct AppError {
        static let badResponse = "The request could not be completed due to network error or no response."
        static let badRequest = "The server cannot process the request due to a client error."
        static let unauthorized = "Authentication is required and has failed or has not been provided."
        static let forbidden = "You do not have the necessary permissions for the resource."
        static let notFound = "The requested resource could not be found."
        static let internalServerError = "The server encountered an unexpected condition that prevented it from fulfilling the request."
        static let serviceUnavailable = "The server is currently unable to handle the request due to a temporary overloading or maintenance of the server."
        static let requestTimeout = "Request time out"
        static let invalidURL = "Invalid URL"
        static let noConnection = "No Internet Connection, plaese try again"
        static let SomeThingWentWrong = "Something went wrong"
    }

    struct Localization {
        static let appName = "Where On Earth?"
        static let defaultCountry = "Default Country:"
        static let country = "Country:"
        static let capital = "Capital:"
        static let currency = "Currency:"
        static let selectedCountries = "Selected Countries:"
        static let addCountryButtonTitle = "Add Country"
        static let egypt = "Egypt"
        static let done = "Done"
        static let searchCountries = "Search for countries"
        static let otherCountry = "other countries :"
        static let onlyFiveCountriesAllowed = "You Can't Add more than 5 Countries."
        static let checkConnection = "Something went wrong, Please check your Internet Connection and try again"
        static let addUpToCountries = "You can add up to 5 countries"
        static let error = "Error"
        static let retry = "Retry"
        static let alertDeleteConfirmation = "Confirmation!"
        static let alertDeleteDescription = "Do you want to delete this country?"
        static let delete = "Delete"
        static let cancel = "Cancel"
        static let language = "Language:"
        static let cacheKey = "selected_countries"
        static let countryDetails = "Country Details"
    }
}
