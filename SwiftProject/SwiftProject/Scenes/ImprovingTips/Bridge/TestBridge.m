//
//  TestBridge.m
//  SwiftProject
//
//  Created by Ryan on 2019/12/10.
//  Copyright © 2019 cactus. All rights reserved.
//

#import "TestBridge.h"

@implementation TestBridge

- (void)test {

    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        NSLog(@"thread:%d",[NSThread isMainThread]);
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"thread:%d",[NSThread isMainThread]);
        });
    });

    return;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:true forKey:@"1"];
    [userDefaults setInteger:1 forKey:@"2"];
    [userDefaults setFloat:11 forKey:@"3"];
    [userDefaults setDouble:12 forKey:@"4"];
    [userDefaults setURL:[NSURL URLWithString:@"a"] forKey:@"5"];
    [userDefaults setObject:@[@(1)] forKey:@"6"];

    [userDefaults boolForKey:@"1"];
    [userDefaults integerForKey:@"2"];
    [userDefaults floatForKey:@"3"];
    [userDefaults doubleForKey:@"4"];
    [userDefaults URLForKey:@"5"];
    [userDefaults objectForKey:@"6"];

}

- (BOOL)isMainQueue {
    static const void* mainQueueKey = @"mainQueue";
    static void* mainQueueContext = @"mainQueue";

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_set_specific(dispatch_get_main_queue(), mainQueueKey, mainQueueContext, nil);
    });

    return dispatch_get_specific(mainQueueKey) == mainQueueContext;
}

@end
