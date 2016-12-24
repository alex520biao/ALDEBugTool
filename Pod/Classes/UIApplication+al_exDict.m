//
//  UIApplication+al_exDict.m
//  Pods
//
//  Created by alex on 2016/12/23.
//
//

#import "UIApplication+al_exDict.h"
#import <objc/runtime.h>

@implementation UIApplication (al_exDict)

@dynamic exDict;
- (NSMutableDictionary *)exDict{
    id exDict = objc_getAssociatedObject(self, @selector(exDict));
    if (!exDict) {
        exDict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(exDict), exDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return exDict;
}

-(void)setExDict:(NSMutableDictionary *)exDict{
    [self willChangeValueForKey:NSStringFromSelector(@selector(exDict))]; // KVO
    objc_setAssociatedObject(self, @selector(exDict), exDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(exDict))]; // KVO
}

@end
