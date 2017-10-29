//
//  CrashDeltailViewController.m
//  Crash01
//
//  Created by 凤云鹏 on 2017/10/12.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "CrashDeltailViewController.h"
#import "UIViewController+sendCrashMail.h"

#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW [UIScreen mainScreen].bounds.size.width

@interface CrashDeltailViewController ()

@property (nonatomic,strong) UIScrollView *mainView;
@property (nonatomic,strong) UILabel*label;
@end

@implementation CrashDeltailViewController

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
    self.mainView.contentSize = CGSizeMake(SCREENW, SCREENH*2);
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
    self.label.numberOfLines = 0;
    self.label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.mainView];
    [self.mainView addSubview:self.label];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if ([self.logName containsString:@".log"]){
        NSData *data = [NSData dataWithContentsOfFile:self.logName];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",string);
        self.label.text = string;
    }
    [self sendAllCrashLog];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
