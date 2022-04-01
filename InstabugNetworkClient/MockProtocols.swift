//
//  MockProtocols.swift
//  InstabugNetworkClient
//
//  Created by Mohamed Ziad on 31/03/2022.
//

import Foundation
typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTaskWithURL(_ urlRequest: URLRequest, completion: @escaping DataTaskResult)
      -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTaskWithURL(_ urlRequest: URLRequest, completion: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
//        dataTask(with: url, completionHandler: completion) as URLSessionDataTaskProtocol
        dataTask(with: urlRequest, completionHandler: completion) as URLSessionDataTaskProtocol
    }
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }


class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false

    func resume() {
        resumeWasCalled = true
    }
}

