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
}
