//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SecretKeysProvider : NSObject

+ (NSString *_Nullable)secretValueForKey:(NSString *_Nonnull)key;

@end
