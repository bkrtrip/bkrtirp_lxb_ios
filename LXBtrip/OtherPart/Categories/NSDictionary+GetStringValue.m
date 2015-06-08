//
//  NSDictionary+GetStringValue.m
//  lxb
//
//  Created by Sam on 3/19/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import "NSDictionary+GetStringValue.h"

@implementation NSDictionary (NSDictionary_GetStringValue)

- (NSString *)stringValueByKey:(NSString *)key
{
    id object = [self objectForKey:key];
    
    if (object && ![object isKindOfClass:[NSNull class]])
    {
        return [NSString stringWithFormat:@"%@", object];
    }
    
    return @"";
}


@end
