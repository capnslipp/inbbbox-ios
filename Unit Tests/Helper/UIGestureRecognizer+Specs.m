//
// Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
//

#import "UIGestureRecognizer+Specs.h"
#import <objc/runtime.h>

@interface UIGestureRecognizerTarget : NSObject
- (SEL)_action;
@end

@implementation UIGestureRecognizer (Specs)

- (void)specRecognizeWithGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    Class targetActionPairClass = NSClassFromString(@"UIGestureRecognizerTarget");
    Ivar targetIvar = class_getInstanceVariable(targetActionPairClass, "_target");
    Ivar actionIvar = class_getInstanceVariable(targetActionPairClass, "_action");

    NSArray *targetsAndActions = [self valueForKey:@"_targets"];
    [targetsAndActions enumerateObjectsUsingBlock:^(UIGestureRecognizerTarget *pair, NSUInteger idx, BOOL *stop) {
        id target = object_getIvar(pair, targetIvar);
        SEL action = (__bridge void *) object_getIvar(pair, actionIvar);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:action withObject:gestureRecognizer];
#pragma clang diagnostic pop
    }];
}

@end
