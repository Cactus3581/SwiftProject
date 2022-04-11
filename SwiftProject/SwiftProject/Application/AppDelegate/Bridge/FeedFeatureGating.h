//
//  FeedFeatureGating.h
//  SwiftCDemo
//
//  Created by yaojinhai on 2019/6/22.
//  Copyright © 2019 yaojinhai. All rights reserved.
//

#ifndef FeedFeatureGating_h
#define FeedFeatureGating_h

#include <stdio.h>

int(^ __nonnull getFgValueOfSwiftImpl)(const char *fg) = NULL;

void printHellow(void);
int getRandomInt(void);

void runSwiftFun(void);


#endif /* FeedFeatureGating_h */
