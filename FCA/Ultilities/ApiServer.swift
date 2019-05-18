//import Foundation
//
//enum RequestAPIError: Int {
//    case noConnectionInternet
//    case noDefineData
//    case parseJson
//    case responseNotFound
//    case formatRequestWrong
//    case notFoundServer
//    case methodRequestNotAllow
//    case serverGetting
//    case createRequestFailed
//    case tokenExpire
//    case other
//}
//
//enum ServerAPIError: String {
//    case other = "OTHER"
//}
//
//protocol IServerAPI {
//    func getMapInfo(requestInfo: String,
//                    completion: @escaping (AnyObject) -> Void,
//                    failure: @escaping (RequestAPIError?, ServerAPIError?) -> Void)
//}
//
//class ServerAPI {
//    static let shared: ServerAPI = ServerAPI()
//    
//    // MARK: - Method request http
//    private static let MethodPost: String = "POST"
//    private static let MethodGet: String = "GET"
//    private static let MethodDelete: String = "DELETE"
//    private static let MethodPut: String = "PUT"
//    
//    private static let sampleFile: String = "https://docs.google.com/spreadsheets/d/1Xt5xm4Gt6CaZ86-0DPbwBHUCXdyo8nRwlDhGlS0HRXk/edit?usp=sharing"
//    
//    
//    static let timeOutInterval: TimeInterval = 1
//    
//    private func createRequest(methodRequest: String,
//                               apiPath: String,
//                               withParam param: NSDictionary) -> NSURLRequest? {
//        let request = NSMutableURLRequest(url: URL(string: apiPath)!,
//                                          cachePolicy: .reloadIgnoringLocalCacheData,
//                                          timeoutInterval: ServerAPI.timeOutInterval)
//        
//        switch methodRequest {
//        case ServerAPI.MethodGet, ServerAPI.MethodDelete:
//            request.httpMethod = methodRequest
//        case ServerAPI.MethodPost, ServerAPI.MethodPut:
//            let jsonData: Data!
//            do {
//                jsonData = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
//            } catch let errorParsing {
//                debugPrint("Cloud API error: parse json: \(errorParsing)")
//                return nil
//            }
//            //            request.setValue("application/json", forHTTPHeaderField: "Accept")
//            //            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            //            request.setValue("json", forHTTPHeaderField: "Data-Type")
//            //            request.setValue(String(jsonData.count), forHTTPHeaderField: "Content-Length")
//            request.httpMethod = methodRequest
//        //            request.httpBody = jsonData
//        default:
//            break
//        }
//        return request
//    }
//    
//    private func callAPIDirectly(request: NSURLRequest,
//                                 success: @escaping (_ data: AnyObject) -> Void,
//                                 failure: @escaping (_ requestError: RequestAPIError?, _ serverError: ServerAPIError?) -> Void) {
//        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, responseRequest, connectionError in
//            guard connectionError == nil else {
//                debugPrint("Cloud Downloader Error - Download File: Connection error)")
//                failure(.responseNotFound, nil)
//                return
//            }
//            
//            guard let response = responseRequest else {
//                debugPrint("Cloud Downloader Error - Download File: Not response)")
//                failure(.responseNotFound, nil)
//                return
//            }
//            
//            let httpResponse = response as! HTTPURLResponse
//            if httpResponse.statusCode != 200 && httpResponse.statusCode != 201 {
//                switch httpResponse.statusCode {
//                case 400:
//                    debugPrint("Cloud API error: format request wrong: \(String(describing: connectionError))")
//                    failure(.formatRequestWrong, nil)
//                case 401:
//                    debugPrint("Cloud API error: token expire: \(String(describing: connectionError))")
//                    failure(.tokenExpire, ServerAPIError(rawValue: "tokenExpire"))
//                case 404:
//                    debugPrint("Cloud API error: not found server: \(String(describing: connectionError))")
//                    failure(.notFoundServer, nil)
//                case 405:
//                    debugPrint("Cloud API error: method request not allow: \(String(describing: connectionError))")
//                    failure(.methodRequestNotAllow, nil)
//                case 500:
//                    debugPrint("Clound API error: server getting error: \(String(describing: connectionError))")
//                    failure(.serverGetting, nil)
//                default:
//                    debugPrint("Cloud API error: other errors: \(String(describing: connectionError))")
//                    failure(.other, nil)
//                }
//                return
//            }
//            
//            guard let responseData = data else {
//                debugPrint("Cloud API error: not define data: \(String(describing: response))")
//                failure(.noDefineData, nil)
//                return
//            }
//            
//            do {
//                let dataJSON = try JSONSerialization.jsonObject(with: responseData)
//                // debugPrint("RESPONSE = ", dataJSON)
//                if dataJSON is NSDictionary {
//                    
//                    let data = dataJSON as! NSDictionary
//                    guard let dataError = data["error_code"] else {
//                        success(data as AnyObject)
//                        return
//                    }
//                    
//                    let serverError = ServerAPIError(rawValue: dataError as! String) ?? ServerAPIError.other
//                    debugPrint("Server gettting error: \(serverError.rawValue)")
//                    failure(nil, serverError)
//                    return
//                }
//                success(dataJSON as AnyObject)
//                
//            } catch let errorParsing {
//                debugPrint("Cloud API error: parse json: \(errorParsing)")
//                failure(RequestAPIError.parseJson, nil)
//            }
//        }
//        task.resume()
//    }
//}
//
//
//extension ServerAPI: IServerAPI {
//    
//    /*
//     *  1. Call API User Info
//     *
//     *  @param {String} Account Number
//     *  @param {Void} Completion function when success
//     *  @param {Void} Failure function when failed
//     */
//    func getMapInfo(requestInfo: String,
//                    completion: @escaping (AnyObject) -> Void,
//                    failure: @escaping (RequestAPIError?, ServerAPIError?) -> Void) {
//        guard let request =
//            createRequest(methodRequest: ServerAPI.MethodGet, apiPath: ServerAPI.getMapInfo + requestInfo, withParam: [:]) else {
//                failure(.createRequestFailed, nil)
//                return
//        }
//        callAPIDirectly(request: request,
//                        success: { data in
//                            completion(data)
//        }, failure: { (requestError, serverError) in
//            failure(requestError, serverError)
//        })
//    }
//}
