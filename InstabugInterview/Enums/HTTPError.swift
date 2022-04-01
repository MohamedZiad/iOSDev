//
//  HTTPError.swift
//  InstabugInterview
//
//  Created by Mohamed Ziad on 30/03/2022.
//

import Foundation

enum HTTPError : Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500
    
    
    
}

extension HTTPError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .badRequest:
      return "Bad Request"
    case .unauthorized:
      return "Unauthorized"
    case .forbidden:
      return "Forbidden"
    case .notFound:
      return "Not Found"
    case .internalServerError:
      return "Internal Server Error"
 
    }
  }
}
