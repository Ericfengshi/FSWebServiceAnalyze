//
//  RemoteLogic.h
//  WebServcieBySoap
//
//  Created by fengs on 14-11-17.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSWebServiceAnalyze.h"
#import "User.h"

@interface RemoteLogic : NSObject {
    BOOL _printLog;
}

+ (RemoteLogic *)sharedInstance;
+ (void)finish;

/**
 * 获取用户名列表
 * @return NSMutableArray
 */
- (NSMutableArray*)GetUserNameList;

/**
 * 通过name获取UserID
 * @param name
 * @return NSString
 */
- (NSString*)GeUserIDByName:(NSString*)name;

/**
 * 获取用户列表
 * @return NSMutableArray
 */
-(NSMutableArray*)GetUserListByXML;

/**
 * 获取用户列表
 * @return NSMutableArray
 */
-(NSMutableArray*)GetUserListByJson;
@end