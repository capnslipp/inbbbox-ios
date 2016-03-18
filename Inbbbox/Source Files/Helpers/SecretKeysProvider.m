//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

#import <Keys/InbbboxKeys.h>
#import "SecretKeysProvider.h"


@implementation SecretKeysProvider

+ (NSString *_Nullable)secretValueForKey:(NSString *_Nonnull)key {
    InbbboxKeys *keys = [[InbbboxKeys alloc] init];
    NSString *selectorName = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                                          withString:[[key substringToIndex:1] lowercaseString]];
    SEL keySelector = NSSelectorFromString(selectorName);
    if ([keys respondsToSelector:keySelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [keys performSelector:keySelector];
#pragma clang diagnostic pop
    }
    return nil;
}

@end
