//
//  FSXmlJsonAnalyze.m
//  https://github.com/Ericfengshi/FSXmlJsonAnalyze
//
//  Created by fengs on 14-11-19.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "FSXmlJsonAnalyze.h"
#import <objc/runtime.h>
#import "GDataXMLNode.h"

@implementation FSXmlJsonAnalyze

#pragma mark -
#pragma mark - 将xml(数组)转换成NSMutableArray (List<String>)
/**
 * 将xml(数组)转换成NSMutableArray
 * @param xml:
    <string>fs</string>
    <string>fs</string>
    ...
 * @return NSMutableArray (List<String>)
 */
+(NSMutableArray*)xmlToArray:(NSString*)xml{
    
    NSMutableArray *retVal = [[[NSMutableArray alloc] init] autorelease];
    xml = [NSString stringWithFormat:@"<data>%@</data>",xml];
    GDataXMLDocument *root = [[[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:nil] autorelease];
    GDataXMLElement *rootEle = [root rootElement];
    for (int i=0; i <[rootEle childCount]; i++) {
        GDataXMLNode *item = [rootEle childAtIndex:i];
        [retVal addObject:item.stringValue];
    }
    return retVal;
}

#pragma mark -
#pragma mark - 将标准的xml(实体)转换成NSMutableArray (List<class>)
/**
 * 将标准的xml(实体)转换成NSMutableArray
 * @param xml:
    <data xmlns="">
    <row><UserID>ff0f0704</UserID><UserName>fs</UserName></row>
    <row><UserID>ff0f0704</UserID><UserName>fs</UserName></row>
    ......
    </data>
 * @param class:
    User @property userName,userID;
 * @param rowRootName:
    row
 * @return NSMutableArray (List<User>)
 */
+(NSMutableArray*)xmlToArray:(NSString*)xml class:(Class)class rowRootName:rowRootName{
    
    NSMutableArray *retVal = [[[NSMutableArray alloc] init] autorelease];
    GDataXMLDocument *root = [[[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:nil] autorelease];
    GDataXMLElement *rootEle = [root rootElement];
    NSArray *rows = [rootEle elementsForName:rowRootName];
    for (GDataXMLElement *row in rows) {
        id object = [[class alloc] init];
        [retVal addObject:[self initWithXMLString:row.XMLString object:object]];
        [object release];
    }
    return retVal;
}

/**
 * 将传递过来的实体赋值
 * @param xml(忽略实体属性大小写差异):
    <row><UserID>ff0f0704</UserID><UserName>fs</UserName></row>
 * @param object:
    user @property userName,userID;
 * @return user
 */
+(id)initWithXMLString:(NSString*)xml object:(id)object{
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        NSString *value = [self setXMLProperty:xml propertyName:propertyName];
        [object setValue:value forKey:propertyName];
    }
    free(properties);
    
    return object;
}

/**
 * 通过正则将传递过来的实体赋值
 * @param value(忽略实体属性大小写差异):
    <row><UserID>ff0f0704</UserID><UserName>fs</UserName></row>
 * @param propertyName:
    userID
 * @return NSString
    ff0f0704
 */
+(NSString*)setXMLProperty:(NSString*)value propertyName:(NSString*)propertyName {
    
    NSString *retVal = @"";
    NSString *patternString = [NSString stringWithFormat:@"(?<=<%@>)(.*)(?=</%@>)",propertyName,propertyName];
    // CaseInsensitive:不区分大小写比较
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:patternString options:NSRegularExpressionCaseInsensitive error:nil];
    if (regex) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:value options:NSCaseInsensitiveSearch range:NSMakeRange(0, [value length])];
        if (firstMatch) {
            retVal = [value substringWithRange:firstMatch.range];
        }
    }
    return retVal;
}

#pragma mark -
#pragma mark - 将标准的Json(实体)转换成NSMutableArray (List<class>)
/**
 * 将标准的Json(实体)转换成NSMutableArray
 * @param json:
    [{"UserID":"ff0f0704","UserName":"fs"},
    {"UserID":"ff0f0704","UserName":"fs"},...]
 * @param class:
    User @property userName,userID;
 * @return NSMutableArray (List<User>)
 */
+(NSMutableArray*)jsonToArray:(NSString*)json class:(Class)class {
    
    if (!json) {
        return nil;
    }
    
    NSMutableArray *retVal = [[[NSMutableArray alloc] init] autorelease];
    NSString *patternString = @"\\{.*?\\}";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:patternString options:0 error:nil];
    if (regex) {
        NSArray *match = [regex matchesInString:json options:0 range:NSMakeRange(0, [json length])];
        if (match) {
            for (NSTextCheckingResult *result in match) {
                NSString *jsonRow = [json substringWithRange:result.range];
                id object = [[class alloc] init];
                [retVal addObject:[self initWithJsonString:jsonRow object:object]];
                [object release];
            }
        }
    }
    return retVal;
}

/**
 * 将传递过来的实体赋值
 * @param json(忽略实体大小写差异):
    {"UserID":"ff0f0704","UserName":"fs"}
 * @param object:
    user @property userName,userID;
 * @return user
 */
+(id)initWithJsonString:(NSString*)json object:(id)object{
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        NSString *value = [self setJsonProperty:json propertyName:propertyName];
        [object setValue:value forKey:propertyName];
    }
    free(properties);
    
    return object;
}

/**
 * 通过正则将传递过来的实体赋值
 * @param value(忽略实体大小写差异):
    {"UserID":"ff0f0704","UserName":"fs"}
 * @param propertyName:
    userID
 * @return NSString
    ff0f0704
 */
+(NSString*)setJsonProperty:(NSString*)value propertyName:(NSString*)propertyName {
    
    NSString *retVal = @"";
    NSString *patternString = [NSString stringWithFormat:@"(?<=\"%@\":\")[^\",]*",propertyName];
    // CaseInsensitive:不区分大小写比较
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:patternString options:NSRegularExpressionCaseInsensitive error:nil];
    if (regex) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:value options:NSCaseInsensitiveSearch range:NSMakeRange(0, [value length])];
        if (firstMatch) {
            retVal = [value substringWithRange:firstMatch.range];
        }
    }
    return retVal;
}

@end
