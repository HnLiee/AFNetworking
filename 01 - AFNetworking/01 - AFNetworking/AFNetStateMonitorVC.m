//
//  AFNetStateMonitorVC.m
//  01 - AFNetworking
//
//  Created by 学不会 on 15/11/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "AFNetStateMonitorVC.h"

#import "AFNetworkReachabilityManager.h"

@interface AFNetStateMonitorVC ()

@property (weak, nonatomic) IBOutlet UIButton *monitorBtn;
@property (nonatomic, strong) AFNetworkReachabilityManager *manager;

@end

@implementation AFNetStateMonitorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _manager = [AFNetworkReachabilityManager sharedManager];
    
    [_manager setReachabilityStatusChangeBlock:^void(AFNetworkReachabilityStatus status) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络状态" message:AFStringFromNetworkReachabilityStatus(status) delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (IBAction)startOrEndMonitor:(UIButton *)sender {
    
    if (!sender.selected) {
        // 1.开始监测
        [_manager startMonitoring];
        
        // 2.将状态改为选中
        sender.selected = YES;
        
    } else {
        // 1.结束监测
        [_manager stopMonitoring];
        
        // 2.将状态改回未选中
        sender.selected = NO;
    }
    
    
    
    
    
    
    
    
    
    
    
}

@end
