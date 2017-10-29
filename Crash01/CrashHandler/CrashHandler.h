//
//  CrashHandler.h
//  Crash01
//
//  Created by 凤云鹏 on 2017/10/11.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrashHandler : NSObject


+ (instancetype)allocWithZone:(struct _NSZone *)zone;
+ (instancetype)sharedInstance;
- (id)copyWithZone:(NSZone *)zone;
- (id)mutableCopyWithZone:(NSZone *)zone;

- (NSArray*)queryCrashLog;
@end

//函数方法，AppDelegate中调用
void CrashExceptionHandler(void);
