//
//  SoapConn.h
//  WebServcieBySoap
//
//  Created by fengs on 14-11-17.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoapConnParameter.h"

@interface SoapConn : NSObject {
    BOOL _printLog;
}
@property BOOL printLog;
+ (SoapConn *)sharedInstance;
+ (void)finish;

/**
 * webservice 调用
 * @param soapURL:
    webservice 地址
 * @param NameSpace:
    webservice NameSpace
 * @param MethodName:
    webservice 方法名
 * @param Parameter:
    webservice 该方法下具体参数
 * @return NSString
 */
- (NSString*)WSCoreWithURL:(NSURL*)soapURL NameSpace:(NSString*)soapNameSpace
                MethodName:(NSString *)soapMethodName Parameter:(SoapConnParameter*)soapParameter;

@end
