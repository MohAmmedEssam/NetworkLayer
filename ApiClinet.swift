import Foundation
import Alamofire
//import SVProgressHUD

class ApiClient {
    @discardableResult
    static func CallApi<T: Codable>(route: EndPoints,
                                    completion:@escaping ((T)) -> Void) -> DataRequest {
//        SVProgressHUD.show()
        return request(route).responseJSON(completionHandler: { (response) in
//            SVProgressHUD.dismiss()
            
            switch response.result {
            case .success(let value):
                print("==>>success",value)
                do {
                    let DataResponsed = try JSONDecoder().decode(T.self, from: response.data!)
                    completion(DataResponsed)
                } catch {
                    print("print decoding error",error)
//                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
            case .failure(let error):
                print("==>>failure",error)
//                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
    ) }
    
}
