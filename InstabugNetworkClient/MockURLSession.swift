//
//  MockURLSession.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Ziad on 01/04/2022.
//

import UIKit
class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lasturlRequest: URLRequest?
    var nextData: Data?
    var nextError: Error?
    var nextURLResponse: URLResponse?

    func dataTaskWithURL(_ urlRequest: URLRequest, completion: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lasturlRequest = urlRequest
        completion(nextData, nextURLResponse, nextError)
        return nextDataTask
    }
}
