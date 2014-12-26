//
//  FSXmlJsonAnalyze.h
//  https://github.com/Ericfengshi/FSXmlJsonAnalyze
//
//  Created by fengs on 14-11-19.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSXmlJsonAnalyze : NSObject
#pragma mark -
#pragma mark - 将xml(数组)转换成NSMutableArray (List<String>)
/**
 * 将xml(数组)转换成NSMutableArray
 * @param xml
    <string>fs</string>
    <string>fs</string>
    ...
 * @return NSMutableArray (List<String>)
 */
+(NSMutableArray*)xmlToArray:(NSString*)xml;

#pragma mark -
#pragma mark - 将标准的xml(实体)转换成NSMutableArray (List<class>)
/**
 * 把标准的xml(实体)转换成NSMutableArray
 * @param xml:
    <data xmlns="">
    <row><UserID>ff0f0704</UserID><UserName>fs</UserName></row>
    <row><UserID>ff0f0704</UserID><UserName>fs</UserName></row>
    ......
    </data>
 * @param class:
    User
 * @param rowRootName:
    row
 * @return NSMutableArray (List<class>)
 */
+(NSMutableArray*)xmlToArray:(NSString*)xml class:(Class)class rowRootName:rowRootName;

#pragma mark -
#pragma mark - 将标准的Json(实体)转换成NSMutableArray (List<class>)
/**
 * 把标准的xml(实体)转换成NSMutableArray
 * @param xml:
    [{"UserID":"ff0f0704","UserName":"fs"},
    {"UserID":"ff0f0704","UserName":"fs"},...]
 * @param class:
    User
 * @return NSMutableArray (List<class>)
 */
+(NSMutableArray*)jsonToArray:(NSString*)json class:(Class)class;
@end
