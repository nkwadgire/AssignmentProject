/**
*  * *****************************************************************************
*  * Filename: AssignmentProjectTests.swift
*  * Author  : Nagraj Wadgire
*  * Creation Date: 17/12/20
*  * *
*  * *****************************************************************************
*  * Description:
*  * This class contains the unittestcases
*  *                                                                             *
*  * *****************************************************************************
*/

import XCTest
@testable import AssignmentProject

class AssignmentProjectTests: XCTestCase {

    var webservice: WebserviceManager?
  //  var networkStatus: NetworkReachability?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        webservice = WebserviceManager()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        webservice = nil
    }
    
    func testGetDetailsWithExpectedURLHostAndPath() {
        webservice?.getDetails(urlString: Constants.detailsURL, completionBlock: { _ in
        })
        XCTAssertEqual(webservice?.cachedUrl?.host, "dl.dropboxusercontent.com")
        XCTAssertEqual(webservice?.cachedUrl?.path, "/s/2iodh4vg0eortkl/facts.json")
    }
    
    func testGetDetailsSuccessReturnsDetails() {
        let detailsExpectation = expectation(description: "details")
        var detailsResponse: Data?
        
        webservice?.getDetails(urlString: Constants.detailsURL, completionBlock: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                detailsResponse = data
                detailsExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 5.0) { (_) in
            XCTAssertNotNil(detailsResponse)
        }
    }
    
    func testGetDetailsWhenResponseErrorReturnsNil() {
        let errorNotExpectation = expectation(description: "errorNil")
        var errorResponse: Error?
        
        webservice?.getDetails(urlString: Constants.detailsURL, completionBlock: { result in
            switch result {
            case .failure(let error):
                errorResponse = error
                print(error)
            case .success:
                print("success")
            }
            errorNotExpectation.fulfill()
        })
        waitForExpectations(timeout: 5.0) { (_) in
            XCTAssertNil(errorResponse)
        }
    }
    
    func testGetDetailsWhenResponseErrorReturnsError() {
        let error = NSError(domain: "error", code: 1234, userInfo: nil)
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        
        webservice?.getDetails(urlString: Constants.detailsURL, completionBlock: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success:
                print("success")
            }
            errorResponse = error
            errorExpectation.fulfill()
        })
        waitForExpectations(timeout: 5.0) { (_) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testGetDetailsWhenEmptyDataReturnsNil() {
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        
        webservice?.getDetails(urlString: Constants.detailsURL, completionBlock: { result in
            switch result {
            case .failure(let error):
                errorResponse = error
                print(error)
            case .success:
                print("success")
            }
            errorExpectation.fulfill()
        })
        waitForExpectations(timeout: 5.0) { (_) in
            XCTAssertNil(errorResponse)
        }
    }
    
    func testGetDetailsSuccessReturnsRows() {
        let rowsExpectation = expectation(description: "rows")
        var arrDetails: DetailsModel?
        var rowsResponse: [Rows]?
        
        webservice?.getDetails(urlString: Constants.detailsURL, completionBlock: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let strResponse = String(decoding: data, as: UTF8.self)
                    let modifiedResponse = String(strResponse.filter { !"\n\t".contains($0) })
                    let modifiedData = modifiedResponse.data(using: .utf8)
                    arrDetails = try decoder.decode(DetailsModel.self, from: modifiedData ?? Data())
                    rowsResponse = arrDetails?.details?.filter {($0 as Rows).rowTitle != nil}
                    rowsExpectation.fulfill()
                } catch {
                }
            }
        })
        waitForExpectations(timeout: 5.0) { (_) in
            XCTAssertNotNil(rowsResponse)
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
