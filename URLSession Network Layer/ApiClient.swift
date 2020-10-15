//
//  ApiClient.swift
//  NY_Times
//
//  Created by Mohammed Essam on 6/14/20.
//  Copyright © 2020 ElhayesGroup. All rights reserved.
//


import Foundation
//-----------------------------------------------------------------------
//  MARK: - ApiClient
//-----------------------------------------------------------------------
class ApiClient {
    
    var config = ApiConfig()
    
    init(with config: ApiConfig) {
        self.config = config
    }
    
    func request<T:Decodable>(method: RequestMethod,
                              type: RequestType = .json,
                              endpoint: EndPoints,
                              query: Dictionary<String, Any> = [:],
                              parameters: Dictionary<String, Any> = [:],
                              files: Array<UploadFile> = [],
                              authenticated: Bool = false,
                              completion: @escaping (T?, Error?,Int?) -> Void) {
        
        var serverURL: String = config.baseURL + endpoint.rawValue
        
        let request = NSMutableURLRequest()
        request.httpMethod = method.rawValue
        request.timeoutInterval = 10
        request.cachePolicy = .useProtocolCachePolicy
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        
        for key in config.headers.keys {
            request.setValue(config.headers[key], forHTTPHeaderField: key)
        }
        
        switch type {
        case .json:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if !parameters.isEmpty{
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            }
            if !query.isEmpty{
                serverURL += query.buildQueryString(encoded: true)
            }
            break
            
        case .formData:
            self.formData(url: serverURL,
                          parameters: parameters,
                          files: files,
                          authenticated: authenticated,
                          completion:completion)
            return
            
        case .formEncoded:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            if !query.isEmpty{serverURL += query.buildQueryString(encoded: true)}
            break
        }
        
        if !config.token.isEmpty && authenticated {
            request.setValue("Bearer " + config.token, forHTTPHeaderField: "Authorization")
        }
        
        request.url = URL(string: serverURL)
        
        print("--------------------------------------------------------")
        print("Parameters: \(parameters)")
        print("Request URL: \(request.url!.absoluteString)")
        print("--------------------------------------------------------")
        
        
        //---------------------------------------------------------
        //  Load API
        //---------------------------------------------------------
        let task = URLSession.shared.dataTask(with: request as URLRequest,
                                    completionHandler: {data, response, error -> Void in
                                        
                                        let responseCode = response?.getStatusCode() ?? 0
                                        
                                        guard error == nil else {
                                            DispatchQueue.main.async { completion(nil,error,responseCode) }
                                            return
                                        }
                                        
                                        if let responseData = data, responseData.count != 0 {
                                            
                                            if let responseString = String(data: responseData, encoding: .utf8) {
                                                print("Response: \(responseString)")
                                            }
                                            
                                            
                                            do {
                                                let parse = try JSONDecoder().decode(T.self, from: responseData)
                                                DispatchQueue.main.async { completion(parse, nil,responseCode) }
                                            }catch{
                                                print("-> Entity: " + String(describing: T.self))
                                                print("-> Error: " + String(describing: error))
                                            }
                                        }else{
                                            DispatchQueue.main.async { completion(nil,nil,responseCode) }
                                        }
        })
        
        task.resume()
    }
    
    private func formData<T:Decodable>(url: String,
                                       parameters: Dictionary<String, Any> = [:],
                                       files: Array<UploadFile>,
                                       authenticated: Bool = false,
                                       completion: @escaping (T?, Error?,Int?) -> Void) {
        
        print("--------------------------------------------------------")
        print("Parameters: \(parameters)")
        print("Request URL: \(url)")
        print("--------------------------------------------------------")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let boundaryPrefix = "\r\n--\(boundary)\r\n"
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
            body.appendString("--".appending(boundary.appending("--")))
        }
        
        for file in files {
            
            let filename = "\(file.name).\(file.type)"
            
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: image/\(file.type)\r\n\r\n")
            body.append(file.data)
            body.appendString("\r\n")
            body.appendString("--".appending(boundary.appending("--")))
        }
        
        let data = body as Data
        
        session.uploadTask(with: urlRequest,
                           from: data,
                           completionHandler: { data, response, error in
                            
                            let responseCode = response?.getStatusCode() ?? 0
                            
                            guard error == nil else {
                                DispatchQueue.main.async { completion(nil,error,responseCode) }
                                return
                            }
                            if let responseData = data, responseData.count != 0 {
                                
                                if let responseString = String(data: responseData, encoding: .utf8) {
                                    print("Response: \(responseString)")
                                }
                                
                                
                                do {
                                    let parse = try JSONDecoder().decode(T.self, from: responseData)
                                    DispatchQueue.main.async { completion(parse, nil,responseCode) }
                                }catch{
                                    print("-> Entity: " + String(describing: T.self))
                                    print("-> Error: " + String(describing: error))
                                }
                            }else{
                                DispatchQueue.main.async { completion(nil,nil,responseCode) }
                            }
        }).resume()
    }
    
}
