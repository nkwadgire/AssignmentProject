/**
*  * *****************************************************************************
*  * Filename: Constants.swift
*  * Author  : Nagraj Wadgire
*  * Creation Date: 17/12/20
*  * *
*  * *****************************************************************************
*  * Description:
*  * This struct will contain constants
*  *                                                                             *
*  * *****************************************************************************
*/

import Foundation

public struct Constants {
    static let detailsURL: String = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    static let pullToRefresh: String = "Pull to refresh"
}

public struct NetworkError {
    static let alertMessage: String = "Unable to fetch the details, please try after some time."
    static let invalidURLMessage: String = "Invalid URL."
    static let invalidResponseMessage: String = "Invalid Response."
    static let parsingError: String = "Parsing Error."
}
