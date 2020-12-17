/**
*  * *****************************************************************************
*  * Filename: Details.swift
*  * Author  : Nagraj Wadgire
*  * Creation Date: 17/12/20
*  * *
*  * *****************************************************************************
*  * Description:
*  * Model struct will hold the API response
*  *                                                                             *
*  * *****************************************************************************
*/

import Foundation

struct Details: Decodable {
    var navTitle: String?
    var details: [Rows]?
    
    init() {}
    init(from decoder: Decoder) throws {
        do {
            let value = try decoder.container(keyedBy: CodingKeys.self)
            navTitle = try value.decodeIfPresent(String.self, forKey: .navTitle)
            details = try value.decodeIfPresent([Rows].self, forKey: .details)
        } catch {
            print("Error reading JSON file: \(error.localizedDescription)")
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case navTitle = "title"
        case details = "rows"
    }
}

struct Rows: Decodable {
    var rowTitle: String? = ""
    var rowDescription: String? = ""
    var rowImageHref: String? = ""
    
    init() {}
    
    init(from decoder: Decoder) throws {
        do {
            let value = try decoder.container(keyedBy: CodingKeys.self)
            rowTitle = try value.decodeIfPresent(String.self, forKey: .rowTitle)
            rowDescription = try value.decodeIfPresent(String.self, forKey: .rowDescription)
            rowImageHref = try value.decodeIfPresent(String.self, forKey: .rowImageHref)
        } catch {
            print("Error reading JSON file: \(error.localizedDescription)")
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case rowTitle = "title"
        case rowDescription = "description"
        case rowImageHref = "imageHref"
    }
}
