//
//  Response.swift
//  InstabugInterview
//
//  Created by Mohamed Ziad on 29/03/2022.
//

import Foundation

struct ResponseModel {
    var statusCode: Int
    var body: String
    var method: ApiMethods
    
}

struct Post: Codable {
    let args: Args
    let data: String
    let files, form: Args
    let headers: Headers
    let postJSON, origin: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case args, data, files, form, headers
        case postJSON = "json"
        case origin, url
    }
}

// MARK: - Args
struct Args: Codable {
}

// MARK: - Headers
struct Headers: Codable {
    let accept, acceptEncoding, acceptLanguage, contentLength: String
    let host: String
    let origin, referer: String
    let secChUa, secChUaMobile, secChUaPlatform, secFetchDest: String
    let secFetchMode, secFetchSite, userAgent, xAmznTraceID: String

    enum CodingKeys: String, CodingKey {
        case accept = "Accept"
        case acceptEncoding = "Accept-Encoding"
        case acceptLanguage = "Accept-Language"
        case contentLength = "Content-Length"
        case host = "Host"
        case origin = "Origin"
        case referer = "Referer"
        case secChUa = "Sec-Ch-Ua"
        case secChUaMobile = "Sec-Ch-Ua-Mobile"
        case secChUaPlatform = "Sec-Ch-Ua-Platform"
        case secFetchDest = "Sec-Fetch-Dest"
        case secFetchMode = "Sec-Fetch-Mode"
        case secFetchSite = "Sec-Fetch-Site"
        case userAgent = "User-Agent"
        case xAmznTraceID = "X-Amzn-Trace-Id"
    }
}

