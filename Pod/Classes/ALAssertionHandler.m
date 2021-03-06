//
//  ALAssertionHandler.m
//  Pods
//
//  Created by alex on 2016/11/18.
//
//

#import "ALAssertionHandler.h"
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


NSString *const ALAssertionHandlerKey = @"ALAssertionHandlerKey";

@interface ALAssertionHandler()<UIAlertViewDelegate>

@property (nonatomic, copy) NSString *reason;

@end

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
    
    self.reason = str;
    
    //调用父类方法: 抛出异常使程序crash，可变参数传递
//    [super handleFailureInMethod:selector object:object file:fileName lineNumber:line description:format];
    
    //断言弹框
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"DEBug模式异常: 仅供RD、QA等捕获偶现的数据异常"
                                                      message:[NSString stringWithFormat:@"请将此信息反馈给RD领红包！Assertion failure in -[%@ %@],%@:%li,reason:%@",NSStringFromClass([object class]), NSStringFromSelector(selector), fileName, (long)line,str]
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"反馈异常",nil];
    [alertView show];
    self.alertView = alertView;
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
#if DEBUG
    //输出到控制台
    NSLog(@"NSCAssert Failure: Function (%@) in %@#%li", functionName, fileName, (long)line);
    
    //可变参数生成NSString
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    self.reason = str;

    //调用父类方法: 抛出异常使程序crash，可变参数传递
    //    [super handleFailureInMethod:selector object:object file:fileName lineNumber:line description:format];
    
    //断言弹框
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"DEBug模式异常: 仅供RD、QA等捕获偶现的数据异常"
                                                      message:[NSString stringWithFormat:@"NSCAssert Failure: Function (%@) in %@#%li,,reason:%@", functionName, fileName, (long)line,str]
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"反馈异常",nil];
    [alertView show];
    self.alertView = alertView;
#endif
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//参数中的中文需要urlencode
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://12345@qq.com?cc=bbb@yyy.com&bcc=ccc@zzz.com&subject=主题&body=邮件内容"]];
    NSString* subject = [@"断言异常" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* body = [[NSString stringWithFormat:@"reason: %@ \n\n callStackStr: \n %@",self.reason,self.callStackStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url =[NSString stringWithFormat:@"mailto://12345@qq.com?subject=%@&body=%@",subject,body];
    if (url) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    
    //释放ALAssertionHandler对象
    [[UIApplication sharedApplication].exDict removeObjectForKey:ALAssertionHandlerKey(self)];
}

-(void)dealloc{
    NSLog(@"dealloc");
}

@end
