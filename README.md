# Simple swift network layer


//Simple Model 

struct User: Codable {
    let userName, userMobile,userAddress: String? 
}

//Simple ViewModel

    class ViewModel{
    
        func tryReqWithParameters(completion: @escaping (_ user:User?)->()){
            // To encode my model to dictionary params
            let userModel = User()
            let json = try! JSONEncoder().encode(userModel)
            let params = try! JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String: Any]
        
            // make request
            ApiClient.CallApi(route: .apiWithParameters(parameters: params)) { (user:User) in
                completion(user)
            }
        }
        
        func tryReqWithoutParameters(completion: @escaping (_ user:User?)->()){
            // make request
            ApiClient.CallApi(route: .apiWithoutParameters) { (user:User) in
                completion(user)
            }
        }
        
        func tryReqWithQuery(completion: @escaping (_ user:User?)->()){
            // make request
            ApiClient.CallApi(route: .apiWithQuery(pageNumber: 1)) { (user:User) in
                completion(user)
            }
        }


    }
