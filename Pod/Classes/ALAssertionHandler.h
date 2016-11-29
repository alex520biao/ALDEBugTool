//
//  ALAssertionHandler.h
//  Pods
//
//  Created by alex on 2016/11/18.
//
//

#import <Foundation/Foundation.h>

/**
 ALAssert包装NSAssert宏,可以方便地实现检查并设置当前线程的断言处理类为自定义的ALAssertionHandler
 */
#if !defined(NS_BLOCK_ASSERTIONS) //NS_BLOCK_ASSERTIONS表示是否开启断言
    #if !defined(_ALAssertBody)

    //ALAssertThread
    #define ALAssertThread	\
    do {	\
        NSAssertionHandler *handler = [[[NSThread currentThread] threadDictionary] valueForKey:NSAssertionHandlerKey]; \
        if (![handler isKindOfClass:[ALAssertionHandler class]]) {    \
            NSAssertionHandler *myHandler = [[ALAssertionHandler alloc] init]; \
            [[[NSThread currentThread] threadDictionary] setValue:myHandler forKey:NSAssertionHandlerKey]; \
            NSLog(@"[NSThread currentThread] set ALAssertionHandler");  \
        }   \
    } while(0)

    //ALAssert
    #define ALAssert(condition, desc, ...)	\
    do {                          \
        ALAssertThread;            \
        NSAssert(condition,desc); \
    } while(0)

    //ALAssert1
    #define ALAssert1(condition, desc, arg1)  \
    do {   \
        ALAssertThread;            \
        NSAssert((condition), (desc), (arg1), (nil)); \
    } while(0)

    //ALAssert2
    #define ALAssert2(condition, desc, arg1, arg2)  \
    do {       \
        ALAssertThread;            \
        NSAssert((condition), (desc), (arg1), (arg2), (nil)); \
    } while(0)

    //ALParameterAssert
    #define ALParameterAssert(condition)  \
    do {       \
        ALAssertThread;            \
        NSAssert((condition), @"Invalid parameter not satisfying: %@", @#condition,(nil));\
    } while(0)

    #endif //_ALAssertBody defined
#else // NS_BLOCK_ASSERTIONS defined
    #if !defined(_ALAssertBody)
    //Release模式下定义空宏

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


/**
 自定义断言处理类
 ALAssert宏等价于如下代码,封装简化了NSAssert调用:
    NSAssertionHandler *myHandler = [[ALAssertionHandler alloc] init];
    [[[NSThread currentThread] threadDictionary] setValue:myHandler forKey:NSAssertionHandlerKey];
    NSAssert(a == correctValue, @"a must equal to 5");

 */
@interface ALAssertionHandler : NSAssertionHandler


@end
