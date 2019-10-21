//
//  SynthesizeSingleton.h
//
//

#ifndef SYNTHESIZE_SINGLETON

#import <objc/runtime.h>


#pragma mark -
#pragma mark ARC Singleton
/* Synthesize Singleton For Class.
 */
#define SYNTHESIZE_SINGLETON_HEADER(__CLASSNAME__)	\
+ (__CLASSNAME__ *)sharedInstance;\

#define SYNTHESIZE_SINGLETON(__CLASSNAME__)	\
static BOOL __CLASSNAME__##_hasInited = NO;\
static __CLASSNAME__ * __CLASSNAME__##_sharedInstance = nil;\
+ (id)allocWithZone:(NSZone *)zone\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        __CLASSNAME__##_sharedInstance = [super allocWithZone:zone];\
    });\
    return __CLASSNAME__##_sharedInstance;\
}\
\
- (id) init {\
if (!__CLASSNAME__##_hasInited) {\
    if ((self = [super init])) {\
        if(class_getInstanceMethod([__CLASSNAME__ class],@selector(initOnce))!=NULL)\
        {\
            [self performSelector:@selector(initOnce)];\
        }\
        __CLASSNAME__##_hasInited = YES;\
    }\
}\
return self;\
}\
\
+ (__CLASSNAME__ *)sharedInstance\
{\
    if(__CLASSNAME__##_sharedInstance == nil)\
    {\
        __CLASSNAME__##_sharedInstance = [[__CLASSNAME__ alloc] init];\
    }\
    return __CLASSNAME__##_sharedInstance;\
}

#endif /* SYNTHESIZE_SINGLETON_FOR_CLASS */
