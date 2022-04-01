//
//  InstabugNetworkClientTests.swift
//  InstabugNetworkClientTests
//
//  Created by Yousef Hamza on 1/13/21.
//

import XCTest
import CoreData
@testable import InstabugNetworkClient
@testable import InstabugInterview

class InstabugNetworkClientTests: XCTestCase {
    
    var netWorkClient: NetworkClient!
    var session = MockURLSession()
    var viewController: ViewController!
//    var mockStorageManager: MockContainerManager!
    
    override func setUp() {
        super.setUp()
        netWorkClient = NetworkClient(session: session)
        viewController = ViewController()
        
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    
    private func loadJsonData(file: String) -> Data? {
        if let jsonFilePath = Bundle(for: type(of:  self)).path(forResource: file, ofType: "json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
            if let jsonData = try? Data(contentsOf: jsonFileURL) {
                return jsonData
            }
        }
        return nil
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    //   Test Excution of Requests
    
    func testMockExcuteRequests() throws {
        do {
            let dataTask = MockURLSessionDataTask()
            session.nextDataTask = dataTask
            let url = URL(string: "https://httpbin.org/range/")!
            netWorkClient.get(url) { _, _, _ in
            }
            XCTAssert(dataTask.resumeWasCalled)
        }
        do {
            let dataTask = MockURLSessionDataTask()
            session.nextDataTask = dataTask
            let url = URL(string: "https://httpbin.org/delete")!
            netWorkClient.delete(url) { _, _, _ in
            }
            XCTAssert(dataTask.resumeWasCalled)
        }
        do {
            let dataTask = MockURLSessionDataTask()
            session.nextDataTask = dataTask
            
            let url = URL(string: "https://httpbin.org/post")!
            netWorkClient.post(url) { _, _, _ in
            }
            XCTAssert(dataTask.resumeWasCalled)
        }
        
        do {
            let dataTask = MockURLSessionDataTask()
            session.nextDataTask = dataTask
            
            let url = URL(string: "https://httpbin.org/put")!
            netWorkClient.put(url) { _, _, _ in
            }
            XCTAssert(dataTask.resumeWasCalled)
        }
    }
    
    //    Test saving Records with Errors
    func testSavingErrorRecords() {
        //        Deleting all Records from Core data

        viewController.deleteAllData("Record", completion: nil)
        do {
            let dataTask = MockURLSessionDataTask()
            session.nextDataTask = dataTask
            session.nextError = HTTPError(rawValue: 400)
            let url = URL(string: "https://httpbin.org/put")!
            let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
            session.nextURLResponse = response
            let exp = expectation(description: "Saving Record")
            netWorkClient.post(url) { data, urlResponse, err in
                if let urlResponse = urlResponse {
                    self.viewController.handleResponse(dataResponse: data, urlResponse: urlResponse, requestPayLoad: nil, method: .put, url: url, completion: {
                        exp.fulfill()
                        
                    })
                }
                
            }
            waitForExpectations(timeout: 5)
            XCTAssertEqual(viewController.fetchSavedRecords().count, 1, "item saved successfully")
            XCTAssertEqual(viewController.fetchSavedRecords().count, 1, "item saved successfully")
        }
        
        do {
            
            let dataTask = MockURLSessionDataTask()
            session.nextDataTask = dataTask
            session.nextError = HTTPError(rawValue: 401)
            let url = URL(string: "https://httpbin.org/get")!
            let response = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)!
            session.nextURLResponse = response
            
            let exp = expectation(description: "Saving Record")
            netWorkClient.post(url) { data, urlResponse, err in
                if let urlResponse = urlResponse {
                    self.viewController.handleResponse(dataResponse: data, urlResponse: urlResponse, requestPayLoad: nil, method: .get, url: url, completion: {
                        exp.fulfill()
                        
                    })
                }
                
            }
        }
        waitForExpectations(timeout: 5)
        XCTAssertEqual(viewController.fetchSavedRecords().count, 2, "item saved successfully")
        
        do {
            let dataTask = MockURLSessionDataTask()
            session.nextDataTask = dataTask
            session.nextError = HTTPError(rawValue: 403)
            
            let url = URL(string: "https://httpbin.org/post")!
            let response = HTTPURLResponse(url: url, statusCode: 403, httpVersion: nil, headerFields: nil)!
            session.nextURLResponse = response
            
            let exp = expectation(description: "Saving Record")
            netWorkClient.post(url) { data, urlResponse, err in
                if let urlResponse = urlResponse {
                    self.viewController.handleResponse(dataResponse: data, urlResponse: urlResponse, requestPayLoad: nil, method: .post, url: url, completion: {
                        exp.fulfill()
                        
                    })
                }
                
            }
            waitForExpectations(timeout: 5)
            XCTAssertEqual(viewController.fetchSavedRecords().count, 3, "item saved successfully")
        }
        do {
            let dataTask = MockURLSessionDataTask()
            session.nextDataTask = dataTask
            session.nextError = HTTPError(rawValue: 404)
            let url = URL(string: "https://httpbin.org/delete")!
            let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
            session.nextURLResponse = response
            let exp = expectation(description: "Saving Record")
            netWorkClient.post(url) { data, urlResponse, err in
                if let urlResponse = urlResponse {
                    self.viewController.handleResponse(dataResponse: data, urlResponse: urlResponse, requestPayLoad: nil, method: .delete, url: url, completion: {
                        exp.fulfill()
                        
                    })
                }
            }
            waitForExpectations(timeout: 5)
            XCTAssertEqual(viewController.fetchSavedRecords().count, 4, "item saved successfully")
        }
    }
    
    func testSavingPutRecordData() {
        //        Deleting all Records from Core data
        viewController.deleteAllData("Record", completion: nil)

        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        session.nextData =  loadJsonData(file: "PutValidResponse")
        
        
        
        let url = URL(string: "https://httpbin.org/put")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        session.nextURLResponse = response
        
        let exp = expectation(description: "Saving Record")
        netWorkClient.post(url) { data, urlResponse, err in
            if let urlResponse = urlResponse {
                self.viewController.handleResponse(dataResponse: data, urlResponse: urlResponse, requestPayLoad: nil, method: .put, url: url, completion: {
                    exp.fulfill()
                    
                })
            }
            
        }
        waitForExpectations(timeout: 5)
        XCTAssertEqual(viewController.fetchSavedRecords().count, 1, "item saved successfully")
    }
    
    
    func testSavingPostRecordData() {
        viewController.deleteAllData("Record", completion: nil)
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        session.nextData =  loadJsonData(file: "PostValidResponse")
        let url = URL(string: "https://httpbin.org/put")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        session.nextURLResponse = response
        let exp = expectation(description: "Saving Record")
        netWorkClient.post(url) { data, urlResponse, err in
            if let urlResponse = urlResponse {
                self.viewController.handleResponse(dataResponse: data, urlResponse: urlResponse, requestPayLoad: nil, method: .post, url: url, completion: {
                    exp.fulfill()
                    
                })
            }
        }
        waitForExpectations(timeout: 5)
        XCTAssertEqual(viewController.fetchSavedRecords().count, 1, "item saved successfully")
    }
    
    func testSavingGetRecordData() {
//        Deleting all Records from Core data
        viewController.deleteAllData("Record", completion: nil)
        
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        session.nextData =  loadJsonData(file: "GetValidResponse")
        let url = URL(string: "https://httpbin.org/get")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        session.nextURLResponse = response
        
        let exp = expectation(description: "Saving Record")
        netWorkClient.post(url) { data, urlResponse, err in
            if let urlResponse = urlResponse {
                self.viewController.handleResponse(dataResponse: data, urlResponse: urlResponse, requestPayLoad: nil, method: .get, url: url, completion: {
                    exp.fulfill()
                    
                })
            }
        }
        waitForExpectations(timeout: 10)
        XCTAssertNotEqual(viewController.fetchSavedRecords().count, 0)
    }
    
    
    func testSavingDeleteRecordData() {
//        Deleting all Records from Core data
        viewController.deleteAllData("Record", completion: nil)

        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        session.nextData =  loadJsonData(file: "DeleteValidResponse")
        
        let url = URL(string: "https://httpbin.org/delete")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        session.nextURLResponse = response
        
        let exp = expectation(description: "Saving Record")
        netWorkClient.post(url) { data, urlResponse, err in
            if let urlResponse = urlResponse {
                self.viewController.handleResponse(dataResponse: data, urlResponse: urlResponse, requestPayLoad: nil, method: .delete, url: url, completion: {
                    exp.fulfill()
                    
                })
            }
            
        }
        waitForExpectations(timeout: 10)
        XCTAssertNotEqual(viewController.fetchSavedRecords().count, 0)
    }
    
//    Limitition of core data
    func testLimitionOfCoreData() {
//        Deleting all Records from Core data
        viewController.deleteAllData("Record", completion: nil)
        do {
            let exp = expectation(description: "Maximum Limit 1000")
            viewController.setLimitForContainer(numberOfRecords: 1200, completion: {
                exp.fulfill()

            })
            waitForExpectations(timeout: 10)
            XCTAssertEqual(viewController.fetchSavedRecords().count, 1000, "item saved successfully")
        }
        
        
        do {
            let exp = expectation(description: "Maximum Limit 1000 not 1001")
            viewController.setLimitForContainer(numberOfRecords: 1200, completion: {
                exp.fulfill()
            })
            waitForExpectations(timeout: 10)
            XCTAssertNotEqual(viewController.fetchSavedRecords().count, 1001,  "Couldnt save more than 1000")
        }
    }
    
    func testSaveRecrodWithValidPayloadSize() {
//        Deleting all Records from Core data
        viewController.deleteAllData("Record", completion: nil)
        var savedItemBody = ""
        let exp = expectation(description: "Valid payLoadSize")
        let url = URL(string: "https://httpbin.org/put")!
        let body = loadJsonData(file: "PutValidResponse")
        let bodyString =  String(data: body ?? Data(), encoding: .utf8) ?? ""
        viewController.save(statusCode: 200, requestpayloadBody: bodyString, method: .post, url: url, responsePayLoad: bodyString,payloadRequestSize: body?.count ?? 0, payloadResponseSize: 10 ,completion: {
            if let item = self.viewController.itemRecords.last {
                let responseObj = item.savedRequest?.allObjects.last as? Request
                let payloadbody = responseObj?.value(forKey: "body") as! String
                savedItemBody = payloadbody
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 10)
        XCTAssertEqual(savedItemBody, (bodyString))
    }
    
    func testSaveRecrodWithLargePayloadSize() {
//        Deleting all Records from Core data
        viewController.deleteAllData("Record", completion: nil)
        var savedItemBody = ""
        let exp = expectation(description: "(payload too large)")
        let url = URL(string: "https://httpbin.org/put")!
        let body = loadJsonData(file: "PutValidResponse")
        let bodyString =  String(data: body ?? Data(), encoding: .utf8) ?? ""
        viewController.save(statusCode: 200, requestpayloadBody: bodyString, method: .post, url: url, responsePayLoad: bodyString,payloadRequestSize: body?.count ?? 0, payloadResponseSize: 2 * 1058576 ,completion: {
            if let item = self.viewController.itemRecords.last {
                let responseObj = item.savedResponse?.allObjects.last as? Response
                let payloadbody = responseObj?.value(forKey: "payloadBody") as! String
                savedItemBody = payloadbody
            }
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 10)
        XCTAssertEqual(savedItemBody, ("(payload too large)"))
    }
    
    
    func testValidatePayloadSize() {
        let isValid = viewController.isValidRequestPayload(requestPayloadSize: 1024)
        XCTAssertTrue(isValid, "Size is valid")
    }
    
    func testNotValidatePayloadSize() {
        let isValid = viewController.isValidRequestPayload(requestPayloadSize: 2 * 1024 * 1024)
        XCTAssertFalse(isValid, "Size is not valid")
    }
    
    func testRemovingAllData() {
        let exp =  expectation(description: "All data has been deleted")
        viewController.deleteAllData("Record", completion: {
            exp.fulfill()
        })
        waitForExpectations(timeout: 3)
        XCTAssertEqual(viewController.fetchSavedRecords().count, 0)
    }
}

