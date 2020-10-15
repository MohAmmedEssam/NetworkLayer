//
//  APIConfigurations.swift
//  NY_Times
//
//  Created by Mohammed Essam on 6/14/20.
//  Copyright © 2020 ElhayesGroup. All rights reserved.
//
import Foundation

//-----------------------------------------------------------------------
//  MARK: - Enum
//-----------------------------------------------------------------------
enum RequestType {
    case json
    case formData
    case formEncoded
}

enum RequestMethod:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

//-----------------------------------------------------------------------
//  MARK: - Structs
//-----------------------------------------------------------------------
/*
 *-------------------
 * >> APIConfig
 *-------------------
 * baseURL: API base URL
 * timeout: request timeout
 * token: API OAuth token
 * headers: adding more header fields
 *
 * >>>> Testing attrs needs to be false to load REST API data
 */
struct ApiConfig {
    var baseURL: String = ApiConstants.baseUrl
    var token: String = ""
    var headers: Dictionary<String, String> = [:]
}

/*
 *-------------------
 * >> UploadFile
 *-------------------
 * data: binary
 * name: filename
 * type: extension (png, jpeg, etc)
 */
struct UploadFile {
    var data: Data
    var name: String
    var type: String
}

/*
*-------------------
* >> ApiConstants
*-------------------
*/
struct ApiConstants {

    //eng.mohammedessam@gmail.com
    //ZW56q.LyUjU6*9Q
    static let baseUrl = "https://api.nytimes.com/svc/"
    static let apiKey = "CqM7B7cpRU6GtV2iI8mMD1Y8885RCkQ4"

}

