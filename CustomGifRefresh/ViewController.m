//
//  ViewController.m
//  CustomGifRefresh
//
//  Created by WXQ on 2018/8/20.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "ViewController.h"
#import "CustomGifHeader.h"
#import "CustomGifFooter.h"
#import "CustomAutoGifFooter.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)CustomGifHeader * gifHeader;
@property(nonatomic,strong)CustomGifFooter * gifFooter;
@property(nonatomic,strong)CustomAutoGifFooter * gifAutoFooter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"自定义刷新动画";
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.mj_header = self.gifHeader;
        _tableView.mj_footer = self.gifFooter;
//        _tableView.mj_footer = self.gifAutoFooter;
    }
    return _tableView;
}

- (CustomGifHeader *)gifHeader {
    if (!_gifHeader) {
        _gifHeader = [CustomGifHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
            });
        }];
    }
    return _gifHeader;
}

- (CustomGifFooter *)gifFooter {
    if (!_gifFooter) {
        _gifFooter = [CustomGifFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshing];
            });
        }];
    }
    return _gifFooter;
}

- (CustomAutoGifFooter *)gifAutoFooter {
    if (!_gifAutoFooter) {
        _gifAutoFooter = [CustomAutoGifFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshing];
            });
        }];
    }
    return _gifAutoFooter;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.text = @"假装有内容";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
