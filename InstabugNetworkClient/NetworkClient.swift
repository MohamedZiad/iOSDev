//
//  NetworkClient.swift
//  InstabugNetworkClient
//
//  Created by Yousef Hamza on 1/13/21.
//

import Foundation
import UIKit

public class NetworkClient {
    private (set) var resumeWasCalled = false
    public static var shared = NetworkClient()
    
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
          self.session = session
      }

    func resume() {
           resumeWasCalled = true
       }

    // MARK: Network requests
    public func get(_ url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        executeRequest(url, method: "GET", payload: nil, completionHandler: completionHandler)
    }

    public func post(_ url: URL, payload: Data?=nil, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        executeRequest(url, method: "POST", payload: payload, completionHandler: completionHandler)
    }

    public func put(_ url: URL, payload: Data?=nil, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        executeRequest(url, method: "PUT", payload: payload, completionHandler: completionHandler)
    }

    public func delete(_ url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        executeRequest(url, method: "DELETE", payload: nil, completionHandler: completionHandler)
    }

    func executeRequest(_ url: URL, method: String, payload: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.httpBody = payload
        
        session.dataTaskWithURL(urlRequest) { data, response, error in
            if let error = error {
                      print("Request error: ", error)
                  }
            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                print(data)
                
            } else {
                print("Error")
            }
            
        DispatchQueue.main.async {
            completionHandler(data, response, error)
        }

        }.resume()
    }

    // MARK: Network recording
    #warning("Replace Any with an appropriate type")
    public func allNetworkRequests() -> Any {
        fatalError("Not implemented")
    }
}

