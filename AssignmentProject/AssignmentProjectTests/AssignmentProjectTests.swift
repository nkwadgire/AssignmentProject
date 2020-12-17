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

    var webservice: Webservice?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        webservice = Webservice()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        webservice = nil
    }
    
    func testGetDetailsWithExpectedURLHostAndPath() {
        webservice?.getDetails(completion: {_, _  in
        })
        XCTAssertEqual(webservice?.cachedUrl?.host, "dl.dropboxusercontent.com")
        XCTAssertEqual(webservice?.cachedUrl?.path, "/s/2iodh4vg0eortkl/facts.json")
    }
    
    func testGetDetailsSuccessReturnsDetails() {
        let detailsExpectation = expectation(description: "details")
        var detailsResponse: Details?
        
        webservice?.getDetails(completion: {(response, _)  in
            detailsResponse = response
            detailsExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 5.0) { (_) in
            XCTAssertNotNil(detailsResponse)
        }
    }
    
    func testGetDetailsWhenResponseErrorReturnsNil() {
        let errorNotExpectation = expectation(description: "errorNil")
        var errorResponse: Error?
        
        webservice?.getDetails { (_, error) in
            errorResponse = error
            errorNotExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0) { (_) in
            XCTAssertNil(errorResponse)
        }
    }
    
    func testGetDetailsWhenResponseErrorReturnsError() {
        let error = NSError(domain: "error", code: 1234, userInfo: nil)
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?

        webservice?.getDetails { (_, _) in
            errorResponse = error
            errorExpectation.fulfill()
        }

        waitForExpectations(timeout: 5.0) { (_) in
            XCTAssertNotNil(errorResponse)
        }
    }
    
    func testGetDetailsWhenEmptyDataReturnsNil() {
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?
        webservice?.getDetails { (_, error) in
            errorResponse = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 5.0) { (_) in
            XCTAssertNil(errorResponse)
        }
    }
    
    func testGetDetailsSuccessReturnsRows() {
        let rowsExpectation = expectation(description: "rows")
        var rowsResponse: [Rows]?
        webservice?.getDetails { (response, _) in
            rowsResponse = response.details
            rowsExpectation.fulfill()
        }
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
