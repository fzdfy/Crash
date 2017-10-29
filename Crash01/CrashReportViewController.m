//
//  CrashReportViewController.m
//  Crash01
//
//  Created by 凤云鹏 on 2017/10/12.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "CrashReportViewController.h"
#import "UIViewController+sendCrashMail.h"
#import "CrashHandler.h"
#import "CrashDeltailViewController.h"

#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW [UIScreen mainScreen].bounds.size.width

@interface CrashReportViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *dateSource;
@end

@implementation CrashReportViewController

- (void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, 0, SCREENW, SCREENH);
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dateSource = [[CrashHandler sharedInstance] queryCrashLog];
    [self.tableView reloadData];
}

#pragma mark - 数据源方法
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"计算分组数");
    return 1;
}

// 返回行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dateSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

// 设置cell
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CrashCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CrashCell"];
    }
    cell.textLabel.text = self.dateSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CrashDeltailViewController *vc = [[CrashDeltailViewController alloc] init];
    vc.logName = self.dateSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
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
