//
//  SoapConn.h
//  NSString+XMLExtensions
//
//  Created by fengs on 14-11-17.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "NSString+XMLExtensions.h"

@implementation NSString(XMLExtensions) 


+ (NSString *)encodeXMLCharactersIn:(NSString *)source {
	
	if ( ![source isKindOfClass:[NSString class]] ||!source )
		return @"";	
	
	NSString *result = [NSString stringWithString:source];
	
	if ( [result rangeOfString:@"&"].location != NSNotFound )
		result = [[result componentsSeparatedByString: @"&"] componentsJoinedByString: @"&amp;"];	
	
	if ( [result rangeOfString:@"<"].location != NSNotFound )
		result = [[result componentsSeparatedByString: @"<"] componentsJoinedByString: @"&lt;"];	
	
	if ( [result rangeOfString:@">"].location != NSNotFound )
		result = [[result componentsSeparatedByString: @">"] componentsJoinedByString: @"&gt;"];	
	
	if ( [result rangeOfString:@"\""].location != NSNotFound )
		result = [[result componentsSeparatedByString: @"\""] componentsJoinedByString: @"&quot;"];	
	
	if ( [result rangeOfString:@"'"].location != NSNotFound )
		result = [[result componentsSeparatedByString: @"'"] componentsJoinedByString: @"&apos;"];	
	
	return result;
}

+ (NSString *) decodeXMLCharactersIn:(NSString *)source {
	if ( ![source isKindOfClass:[NSString class]] ||!source )
		return @"";	

	NSString *result = [NSString stringWithString:source];
	
	if ( [result rangeOfString:@"&amp;"].location != NSNotFound )
		result = [[result componentsSeparatedByString: @"&amp;"] componentsJoinedByString: @"&"];	
	
	if ( [result rangeOfString:@"&lt;"].location != NSNotFound )
		result = [[result componentsSeparatedByString: @"&lt;"] componentsJoinedByString: @"<"];	
	
	if ( [result rangeOfString:@"&gt;"].location != NSNotFound )
		result = [[result componentsSeparatedByString: @"&gt;"] componentsJoinedByString: @">"];	
	
	if ( [result rangeOfString:@"&apos;"].location != NSNotFound ) // Split ' to \' just for sqlite effect
		result = [[result componentsSeparatedByString: @"&apos;"] componentsJoinedByString: @"\'"];
    
    if ( [result rangeOfString:@"&#39;"].location != NSNotFound ) // Split ' to \' just for sqlite effect
		result = [[result componentsSeparatedByString: @"&#39;"] componentsJoinedByString: @"\'"];
	
	if ( [result rangeOfString:@"&nbsp;"].location != NSNotFound )
		result = [[result componentsSeparatedByString: @"&nbsp;"] componentsJoinedByString: @" "];
    
    if ( [result rangeOfString:@"&quot;"].location != NSNotFound )
		result = [[result componentsSeparatedByString: @"&quot;"] componentsJoinedByString: @"\""];
	
	if ( [result rangeOfString:@"&#8220;"].location != NSNotFound )
		result = [[result componentsSeparatedByString: @"&#8220;"] componentsJoinedByString: @"\""];
	
	if ( [result rangeOfString:@"&#8221;"].location != NSNotFound )
		result = [[result componentsSeparatedByString: @"&#8221;"] componentsJoinedByString: @"\""];
	
	return result;
	
}

+ (NSString*)toXMLNodeUpper:(NSString*)xml{
    
    NSString *patternString = [NSString stringWithFormat:@"<\\/?.+?>"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:patternString options:0 error:nil];
    if (regex) {
        NSArray *match = [regex matchesInString:xml options:0 range:NSMakeRange(0, [xml length])];
        if (match) {
            for (NSTextCheckingResult *result in match) {
                NSRange resultRange = [result rangeAtIndex:0];
                NSString *retVal = [xml substringWithRange:resultRange];
                xml = [xml stringByReplacingOccurrencesOfString:retVal withString:[retVal uppercaseString]];
            }
        }
    }
    return xml;
}

@end
