//
//  CBridge.h
//  SwiftProject
//
//  Created by 夏汝震 on 2021/9/15.
//  Copyright © 2021 cactus. All rights reserved.
//

#ifndef CBridging_h
#define CBridging_h

#include <stdio.h>

typedef void* CPersonModel;

#ifdef __cplusplus
extern "C" {
#endif
    void printHellow(void);
    int getRandomInt(void);


    CPersonModel create();
    CPersonModel createBy(const char* name,int age);
    void printPersonInfo(CPersonModel model);
    const char* getPersonName(CPersonModel model);
    void destoryModel(CPersonModel model);


    void runSwiftFun(void);


#ifdef __cplusplus
}
#endif



#endif /* CBridging_h */
