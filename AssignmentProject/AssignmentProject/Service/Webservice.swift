/**
*  * *****************************************************************************
*  * Filename: Webservice.swift
*  * Author  : Nagraj Wadgire
*  * Creation Date: 17/12/19
*  * *
*  * *****************************************************************************
*  * Description:
*  * This class will fetch the details by invoking REST API using URLSession
*  *                                                                             *
*  * *****************************************************************************
*/

import Foundation

class Webservice: NSObject {
    var cachedUrl: URL?
    /**
     This method is invoked to fetch the values from the server
     */
    func getDetails(completion: @escaping(Details, Error?) -> Void) {
        guard let url = URL(string: Constants.detailsURL) else {
            return
        }
        cachedUrl = url
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(Details(), error)
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error: invalid HTTP response code")
                return
            }
            guard let data = data else {
                print("Error: missing response data")
                return
            }
            do {
                let strResponse = String(decoding: data, as: UTF8.self)
                let modifiedResponse = String(strResponse.filter { !"\n\t".contains($0) })
                let modifiedData = modifiedResponse.data(using: .utf8)
                if let decodedResponse = try? JSONDecoder().decode(Details.self, from: modifiedData ?? Data()) {
                    print(decodedResponse)
                    completion(decodedResponse, nil)
                } else {
                    completion(Details(), error)
                }
            }
        }
        task.resume()
    }
    
    /**
     This method is invoked to download the image
     */
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from strURL: String, completion: @escaping(Data, Error?) -> Void) {
        guard let url = URL(string: strURL) else {
            completion(Data(), nil)
            return
        }
        getData(from: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(Data(), error)
                return
            }
            completion(data, error)
        }
    }
}
