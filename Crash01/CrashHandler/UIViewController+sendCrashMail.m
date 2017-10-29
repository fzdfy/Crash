//
//  UIViewController+sendCrashMail.m
//  Crash01
//
//  Created by 凤云鹏 on 2017/10/12.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "UIViewController+sendCrashMail.h"
#import "CrashHandler.h"
#import <objc/message.h>

static const char *faild_key = "faild";
static const char *success_key = "success";

@implementation UIViewController (sendCrashMail)

- (void)sendAllCrashLog {
    
    NSArray *logArray = [[CrashHandler sharedInstance] queryCrashLog];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingString:@"/Crash"];
    NSFileManager *mf = [NSFileManager defaultManager];
    
    MFMailComposeViewController *mfMail = [MFMailComposeViewController new];
    NSString *subject = @"Crash Log";
    NSString *message = @"发现崩溃日志";
    NSArray *recipients = @[@"1471200158@qq.com"];
    for (int i=0; i<logArray.count; i++) {
        NSString *name = [logArray[i] componentsSeparatedByString:@"/"].lastObject;
        NSString *string = logArray[i];
        if ([string containsString:@".log"]){
            NSData *data = [NSData dataWithContentsOfFile:string];
            [mfMail addAttachmentData:data mimeType:@"" fileName:name];
        }
    }
    [self sendMail:mfMail andSubject:subject andMessageBody:message andRecipients:recipients];
    self.success = ^{
        [mf removeItemAtPath:path error:nil];
    };
}

- (void)sendCrashLog{
    NSLog(@"发送");
}

//发送邮件具体实现
-(void)sendMail:(MFMailComposeViewController*)mf andSubject:(NSString*)subject andMessageBody:(NSString*)message andRecipients:(NSArray*)recipients
{
    if([MFMailComposeViewController canSendMail]){// 用户已设置邮件账户
        mf.mailComposeDelegate = self;
        [mf setSubject:subject];
        [mf setToRecipients:recipients];
        [mf setMessageBody:message isHTML:YES];
        [self presentViewController:mf animated:YES completion:nil];
    }else{//无邮件帐户,请设置邮件帐户来发送电子邮件
        [self alertView:@"不能调用邮箱" andDesc:@"请尝试下载App原生邮箱，并配置"];
    }
}

//MFMailComposeViewControllerDelegate 代理方法
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            
            [self alertView:@"发送成功" andDesc:nil];
            if (self.success){
                self.success();
            }
            break;
        case MFMailComposeResultSaved:
            [self alertView:@"保存成功" andDesc:nil];
            break;
        case MFMailComposeResultFailed:
            if (self.faild){
                self.faild();
            }
            [self alertView:error.domain andDesc:[NSString stringWithFormat:@"%@",error.userInfo]];
            break;
        case MFMailComposeResultCancelled:
            [self alertView:@"取消发送" andDesc:nil];
            break;
        default:
            [self alertView:@"为什么不发送" andDesc:nil];
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//提示框
-(void)alertView:(NSString *)title andDesc:(NSString*)desc{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:title delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

//运行时添加属性
-(MailFaild)faild
{
    return objc_getAssociatedObject(self, faild_key);
};

-(void)setFaild:(MailFaild)faild
{
    objc_setAssociatedObject(self, faild_key, faild, OBJC_ASSOCIATION_COPY);
};


-(MailSuccess)success{
    return objc_getAssociatedObject(self, success_key);
};

-(void)setSuccess:(MailSuccess)success{
    objc_setAssociatedObject(self, success_key, success, OBJC_ASSOCIATION_COPY);
}

@end
