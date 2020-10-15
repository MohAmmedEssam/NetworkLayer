import Foundation
import Alamofire
protocol APIConfigurations: URLRequestConvertible {
    var method: HTTPMethod {get}
    var path: String {get}
    var parameters: Parameters? {get}
}

struct Constants {
    static let baseUrl = "Write your base url here"
    static let lang = String(Locale.preferredLanguages[0].prefix(2))
}
enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case contentType = "application/json"

}
