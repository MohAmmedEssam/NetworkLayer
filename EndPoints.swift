import Foundation
import Alamofire
enum EndPoints: APIConfigurations {
    
    case apiWithParameters(parameters: [String:Any])
        apiWithoutParameters,
        apiWithQuery(pageNumber:Int)

    var method: HTTPMethod {
        switch self {
        case .apiWithParameters:
            return .post
        default :
            return .get
        }
    }

    internal var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
           return JSONEncoding.default
        }
    }
    
    var path: String {
        switch self {
        case .apiWithParameters:
            return "api/apiWithParameters"
        case .apiWithoutParameters:
            return "api/apiWithoutParameters"
        case .apiWithQuery(_):
            return "api/apiWithQuery"
        }
    }
    var query: String {
        switch self {
        case .apiWithQuery(let queryParameter):
            return "?queryParameter=\(queryParameter)"
        default:
            return ""
            
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .apiWithParameters(let parameters):
            return parameters
        default:
            return nil
        }
    }
    var url: String? {
        return Constants.baseUrl + path + query
    }
    func asURLRequest() throws -> URLRequest {
        let finalURl = url?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        var urlRequest = URLRequest(url: URL(string: finalURl)!)
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        print("URL==>> ",urlRequest)
        // Common Headers
        if let parameters = parameters {
            do {
                print("PARMAETERS==>> ",parameters)
                urlRequest = try encoding.encode(urlRequest, with: parameters)
                let body = try JSONSerialization.data(withJSONObject: parameters)
                urlRequest.httpBody = body
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }

        // Parameters
        return  urlRequest

    }

}
