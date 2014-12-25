//
//  SoapConn.h
//  NSString+XMLExtensions
//
//  Created by fengs on 14-11-17.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString(XMLExtensions) 

+ (NSString *)encodeXMLCharactersIn:(NSString *)source;
+ (NSString *)decodeXMLCharactersIn:(NSString *)source;
+ (NSString *)toXMLNodeUpper:(NSString*)xml;
@end
