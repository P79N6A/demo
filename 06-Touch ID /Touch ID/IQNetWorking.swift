//
//  IQNetWorking.swift
//  Touch ID
//
//  Created by pkss on 2017/5/24.
//  Copyright © 2017年 J. All rights reserved.
//

import UIKit
import Alamofire

public enum IQMethod: String {
    case get     = "GET"
    case post    = "POST"
}





class IQNetWorking: NSObject {
    
    
    open static let userAgent = (SessionManager.defaultHTTPHeaders["User-Agent"]) ?? "Touch ID/1.0 (com.wammallaa; build:1; iOS 10.2.0) IQNetWorking/4.4.0"

    
    fileprivate static let sessionManager:SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15.0
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let sessionManager = Alamofire.SessionManager(configuration: configuration)

        return sessionManager
    }()

    
    open static func requestJson(url: String,
                        method: IQMethod,
                    parameters: [String: Any]? = nil,
                       headers: HTTPHeaders? = nil,
                       succeed: @escaping ([String: Any],HTTPURLResponse) -> Void,
                       failure: @escaping (NSError) -> Void

                           )
    {
        
        
        
        let httpMethod  : HTTPMethod = (method == IQMethod.get) != false ? HTTPMethod.get : HTTPMethod.post
    
        sessionManager.request(url, method: httpMethod, parameters: parameters ,headers: headers).responseJSON { response in
            if response.result.isSuccess {
                
                guard let jsonDic = response.result.value as! [String: Any]? else{
                    let error =  NSError(domain: "服务器数据结构异常,请联系技术人员", code: 200, userInfo: nil)
                    failure(error)
                    return
                }
                
                
                succeed(jsonDic,response.response!)
                
                
            }else{
                failure((response.result.error as NSError?)!)
            }
        }
    }
    
     open  static func reachabilityStatusChange(completion:@escaping (NetworkReachabilityManager.NetworkReachabilityStatus) -> Void){
        
        let manager = NetworkReachabilityManager(host: "www.baidu.com")
        
        manager?.listener = { status in
            completion(status)
        }
        
        manager?.startListening()
    }
}
