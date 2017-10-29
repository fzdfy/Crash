//
//  CrashHandler.m
//  Crash01
//
//  Created by 凤云鹏 on 2017/10/11.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "CrashHandler.h"
#import <MessageUI/MessageUI.h>
#import "UIViewController+sendCrashMail.h"

@interface CrashHandler()<MFMailComposeViewControllerDelegate>

@end

@implementation CrashHandler

//单例
static id _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    }
    return _instance;
}

+ (instancetype)sharedInstance
{
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

/**************************/

//查询崩溃日志
- (NSArray*)queryCrashLog {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingString:@"/Crash"];
    NSFileManager *mf = [NSFileManager defaultManager];
    if(![mf fileExistsAtPath:path])
    {
        return nil;
    }
    NSArray *array = [mf contentsOfDirectoryAtPath:path error:nil];
    
    NSMutableArray *pathArr = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
        
        NSString *string = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",obj]];
        [pathArr addObject:string];
    }];
    return pathArr;
}

//程序崩溃时保存日志
- (void)saveLog:(NSString *)crashLog andDate:(NSDate *)date
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingString:@"/Crash"];
    if(![[NSFileManager defaultManager]fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *logPath = [path stringByAppendingFormat:@"/%@.log",date];
    [crashLog writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

//获取当前显示的VC,(最完整思路)
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        
        NSLog(@"===%@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}
@end

//获取App的一些信息添加到日志中
void ExceptionLog(NSException *exception)
{
    NSDate *date_current = [NSDate date];
    NSDictionary *dictInfo = [[NSBundle mainBundle]infoDictionary];
    NSString *name_App = [dictInfo objectForKey:@"CFBundleDisplayName"];
    NSString *verson_App = [dictInfo objectForKey:@"CFBundleShortVersionString"];
    NSString *build_App = [dictInfo objectForKey:@"CFBundleVersion"];
    NSArray *ecp = exception.callStackSymbols;
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:
                               @"\n\n ******************************异常日志****************************** \n时间:%@\nApp名称:%@\nApp版本:%@\nBuild版本:%@\n异常名称:%@\n异常原因:%@\n堆栈信息:%@",date_current,name_App,verson_App,build_App,name,reason,ecp];
    [[CrashHandler sharedInstance] saveLog:exceptionInfo andDate:date_current];

#ifdef DEBUG
    NSLog(@"%@",exceptionInfo);
#else
    
#endif
    
}

//函数方法
void CrashExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&ExceptionLog);
}


