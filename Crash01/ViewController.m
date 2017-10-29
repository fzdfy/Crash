//
//  ViewController.m
//  Crash01
//
//  Created by 凤云鹏 on 2017/10/11.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "ViewController.h"
#import "CrashReportViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self Crash];
    self.view.backgroundColor = [UIColor whiteColor];
    CrashReportViewController *crashViewController = [[CrashReportViewController alloc] init];
    [self.navigationController pushViewController:crashViewController animated:YES];
}

- (void)Crash {
    NSArray *array = @[@3,@8,@"guozihui"];
    NSString *str = array[9];
    NSLog(@"%@",str);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
