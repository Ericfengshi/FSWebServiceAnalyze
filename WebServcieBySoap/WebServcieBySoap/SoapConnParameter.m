//
//  SoapConnParameter.m
//  WebServcieBySoap
//
//  Created by fengs on 14-11-17.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "SoapConnParameter.h"

@implementation SoapConnParameter

- (id)init{
    self = [super init];
    if (self) {
        _soapConnkeys = [[NSMutableArray alloc] init];
        _soapConnvalues = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setObject:(NSObject*)_value forKey:(NSString*)_key {
    if ([_soapConnkeys containsObject:_key]) {
        NSException *ex = [NSException exceptionWithName:@"SoapConnParameter Exception"
                                                  reason:[NSString stringWithFormat:@"Parameter invaidate, key [%@] already existed!",_key]
                                                userInfo:nil];
        @throw ex;
    }
    [_soapConnkeys addObject:_key];
    [_soapConnvalues addObject:_value];
}

-(NSMutableArray*)getKeys {
    return _soapConnkeys;
}

-(NSObject*)getValueAtKeyIndex:(NSInteger)_keyIndex {
    return [_soapConnvalues objectAtIndex:_keyIndex];
}

-(void)removeAllObjects {
    [_soapConnkeys removeAllObjects];
    [_soapConnvalues removeAllObjects];
}

- (void)dealloc {
    if (_soapConnkeys) {
        [_soapConnkeys release];
        _soapConnkeys = nil;
    }
    if (_soapConnvalues) {
        [_soapConnvalues release];
        _soapConnvalues = nil;
    }
    [super dealloc];
}

@end
