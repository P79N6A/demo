//
//  NSError+Message.m
//  Hello
//
//  Created by FEIWU888 on 2017/10/11.
//  Copyright © 2017年 广州飞屋网络. All rights reserved.
//

#import "NSError+Message.h"

@implementation NSError (Message)

- (NSError *)getError:(NSError *)error
{
    switch (error.code) {
        case NSURLErrorDownloadDecodingFailedMidStream:
            return [NSError errorWithDomain:@"下载解码失败" code:NSURLErrorDownloadDecodingFailedMidStream userInfo:nil];
            break;
        case NSURLErrorBackgroundSessionWasDisconnected:
            return [NSError errorWithDomain:@"后台会话已断开连接" code:NSURLErrorBackgroundSessionWasDisconnected userInfo:nil];
            break;
        case NSURLErrorBackgroundSessionInUseByAnotherProcess:
            return [NSError errorWithDomain:@"后台会话被另一个进程使用" code:NSURLErrorBackgroundSessionInUseByAnotherProcess userInfo:nil];
            break;
            
        case NSURLErrorBackgroundSessionRequiresSharedContainer:
            return [NSError errorWithDomain:@"后台会话需要共享容器" code:NSURLErrorBackgroundSessionRequiresSharedContainer userInfo:nil];
            break;
        case NSURLErrorRequestBodyStreamExhausted:
            return [NSError errorWithDomain:@"请求体耗尽" code:NSURLErrorRequestBodyStreamExhausted userInfo:nil];
            break;
            
        case NSURLErrorDataNotAllowed:
            return [NSError errorWithDomain:@"数据不允许" code:NSURLErrorDataNotAllowed userInfo:nil];
            break;
        case NSURLErrorCallIsActive:
            return [NSError errorWithDomain:@"正在通话" code:NSURLErrorCallIsActive userInfo:nil];
            break;
            
        case NSURLErrorInternationalRoamingOff:
            return [NSError errorWithDomain:@"国际漫游关" code:NSURLErrorInternationalRoamingOff userInfo:nil];
            break;
        case NSURLErrorDownloadDecodingFailedToComplete:
            return [NSError errorWithDomain:@"下载解码无法完成" code:NSURLErrorDownloadDecodingFailedToComplete userInfo:nil];
            break;
            ///
        case NSURLErrorSecureConnectionFailed:
            return [NSError errorWithDomain:@"安全连接失败" code:NSURLErrorSecureConnectionFailed userInfo:nil];
            break;
        case NSURLErrorServerCertificateHasBadDate:
            return [NSError errorWithDomain:@"服务器证书失效" code:NSURLErrorServerCertificateHasBadDate userInfo:nil];
            break;
            
        case NSURLErrorCannotCreateFile:
            return [NSError errorWithDomain:@"不能创建文件" code:NSURLErrorCannotCreateFile userInfo:nil];
            break;
        case NSURLErrorCannotOpenFile:
            return [NSError errorWithDomain:@"不能打开文件" code:NSURLErrorCannotOpenFile userInfo:nil];
            break;
            
        case NSURLErrorCannotCloseFile:
            return [NSError errorWithDomain:@"不能关闭文件" code:NSURLErrorCannotCloseFile userInfo:nil];
            break;
        case NSURLErrorCannotWriteToFile:
            return [NSError errorWithDomain:@"不能写文件" code:NSURLErrorCannotWriteToFile userInfo:nil];
            break;
        case NSURLErrorCannotRemoveFile:
            return [NSError errorWithDomain:@"不能删除文件" code:NSURLErrorCannotRemoveFile userInfo:nil];
            break;
        case NSURLErrorCannotMoveFile:
            return [NSError errorWithDomain:@"不能移动文件" code:NSURLErrorCannotMoveFile userInfo:nil];
            break;
            ///
        case NSURLErrorZeroByteResource:
            return [NSError errorWithDomain:@"响应内容为空" code:NSURLErrorZeroByteResource userInfo:nil];
            break;
        case NSURLErrorCannotDecodeRawData:
            return [NSError errorWithDomain:@"无法解码原始数据" code:NSURLErrorCannotDecodeRawData userInfo:nil];
            break;
        case NSURLErrorCannotLoadFromNetwork:
            return [NSError errorWithDomain:@"无法从网络加载" code:NSURLErrorCannotLoadFromNetwork userInfo:nil];
            break;
        case NSURLErrorClientCertificateRequired:
            return [NSError errorWithDomain:@"需要客户端证书" code:NSURLErrorClientCertificateRequired userInfo:nil];
            break;
        case NSURLErrorClientCertificateRejected:
            return [NSError errorWithDomain:@"服务器证书拒接" code:NSURLErrorClientCertificateRejected userInfo:nil];
            break;
        case NSURLErrorServerCertificateNotYetValid:
            return [NSError errorWithDomain:@"服务器证书尚未生效" code:NSURLErrorServerCertificateNotYetValid userInfo:nil];
            break;
        case NSURLErrorServerCertificateHasUnknownRoot:
            return [NSError errorWithDomain:@"服务器证书具有未知根" code:NSURLErrorServerCertificateHasUnknownRoot userInfo:nil];
            break;
        case NSURLErrorServerCertificateUntrusted:
            return [NSError errorWithDomain:@"服务器证书不受信任" code:NSURLErrorServerCertificateUntrusted userInfo:nil];
            break;
            ///
        case NSURLErrorFileOutsideSafeArea:
            return [NSError errorWithDomain:@"文件外部安全区域" code:NSURLErrorFileOutsideSafeArea userInfo:nil];
            break;
        case NSURLErrorDataLengthExceedsMaximum:
            return [NSError errorWithDomain:@"数据长度超过最大值" code:NSURLErrorDataLengthExceedsMaximum userInfo:nil];
            break;
        case NSURLErrorNoPermissionsToReadFile:
            return [NSError errorWithDomain:@"无权限读取文件" code:NSURLErrorNoPermissionsToReadFile userInfo:nil];
            break;
        case NSURLErrorFileIsDirectory:
            return [NSError errorWithDomain:@"文件是目录" code:NSURLErrorFileIsDirectory userInfo:nil];
            break;
        case NSURLErrorFileDoesNotExist:
            return [NSError errorWithDomain:@"文件不存在" code:NSURLErrorFileDoesNotExist userInfo:nil];
            break;
        case NSURLErrorAppTransportSecurityRequiresSecureConnection:
            return [NSError errorWithDomain:@"应用程序传输安全性需要安全连接" code:NSURLErrorAppTransportSecurityRequiresSecureConnection userInfo:nil];
            break;
        case NSURLErrorCannotParseResponse:
            return [NSError errorWithDomain:@"无法解析响应" code:NSURLErrorCannotParseResponse userInfo:nil];
            break;
        case NSURLErrorCannotDecodeContentData:
            return [NSError errorWithDomain:@"无法解析数据" code:NSURLErrorCannotDecodeContentData userInfo:nil];
            break;
            ///
        case NSURLErrorUnknown:
            return [NSError errorWithDomain:@"未知错误" code:NSURLErrorUnknown userInfo:nil];
            break;
        case NSURLErrorCancelled:
            return [NSError errorWithDomain:@"请求取消" code:NSURLErrorCancelled userInfo:nil];
            break;
        case NSURLErrorBadURL:
            return [NSError errorWithDomain:@"错误的地址" code:NSURLErrorBadURL userInfo:nil];
            break;
        case NSURLErrorTimedOut:
            return [NSError errorWithDomain:@"请求超时" code:NSURLErrorTimedOut userInfo:nil];
            break;
        case NSURLErrorUnsupportedURL:
            return [NSError errorWithDomain:@"请求地址不支持" code:NSURLErrorUnsupportedURL userInfo:nil];
            break;
        case NSURLErrorCannotFindHost:
            return [NSError errorWithDomain:@"找不到服务器" code:NSURLErrorCannotFindHost userInfo:nil];
            break;
        case NSURLErrorCannotConnectToHost:
            return [NSError errorWithDomain:@"无法连接服务器" code:NSURLErrorCannotConnectToHost userInfo:nil];
            break;
        case NSURLErrorNetworkConnectionLost:
            return [NSError errorWithDomain:@"网络连接失败" code:NSURLErrorNetworkConnectionLost userInfo:nil];
            break;
            
            ///
        case NSURLErrorDNSLookupFailed:
            return [NSError errorWithDomain:@"DNS查找失败" code:NSURLErrorDNSLookupFailed userInfo:nil];
            break;
        case NSURLErrorHTTPTooManyRedirects:
            return [NSError errorWithDomain:@"HTTP太多重定向" code:NSURLErrorHTTPTooManyRedirects userInfo:nil];
            break;
        case NSURLErrorResourceUnavailable:
            return [NSError errorWithDomain:@"资源不可用" code:NSURLErrorResourceUnavailable userInfo:nil];
            break;
        case NSURLErrorNotConnectedToInternet:
            return [NSError errorWithDomain:@"未连接到互联网" code:NSURLErrorNotConnectedToInternet userInfo:nil];
            break;
        case NSURLErrorRedirectToNonExistentLocation:
            return [NSError errorWithDomain:@"重定向到不存在的位置" code:NSURLErrorRedirectToNonExistentLocation userInfo:nil];
            break;
        case NSURLErrorBadServerResponse:
            return [NSError errorWithDomain:@"服务器出错" code:NSURLErrorBadServerResponse userInfo:nil];
            break;
        case NSURLErrorUserCancelledAuthentication:
            return [NSError errorWithDomain:@"用户取消了验证" code:NSURLErrorUserCancelledAuthentication userInfo:nil];
            break;
        case NSURLErrorUserAuthenticationRequired:
            return [NSError errorWithDomain:@"需要用户验证" code:NSURLErrorUserAuthenticationRequired userInfo:nil];
            break;
        default:
            return [NSError errorWithDomain:@"未知错误" code:999 userInfo:nil];
            //return error;
            break;
    }
    
}
@end
