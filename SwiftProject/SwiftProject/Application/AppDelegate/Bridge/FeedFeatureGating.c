//
//  FeedFeatureGating.c
//  SwiftCDemo
//
//  Created by yaojinhai on 2019/6/22.
//  Copyright © 2019 yaojinhai. All rights reserved.
//

#include "FeedFeatureGating.h"
#include <stdlib.h>

void printHellow(void){
    printf("hellow world,I am is C language");
}

int getRandomInt(void){
    return rand();
}

void runSwiftFun(void){
    int a = getFgValueOfSwiftImpl("test"); // 调用swift 函数
    printf("result: a %d", a);
}

