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
#if DEBUG
    //输出到控制台
    NSLog(@"Assertion failure in -[%@ %@],%@:%li,reason:%@",NSStringFromClass([object class]), NSStringFromSelector(selector), fileName, (long)line,format);
    
    //可变参数生成NSString
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    //调用父类方法: 抛出异常使程序crash，可变参数传递
//    [super handleFailureInMethod:selector object:object file:fileName lineNumber:line description:format];
    
    //断言弹框
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"DEBug模式异常: 此异常弹框只会在DEBug包显示,Release正式包不会显示。仅供RD、QA及内部测试人员发现程序内部逻辑及数据异常"
                                                      message:[NSString stringWithFormat:@"Assertion failure in -[%@ %@],%@:%li,reason:%@",NSStringFromClass([object class]), NSStringFromSelector(selector), fileName, (long)line,str]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [alertView show];
#endif
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


@end
