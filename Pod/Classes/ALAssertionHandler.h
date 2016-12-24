//
//  ALAssertionHandler.h
//  Pods
//
//  Created by alex on 2016/11/18.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const ALAssertionHandlerKey;

#define ALAssertionHandlerKey(handler) [NSString stringWithFormat:@"ALAssertionHandlerKey_%p",handler]

/**
 ALAssert包装NSAssert宏,可以方便地实现检查并设置当前线程的断言处理类为自定义的ALAssertionHandler
 */
#if !defined(NS_BLOCK_ASSERTIONS) //NS_BLOCK_ASSERTIONS表示是否开启断言
    #if !defined(_ALAssertBody)

    //ALAssertThread 设置当前线程断言处理类为ALAssertionHandler
    #define ALAssertThread	\
    do {	\
        NSAssertionHandler *handler = [[[NSThread currentThread] threadDictionary] valueForKey:NSAssertionHandlerKey]; \
        if (![handler isKindOfClass:[ALAssertionHandler class]]) {    \
            ALAssertionHandler *myHandler = [[ALAssertionHandler alloc] init]; \
            myHandler.origHandler =handler;\
            myHandler.callStackStr = [NSString stringWithFormat:@"%@",[NSThread callStackSymbols]];\
            [[UIApplication sharedApplication].exDict setValue:myHandler forKey:ALAssertionHandlerKey(myHandler)];\
            [[[NSThread currentThread] threadDictionary] setValue:myHandler forKey:NSAssertionHandlerKey]; \
            NSLog(@"[NSThread currentThread] set ALAssertionHandler: %@,origHandler:%@",myHandler,myHandler.origHandler);  \
        }   \
    } while(0)

    //ALAssertThreadReset 重置当前线程断言处理类为原NSAssertionHandler
    #define ALAssertThreadReset	\
    do {	\
        NSAssertionHandler *handler = [[[NSThread currentThread] threadDictionary] valueForKey:NSAssertionHandlerKey]; \
        if ([handler isKindOfClass:[ALAssertionHandler class]]) {    \
            ALAssertionHandler *myHandler = (ALAssertionHandler*)handler; \
            NSLog(@"[NSThread currentThread] reset AssertionHandler:%@",myHandler.origHandler);  \
            [[[NSThread currentThread] threadDictionary] setValue:myHandler.origHandler forKey:NSAssertionHandlerKey]; \
        }   \
    } while(0)

    /**
     ALParameterAssert,只有条件表达式配置默认文案
     
     @param condition 条件表达式
     */
    #define ALParameterAssert(condition)  \
    do {       \
        ALAssertThread;            \
        NSAssert((condition), @"Invalid parameter not satisfying. condition: %@", @#condition,(nil));\
        ALAssertThreadReset;\
    } while(0)

    /**
     ALAssert, ALAssertThread/ALAssertThreadReset不会影响线程已有断言

     @param condition 条件表达式
     @param desc      描述文案
     @param ...       desc可变参数
     */
    #define ALAssert(condition, desc, ...)	\
    do {                          \
        ALAssertThread;            \
        NSAssert(condition,desc); \
        ALAssertThreadReset;\
    } while(0)

    /**
     ALAssert1

     @param condition 条件表达式
     @param desc      描述文案
     @param arg1      formart第一个参数
     */
    #define ALAssert1(condition, desc, arg1)  \
    do {   \
        ALAssertThread;            \
        NSAssert((condition), (desc), (arg1), (nil)); \
        ALAssertThreadReset;\
    } while(0)

    /**
     ALAssert2
     
     @param condition 条件表达式
     @param desc      描述文案
     @param arg1      第1个formart参数
     @param arg2      第2个formart参数
     */
    #define ALAssert2(condition, desc, arg1, arg2)  \
    do {       \
        ALAssertThread;            \
        NSAssert((condition), (desc), (arg1), (arg2), (nil)); \
        ALAssertThreadReset;\
    } while(0)

    #endif //_ALAssertBody defined
#else // NS_BLOCK_ASSERTIONS defined, Release模式下断言关闭则定义空宏
    #if !defined(_ALAssertBody)
    //ALAssertThread
    #define ALAssertThread	do {} while(0)

    //ALAssert
    #define ALAssert(condition, desc, ...)	do {} while(0)

    //ALAssert1
    #define ALAssert1(condition, desc, arg1)  do {} while(0)

    //ALAssert2
    #define ALAssert2(condition, desc, arg1, arg2)  do {} while(0)

    //ALParameterAssert
    #define ALParameterAssert(condition)  do {} while(0)

    #endif
#endif // NS_BLOCK_ASSERTIONS defined


@interface UIApplication (al_exDict)

/**
 扩展数据
 */
@property (nonatomic, strong) NSMutableDictionary *exDict;


@end


/**
 自定义断言处理类
 ALAssert宏等价于如下代码,封装简化了NSAssert调用:
    NSAssertionHandler *myHandler = [[ALAssertionHandler alloc] init];
    [[[NSThread currentThread] threadDictionary] setValue:myHandler forKey:NSAssertionHandlerKey];
    NSAssert(a == correctValue, @"a must equal to 5");

 */
@interface ALAssertionHandler : NSAssertionHandler

/**
 线程原有AssertionHandler
 */
@property (nonatomic, strong) NSAssertionHandler *origHandler;


/**
 当前堆栈信息
 */
@property (nonatomic, copy) NSString *callStackStr;


@property (nonatomic, weak) UIAlertView *alertView;




@end
