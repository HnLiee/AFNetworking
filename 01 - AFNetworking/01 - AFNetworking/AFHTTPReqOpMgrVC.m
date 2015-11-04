//
//  AFHTTPReqOpMgrVC.m
//  01 - AFNetworking
//
//  Created by 学不会 on 15/11/3.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "AFHTTPReqOpMgrVC.h"

#import "common.h"

#import "AFHTTPRequestOperationManager.h"

@interface AFHTTPReqOpMgrVC ()

@end

@implementation AFHTTPReqOpMgrVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)get:(UIButton *)sender {
    
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"request_get.json"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parametes = @{@"foo":@"bar"};
    
    [manager GET:urlStr parameters:parametes success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON:%@",responseObject);
    } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        NSLog(@"Error:%@",error);
    }];
}

- (IBAction)POSTFormEncoded:(UIButton *)sender {
    
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"request_post_body_http.json"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // manager的请求序列化器 (决定怎么构建body)
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // manager的响应序列化器
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parametes = @{@"foo":@"bar"};
    
    [manager POST:urlStr parameters:parametes success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON:%@",responseObject);
    } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        NSLog(@"Error:%@",error);
    }];
}

// 上传（ 什么时候用GET，什么时候用POST，就看服务器接口要求我们用什么，我们就用什么 ）
//  (什么时候带参数，什么时候不带参数，就看服务器接口要求我们带不带参数)
- (IBAction)POSTMultiPart:(UIButton *)sender {
    
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"upload2server.json"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 本地将要上传的文件的URL (沙河里面的资源的URL)
    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"jpg"];
    
    // 网络状态监测
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^void(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"通过wifi下载");
        }
    }];
    [manager.reachabilityManager startMonitoring];
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 构建body 往body中追加文件，传入文件URL即可
        // name（image）该字段要看服务器如何标识
        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON:%@",responseObject);
    } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        NSLog(@"Error:%@",error);
    }];
}

@end
