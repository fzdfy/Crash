//
//  UIViewController+sendCrashMail.h
//  Crash01
//
//  Created by 凤云鹏 on 2017/10/12.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

typedef void(^MailSuccess)(void);
typedef void(^MailFaild)(void);

@interface UIViewController (sendCrashMail) <MFMailComposeViewControllerDelegate>

//成功回调，运行时添加
@property (nonatomic,copy)MailSuccess success;
//失败回调，运行时添加
@property (nonatomic,copy)MailFaild faild;

- (void)sendAllCrashLog;
- (void)sendCrashLog;
@end
