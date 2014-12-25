//
//  RemoteLogic.m
//  WebServcieBySoap
//
//  Created by fengs on 14-11-17.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "RemoteLogic.h"
#import "SoapConn.h"

#define NAMESPACE @"http://webservice-21.apphb.com/"
#define URL @"http://webservice-21.apphb.com/webservice.asmx?wsdl"

@implementation RemoteLogic
static RemoteLogic *sharedInstance = nil;

- (id)init{
    self = [super init];
    if (self) {
        _printLog = YES;
        [SoapConn sharedInstance].printLog = YES;
    }
    return self;
}

-(void)dealloc{
    if (sharedInstance) {
        [sharedInstance release];
        sharedInstance = nil;
    }
    [super dealloc];
}

+ (RemoteLogic *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

+ (void)finish {
    if (sharedInstance) {
        [sharedInstance release];
        sharedInstance = nil;
    }
}

/**
 * 获取用户名列表
 * @return NSMutableArray
 */
- (NSMutableArray*)GetUserNameList{

    NSString *MethodName = @"GetUserNameList";
    SoapConnParameter *dic = [[SoapConnParameter alloc] init];

    NSString *xml = [[SoapConn sharedInstance] WSCoreWithURL:[NSURL URLWithString:URL]
                                                   NameSpace:NAMESPACE
                                                  MethodName:MethodName
                                                   Parameter:dic];
    [dic release];
    

    NSMutableArray *retVal = [FSWebServiceAnalyze xmlToArray:xml];

    if (_printLog) {
        NSLog(@"retVal:%@",retVal);
    }
    
    return retVal;
}

/**
 * 通过name获取UserID
 * @param name
 * @return NSString
 */
- (NSString*)GeUserIDByName:(NSString*)name{
    
    NSString *retVal = nil;
    
    NSString *MethodName = @"GeUserIDByName";
    SoapConnParameter *dic = [[SoapConnParameter alloc] init];
    [dic setObject:name forKey:@"name"];
    
    
    retVal = [[SoapConn sharedInstance] WSCoreWithURL:[NSURL URLWithString:URL]
                                            NameSpace:NAMESPACE
                                           MethodName:MethodName
                                            Parameter:dic];
    
    [dic release];
    
    if (_printLog) {
        NSLog(@"retVal:%@",retVal); 
    }
    
    return retVal;
}

/**
 * 获取用户列表
 * @return NSMutableArray List<User>
 */
-(NSMutableArray*)GetUserListByXML{

    NSString *MethodName = @"GetUserListByXML";
    SoapConnParameter *dic = [[[SoapConnParameter alloc] init] autorelease];
    
    
    NSString *xml = [[SoapConn sharedInstance] WSCoreWithURL:[NSURL URLWithString:URL]
                                                   NameSpace:NAMESPACE
                                                  MethodName:MethodName
                                                   Parameter:dic];
    //xml = [NSString toXMLNodeUpper:xml];// 将xml节点转成大写

    NSMutableArray *retVal = [FSWebServiceAnalyze xmlToArray:xml class:User.class rowRootName:@"row"];
    
    if (_printLog) {
        NSLog(@"retVal:%@",xml);
    }
    return retVal;
}

/**
 * 获取用户列表
 * @return NSMutableArray  List<User>
 */
-(NSMutableArray*)GetUserListByJson{
    NSString *MethodName = @"GetUserListByJson";
    SoapConnParameter *dic = [[[SoapConnParameter alloc] init] autorelease];
    
    
    NSString *xml = [[SoapConn sharedInstance] WSCoreWithURL:[NSURL URLWithString:URL]
                                                   NameSpace:NAMESPACE
                                                  MethodName:MethodName
                                                   Parameter:dic];
    //xml = [NSString toXMLNodeUpper:xml];// 将xml节点转成大写
    
    NSMutableArray *retVal = [FSWebServiceAnalyze jsonToArray:xml class:User.class];
    
    if (_printLog) {
        NSLog(@"retVal:%@",xml);
    }
    return retVal;
}

@end
