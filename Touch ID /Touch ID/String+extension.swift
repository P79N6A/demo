//
//  String+extension.swift
//  Touch ID
//
//  Created by pkss on 2017/5/25.
//  Copyright © 2017年 J. All rights reserved.
//


import Foundation



extension String {
    // **********************************************************************************
    // MARK: - < MD5 >
    ///
    func md5String() -> String{
        let cStr = self.cString(using: .utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
}
