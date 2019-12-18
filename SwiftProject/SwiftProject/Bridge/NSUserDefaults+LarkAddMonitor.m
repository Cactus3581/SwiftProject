//
//  NSUserDefaults+LarkAddMonitor.m
//  LarkApp
//
//  Created by 夏汝震 on 2019/12/10.
//

#import "NSUserDefaults+LarkAddMonitor.h"
#import <objc/runtime.h>
#import <objc/message.h>

static NSString *kUserDefaultsLogReadSign = @"UserDefaultsLogReadSign";
static NSString *kUserDefaultsLogWriteSign = @"UserDefaultsLogWriteSign";

@implementation NSUserDefaults (LarkAddMonitor)

+ (void)load {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self p_swizzleMethods:[self class] originalSelector:@selector(setBool:forKey:) swizzledSelector:@selector(_setBool:forKey:)];
        [self p_swizzleMethods:[self class] originalSelector:@selector(boolForKey:) swizzledSelector:@selector(_boolForKey:)];

        [self p_swizzleMethods:[self class] originalSelector:@selector(setInteger:forKey:) swizzledSelector:@selector(_setInteger:forKey:)];
        [self p_swizzleMethods:[self class] originalSelector:@selector(integerForKey:) swizzledSelector:@selector(_integerForKey:)];

        [self p_swizzleMethods:[self class] originalSelector:@selector(setFloat:forKey:) swizzledSelector:@selector(_setFloat:forKey:)];
        [self p_swizzleMethods:[self class] originalSelector:@selector(floatForKey:) swizzledSelector:@selector(_floatForKey:)];

        [self p_swizzleMethods:[self class] originalSelector:@selector(setDouble:forKey:) swizzledSelector:@selector(_setDouble:forKey:)];
        [self p_swizzleMethods:[self class] originalSelector:@selector(doubleForKey:) swizzledSelector:@selector(_doubleForKey:)];

        [self p_swizzleMethods:[self class] originalSelector:@selector(setURL:forKey:) swizzledSelector:@selector(_setURL:forKey:)];
        [self p_swizzleMethods:[self class] originalSelector:@selector(URLForKey:) swizzledSelector:@selector(_URLForKey:)];

        [self p_swizzleMethods:[self class] originalSelector:@selector(setObject:forKey:) swizzledSelector:@selector(_setObject:forKey:)];
        [self p_swizzleMethods:[self class] originalSelector:@selector(objectForKey:) swizzledSelector:@selector(_objectForKey:)];
    });
}

- (void)_setBool:(BOOL)value forKey:(NSString *)defaultName {
    [self _setBool:value forKey:defaultName];
    [self writeLog];
}

- (BOOL)_boolForKey:(NSString *)defaultName {
    [self readLog];
    return [self _boolForKey:defaultName];
}

- (void)_setInteger:(NSInteger)value forKey:(NSString *)defaultName {
    [self _setInteger:value forKey:defaultName];
    [self writeLog];
}

- (NSInteger)_integerForKey:(NSString *)defaultName {
    [self readLog];
    return [self _integerForKey:defaultName];
}

- (void)_setFloat:(float)value forKey:(NSString *)defaultName {
    [self _setFloat:value forKey:defaultName];
    [self writeLog];
}

- (float)_floatForKey:(NSString *)defaultName {
    [self readLog];
    return [self _floatForKey:defaultName];
}

- (void)_setDouble:(double)value forKey:(NSString *)defaultName {
    [self _setDouble:value forKey:defaultName];
    [self writeLog];
}

- (double)_doubleForKey:(NSString *)defaultName {
    [self readLog];
    return [self _doubleForKey:defaultName];
}

- (void)_setURL:(NSURL *)url forKey:(NSString *)defaultName {
    [self _setURL:url forKey:defaultName];
    [self writeLog];
}

- (NSURL *)_URLForKey:(NSString *)defaultName {
    [self readLog];
    return [self _URLForKey:defaultName];
}

- (void)_setObject:(id)value forKey:(NSString *)defaultName {
    [self _setObject:value forKey:defaultName];
    [self writeLog];
}

- (id)_objectForKey:(NSString *)defaultName {
    [self readLog];
    return [self _objectForKey:defaultName];
}

- (void)writeLog {
    NSString *path = [self p_path:true];
    NSInteger num = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] integerValue];
    [[@(++num) stringValue] writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)readLog {
//    NSInteger num = [self _integerForKey:kUserDefaultsLogReadSign];
//    [self _setInteger:++num forKey:kUserDefaultsLogReadSign];
    NSString *path = [self p_path:false];
    NSInteger num = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] integerValue];
    [[@(++num) stringValue] writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (NSString *)p_path:(BOOL)isWrite {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = nil;
    if (isWrite) {
        filePath = [documentsPath stringByAppendingPathComponent:@"UserDefaultsLogWriteSign.txt"];
    } else {
        filePath = [documentsPath stringByAppendingPathComponent:@"UserDefaultsLogReadSign.txt"];
    }
    return filePath;
}

+ (void)p_swizzleMethods:(Class)class originalSelector:(SEL)origSel swizzledSelector:(SEL)swizSel {
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method swizMethod = class_getInstanceMethod(class, swizSel);
    BOOL didAddMethod = class_addMethod(class, origSel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, swizMethod);
    }
}

@end
