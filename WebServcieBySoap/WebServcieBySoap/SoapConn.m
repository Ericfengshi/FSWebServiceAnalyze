//
//  SoapConn.m
//  WebServcieBySoap
//
//  Created by fengs on 14-11-17.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "SoapConn.h"
#import "GDataXMLNode.h"
#import "ASIHTTPRequest.h"
#import "NSString+XMLExtensions.h"

static SoapConn *sharedInstance = nil;
@implementation SoapConn
@synthesize printLog = _printLog;

#define WS_TIMEOUT 20.0

- (id)init{
    self = [super init];
    if (self) {
        _printLog = NO;
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

+ (SoapConn *)sharedInstance {
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

+(NSArray *)sortArray:(NSArray *)dataArray withKey:(NSString *)key ascending:(BOOL)ascending {
    if (!dataArray || !key) { return nil; }
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:key ascending:ascending] autorelease];
    NSMutableArray *array = [[[NSMutableArray alloc] initWithArray:dataArray] autorelease];
    return [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

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
- (NSString*)WSCoreWithURL:(NSURL*)soapURL NameSpace:(NSString*)soapNameSpace MethodName:(NSString *)soapMethodName Parameter:(SoapConnParameter*)soapParameter
{
    if (!soapMethodName) {
        NSException *ex = [NSException exceptionWithName:@"Error" reason:@"Function WSCoreWithMethodName Parameter Invaild!"
                                                userInfo:nil];
        @throw ex;
    }
    NSString *soapAction;
    if ([soapNameSpace hasSuffix:@"/"]) {
        soapAction = [NSString stringWithFormat:@"%@%@",soapNameSpace,soapMethodName];
    } else {
        soapAction = [NSString stringWithFormat:@"%@/%@",soapNameSpace,soapMethodName];
    }
    NSString *soapMessage = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
    "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
    "xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<!$methodName$! xmlns=\"!$nameSpace$!\">\n"
    "!$soapBody$!"
    "</!$methodName$!>\n"
    "</soap:Body>\n"
    "</soap:Envelope>";
    NSString *soapParamBody = @"";
    if (soapParameter) {
        NSArray *keys = [soapParameter getKeys];
        for (int i = 0; i< keys.count; i++) {
            NSString *paramKey = [keys objectAtIndex:i];
            NSObject *obj = [soapParameter getValueAtKeyIndex:i];
            if ([obj isKindOfClass:[NSNumber class]]) {
                soapParamBody = [soapParamBody stringByAppendingFormat:@"<%@>%@</%@>\n",
                                 paramKey,((NSNumber*)obj).stringValue,paramKey];
            } else if ([obj isKindOfClass:[NSData class]]) {
                NSString *encodingBytes = [ASIHTTPRequest base64forData:(NSData*)obj];
                soapParamBody = [soapParamBody stringByAppendingFormat:@"<%@>%@</%@>\n",
                                 paramKey,encodingBytes,paramKey];
            } else if ([obj isKindOfClass:[NSString class]]) {
                soapParamBody = [soapParamBody stringByAppendingFormat:@"<%@>%@</%@>\n",
                                 paramKey,[NSString encodeXMLCharactersIn:(NSString*)obj],paramKey];
            } else {
                soapParamBody = [soapParamBody stringByAppendingFormat:@"<%@>%@</%@>\n",
                                 paramKey,obj,paramKey];
            }
        }
    }
    soapMessage = [soapMessage stringByReplacingOccurrencesOfString:@"!$nameSpace$!" withString:soapNameSpace];
    soapMessage = [soapMessage stringByReplacingOccurrencesOfString:@"!$methodName$!" withString:soapMethodName];
    soapMessage = [soapMessage stringByReplacingOccurrencesOfString:@"!$soapBody$!" withString:soapParamBody];
    
    if (_printLog) {
        NSLog(@"Post:%@",soapMessage);
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:soapURL];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"SOAPAction" value:soapAction];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [soapMessage length]]];
    [request appendPostData:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:WS_TIMEOUT];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error && [request responseStatusCode] == 200) {
        if (_printLog) {
            NSLog(@"Response String:%@",[request responseString]);
            NSLog(@"Get HTTP Response:%d Encoding:%d Length:%d",[request responseStatusCode],[request responseEncoding],
                  [request responseData].length);
        }
        NSString *content = [[[NSString alloc] initWithData:[request responseData] encoding:[request responseEncoding]] autorelease];
        NSString *returnContent = [self getXMLResultWithMethodName:soapMethodName soapXMLString:content];
        return returnContent;
    } else {
        if (_printLog) {
            if (error) {
                NSLog(@"%s Error:%@ ",__func__, error );
            } else {
                NSLog(@"%sCode:%d Encoding:%d Desc:%@",__func__, [request responseStatusCode],
                      [request responseEncoding],[request responseString]);
            }
        }
    }
    return nil;
}

/**
 * webservice 返回
 * @param methodName:
    webservice 方法名
 * @param soapXMLString:
    soap 返回信息
 * @return NSString
 */
-(NSString*)getXMLResultWithMethodName:(NSString*)methodName soapXMLString:(NSString*)soapXMLString{
    NSError *err = nil;
    GDataXMLDocument *soapXML = [[GDataXMLDocument alloc] initWithXMLString:soapXMLString
                                                                    options:0 error:&err];
    if (!soapXML) {
        return nil;
    }
    
    if (err) {
        [soapXML release];
        NSLog(@"%s %@",__func__, err);
        return nil;
    }
    
    NSString *retVal = @"";
    GDataXMLElement *rootElement = [soapXML rootElement];
    
    NSArray *result= [rootElement children];
    while ([result count]>0) {
        NSString *nodeName = [[result objectAtIndex:0] name];
        if ([nodeName isEqualToString: [NSString stringWithFormat:@"%@Result",methodName]]) {
            GDataXMLNode *resultNode = [result objectAtIndex:0];
            if ([resultNode childCount] > 0) {
                NSString *contentStr = [NSString decodeXMLCharactersIn:[resultNode XMLString]];
                contentStr = [contentStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>",nodeName] withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, nodeName.length+2)];
                contentStr = [contentStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</%@>",nodeName] withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(contentStr.length - nodeName.length-3, nodeName.length+3)];
                retVal = contentStr;
            }
            break;
        }
        result = [[result objectAtIndex:0] children];
    }
    [soapXML release];
    return retVal;
}

@end