/**
*  * *****************************************************************************
*  * Filename: DetailsViewModel.swift
*  * Author  : Nagraj Wadgire
*  * Creation Date: 21/12/20
*  * *
*  * *****************************************************************************
*  * Description:
*  * DetailsViewModel class will fetch details and notify the view via binding(closure)
*  *                                                                             *
*  * *****************************************************************************
*/

import Foundation

class DetailsViewModel {
    // MARK: - Initialization
    init(model: DetailsModel? = nil) {
        if let inputModel = model {
            arrDetails = inputModel
        }
    }
    var arrDetails = DetailsModel()
}

extension DetailsViewModel {
    func fetchDetails(completion: @escaping (Result<DetailsModel, Error>) -> Void) {
        WebserviceManager.shared.getDetails(urlString: Constants.detailsURL, completionBlock: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let data) :
                let decoder = JSONDecoder()
                do {
                    let strResponse = String(decoding: data, as: UTF8.self)
                    let modifiedResponse = String(strResponse.filter { !"\n\t".contains($0) })
                    let modifiedData = modifiedResponse.data(using: .utf8)
                    self.arrDetails = try decoder.decode(DetailsModel.self, from: modifiedData ?? Data())
                    self.arrDetails.details = self.arrDetails.details?.filter {($0 as Rows).rowTitle != nil}
                    completion(.success(try decoder.decode(DetailsModel.self, from: modifiedData ?? Data())))
                } catch {
                    completion(.failure(WebserviceError.parsingError(NetworkError.parsingError)))
                }
            }
        })
    }
    
    func fetchImageData(urlString: String, completion: @escaping(Data, Error?) -> Void) {
        WebserviceManager.shared.getImageData(urlString: urlString, completionBlock: { result in
            switch result {
            case .failure(let error):
                completion(Data(), error)
            case .success(let data) :
                completion(data, nil)
            }
        })
    }
}
