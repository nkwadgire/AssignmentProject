/**
*  * *****************************************************************************
*  * Filename: Webservice.swift
*  * Author  : Nagraj Wadgire
*  * Creation Date: 17/12/20
*  * *
*  * *****************************************************************************
*  * Description:
*  * This class will fetch the details by invoking REST API using URLSession
*  *                                                                             *
*  * *****************************************************************************
*/

import Foundation

enum WebserviceError: Error {
    case internetNotAvailable(String?)
    case invalidURL(String?)
    case parsingError(String?)
    case invalidResponse(Data?, URLResponse?)
}

class WebserviceManager: NSObject {
    static let shared: WebserviceManager = WebserviceManager()
    var cachedUrl: URL?
    /**
     This method is invoked to fetch the values from the server
     */

    public func getDetails(urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        guard (NetworkReachability.isConnectedToNetwork()) == true else {
            completionBlock(.failure(WebserviceError.internetNotAvailable(NetworkError.alertMessage)))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completionBlock(.failure(WebserviceError.invalidURL(NetworkError.invalidURLMessage)))
            return
        }
        cachedUrl = url
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }

            guard let responseData = data,
                  let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: invalid HTTP response code")
                completionBlock(.failure(WebserviceError.invalidResponse(data, response)))
                return
            }
            completionBlock(.success(responseData))
            }
        task.resume()
    }
    
    /**
     This method is invoked to download the image
     */
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getImageData(urlString: String, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        guard (NetworkReachability.isConnectedToNetwork()) == true else {
            completionBlock(.failure(WebserviceError.internetNotAvailable(NetworkError.alertMessage)))
            return
        }
        guard let url = URL(string: urlString) else {
            completionBlock(.failure(WebserviceError.invalidURL(NetworkError.invalidURLMessage)))
            return
        }
        getData(from: url) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }
            guard let responseData = data,
            let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completionBlock(.failure(WebserviceError.invalidResponse(data, response)))
                return
            }
            completionBlock(.success(responseData))
        }
    }
}

extension WebserviceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .internetNotAvailable:
            return NSLocalizedString(NetworkError.alertMessage, comment: NetworkError.alertMessage)
        case .invalidURL:
            return NSLocalizedString(NetworkError.invalidURLMessage, comment: NetworkError.invalidURLMessage)
        case .parsingError:
            return NSLocalizedString(NetworkError.parsingError, comment: NetworkError.parsingError)
        case .invalidResponse:
            return NSLocalizedString(NetworkError.invalidResponseMessage, comment: NetworkError.invalidResponseMessage)
        }
    }
}
