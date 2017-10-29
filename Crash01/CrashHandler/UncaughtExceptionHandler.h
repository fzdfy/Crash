//
//  UncaughtExceptionHandler.h
//  Crash01
//
//  Created by 凤云鹏 on 2017/10/12.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UncaughtExceptionHandler : NSObject
{
    BOOL dismissed;
}
@end

void InstallUncaughtExceptionHandler();
