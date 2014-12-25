//
//  SoapConnParameter.h
//  WebServcieBySoap
//
//  Created by fengs on 14-11-17.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoapConnParameter : NSObject {
    NSMutableArray *_soapConnkeys;
    NSMutableArray *_soapConnvalues;
}

- (void)setObject:(NSObject*)_value forKey:(NSString*)_key;
-(NSMutableArray*)getKeys;
-(NSObject*)getValueAtKeyIndex:(NSInteger)_keyIndex;
-(void)removeAllObjects;

@end
