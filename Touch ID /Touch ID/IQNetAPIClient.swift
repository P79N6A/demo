//
//  IQNetAPIClient.swift
//  Touch ID
//
//  Created by pkss on 2017/5/25.
//  Copyright © 2017年 J. All rights reserved.
//

import UIKit

let IQ_BASE_API = "https://api.ishare.bthost.top/"
let salt = "mnbvcxz1234567890"


class IQNetAPIClient: NSObject {

    /// 远程服务器时间差
    fileprivate static var remoteTime:Int = 0
    /// 访问接口的AppKey
    fileprivate static var sign:String{
        
        get{
            
            let newDate = Date(timeIntervalSinceNow: TimeInterval(remoteTime))
            let fmt = DateFormatter()
            fmt.dateFormat = "mm"
            let m = fmt.string(from: newDate)
            fmt.dateFormat = "ss"
            let s = fmt.string(from: newDate)
            
            let timeStr = ( Int(m)! * 60 + Int(s)!)/10
            
            let newDateStr = salt + "-"  + IQNetWorking.userAgent + "-" + String( timeStr )
            return newDateStr.md5String()
        }
        
    }
    
    // **********************************************************************************
    // MARK: - < 通用请求接口 >
    ///
    open  static func requestJson(
                                  url:String = IQ_BASE_API,
                                  method: IQMethod ,
                                  parameters: [String: Any]? = nil,
                                  succeed: @escaping ([String: Any]) -> Void,
                                  failure: @escaping (NSError) -> Void){

        IQNetWorking.requestJson(url: url, method: method , parameters: parameters ,headers:["User-ID":sign], succeed: { (obj:[String : Any],header:HTTPURLResponse) in
            
            guard let code = obj["code"] as! Int? else{
                
                failure(NSError(domain: "服务器code异常,请联系技术人员", code: NSURLErrorUnknown, userInfo: nil))
                return;
            }
            
            
            if code == 200{// 非法访问
                guard let remote = header.allHeaderFields["time-stamp"] as! String? else{
                    failure(NSError(domain: "服务器time-stamp异常,请联系技术人员", code: NSURLErrorUnknown, userInfo: nil))
                    return
                }
                
                let remoteTimeInt = Int(remote)!
                let locolTimeInt = Int((Date().timeIntervalSince1970))
            
                remoteTime =  remoteTimeInt - locolTimeInt
                
                requestAgain(url: url , method: method,parameters: parameters , succeed: succeed, failure: failure)
                return
            }
            
            succeed(obj)
        }) { (error:NSError) in
            failure(error)
        }
        
    }
    
    
    
 }


extension IQNetAPIClient{
   
    // **********************************************************************************
    // MARK: - < appkey失效后访问接口 >
    ///
    fileprivate  static func requestAgain(
        url:String = IQ_BASE_API,
        method: IQMethod ,
        parameters: [String: Any]? = nil,
        succeed: @escaping ([String: Any]) -> Void,
        failure: @escaping (NSError) -> Void){
        
        IQNetWorking.requestJson(url: url, method: method,parameters:parameters,headers:["User-ID":sign], succeed: { (obj:[String : Any],header:HTTPURLResponse) in
            
            guard let code = obj["code"] as! Int? else{
                
                failure(NSError(domain: "服务器code异常,请联系技术人员", code: NSURLErrorUnknown, userInfo: nil))
                return;
            }
            
            if code == 200{// 非法访问
                guard let remote = header.allHeaderFields["time-stamp"] as! String? else{
                    failure(NSError(domain: "服务器time-stamp异常,请联系技术人员", code: NSURLErrorUnknown, userInfo: nil))
                    return
                }
                
                let remoteTimeInt = Int(remote)!
                let locolTimeInt = Int((Date().timeIntervalSince1970))
                
                remoteTime =  remoteTimeInt - locolTimeInt
                failure(NSError(domain: "AppKey有问题,请稍后再加载", code: NSURLErrorUnknown, userInfo: nil))

                return;
            }
    
            
            succeed(obj)
        }) { (error:NSError) in
            failure(error)
        }
        
    }

}


