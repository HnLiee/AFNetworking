//
//  AFHTTPSessionMgrVC.m
//  01 - AFNetworking
//
//  Created by 学不会 on 15/11/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "AFHTTPSessionMgrVC.h"

#import "common.h"

#import "AFHTTPSessionManager.h"

@interface AFHTTPSessionMgrVC ()

@end

@implementation AFHTTPSessionMgrVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)get:(UIButton *)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"request_get.json"];
    
    NSDictionary *parameters = @{@"foo":@"bar"};
    
    [manager GET:urlStr parameters:parameters success:^void(NSURLSessionDataTask * task, id responseObj) {
        
        NSLog(@"%@",responseObj);
        
    } failure:^void(NSURLSessionDataTask * task, NSError * error) {
        
        NSLog(@"%@",error);
        
    }];
    
}

- (IBAction)POSTFormencoded:(UIButton *)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"request_post_body_http.json"];
    
    NSDictionary *parameters = @{@"foo":@"bar"};
    
    [manager POST:urlStr parameters:parameters success:^void(NSURLSessionDataTask * task, id responseObj) {
        
        NSLog(@"%@",responseObj);
        
    } failure:^void(NSURLSessionDataTask * task, NSError * error) {
        
        NSLog(@"%@",error);
        
    }];
    
}

- (IBAction)POSTMultiPart:(UIButton *)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"upload2server.json"];
    
    NSURL *fileStr1 = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"jpg"];
    NSURL *fileStr2 = [[NSBundle mainBundle] URLForResource:@"2" withExtension:@"jpg"];
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^void(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileURL:fileStr1 name:@"image" fileName:@"xxx.jpg" mimeType:@"image/jpeg" error:nil];
        
        [formData appendPartWithFileURL:fileStr2 name:@"image" fileName:@"yyy.jpg" mimeType:@"image/jpeg" error:nil];
        
    } success:^void(NSURLSessionDataTask * task, id responseObj) {
        NSLog(@"%@",responseObj);
    } failure:^void(NSURLSessionDataTask * task, NSError * reeor) {
        NSLog(@"%@",error);
    }];
    
    
    
    
}


@end
