//
//  AFHTTPReqOpVC.m
//  01 - AFNetworking
//
//  Created by 学不会 on 15/11/3.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "AFHTTPReqOpVC.h"

#import "AFNetwork/AFHTTPRequestOperation.h"

#import "common.h"

@interface AFHTTPReqOpVC ()

@end

@implementation AFHTTPReqOpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)get:(UIButton *)sender {
    
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"response.json"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONRequestSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^void(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON:%@",responseObject);
    } failure:^void(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error:%@",error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
}

@end
