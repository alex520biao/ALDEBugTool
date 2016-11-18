//
//  ALAssertionHandler.m
//  Pods
//
//  Created by alex on 2016/11/18.
//
//

#import "ALAssertionHandler.h"

@implementation ALAssertionHandler

/**
 重写父类方法
 处理Objective-C的断言

 @param selector
 @param object
 @param fileName
 @param line
 @param format
 */
- (void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format,...
{
    NSLog(@"NSAssert Failure: Method %@ for object %@ in %@#%li", NSStringFromSelector(selector), object, fileName, (long)line);
}

/**
 重写父类方法
处理C的断言
 @param selector
 @param object
 @param fileName
 @param line
 @param format
 */

- (void)handleFailureInFunction:(NSString *)functionName file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format,...
{
    NSLog(@"NSCAssert Failure: Function (%@) in %@#%li", functionName, fileName, (long)line);
}

//NSAssertionHandler *myHandler = [[MyAssertHandler alloc] init];
//
////给当前的线程
//[[[NSThread currentThread] threadDictionary] setValue:myHandler
//                                               forKey:NSAssertionHandlerKey];

@end
