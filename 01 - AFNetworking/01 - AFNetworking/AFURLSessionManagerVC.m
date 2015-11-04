//
//  AFURLSessionManagerVC.m
//  01 - AFNetworking
//
//  Created by 学不会 on 15/11/4.
//  Copyright (c) 2015年 hnqingyun. All rights reserved.
//

#import "AFURLSessionManagerVC.h"

#import "common.h"

#import "AFURLSessionManager.h"

@interface AFURLSessionManagerVC ()

@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgress;

@end

@implementation AFURLSessionManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)downloadSong:(UIButton *)sender {
    
    // 1.创建session configuration
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 2.创建session manager
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    // 3.创建下载任务
    // 3.1 创建请求
    NSString *urlStr = @"http://tingge.5nd.com/20060919//2014-8-20/63916/1.Mp3";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    /**
     * 参数：
        1.downloadTaskWithRequest：NSURLRequest对象（请求）
        2.progress：进度值 需要一个NSProgress(进度条)对象的地址
        3.destination：block块 返回一个NSURL对象,代表将来下载的东西放到哪里
        4.completionHandler：完成下载之后的回调block块
     */
    
    NSProgress *progress;  // 进度条
    
    // 3.2 创建下载
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        // 这个block就是用来返回将来下载的东西放到哪里，所以需要构建一个URL，并返回
        
        // 建议的名字
        NSString *suggestedName = response.suggestedFilename;
        // 拼接之后的路径字符串
        NSString *path = [@"/Users/wangzhen/Desktop" stringByAppendingPathComponent:suggestedName];
        // 返回最终的路径URL
        return [NSURL fileURLWithPath:path];
        
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentationDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
    }];
    
    // 4.启动下载任务
    [downloadTask resume];
    
    // 5.对progress对象添加观察者
    [progress addObserver:self forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:(__bridge void *)(_downloadProgress)];
}

- (IBAction)uploadMultiPart:(UIButton *)sender {
    
    // 1.创建URL字符串
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"upload2server.json"];
    
    // 2.创建session configuration
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 3.创建session manager
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    // 4. ## 创建request 使用请求序列化器创建请求 request
    // 4.1 本地文件的URL
    NSURL *fileurl = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"jpg"];
    NSURL *fileurl2 = [[NSBundle mainBundle] URLForResource:@"2" withExtension:@"jpg"];
    // 4.2 创建 mutable request
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:nil constructingBodyWithBlock:^void(id<AFMultipartFormData> formdata) {
        
        [formdata appendPartWithFileURL:fileurl name:@"image" fileName:@"car.jpg" mimeType:@"image/jpeg" error:nil];
        
        [formdata appendPartWithFileURL:fileurl2 name:@"image" fileName:@"car.jpg" mimeType:@"image/jpeg" error:nil];
        
    } error:nil];
    
    NSProgress *progress;  // 进度条
    
    // 5.创建上传任务
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error:%@",error);
        } else {
            NSLog(@"%@ %@",request,responseObject);
        }
    }];
    
    // 6.开始上传任务
    [uploadTask resume];
    
    // 7.观察progress的completedUnitCount属性的变化
    [progress addObserver:self forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:(__bridge void *)(_uploadProgress)];
}

// 当被观察的对象的响应的属性值发生变化时，会回调该方法
// object参数，就是值改变的那个对象，对于我们来说，也就是NSProgress对象
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"completedUnitCount"]) {
        
        // 已经完成的
        int64_t completed = [change[@"new"] longLongValue];
        // 总共的
        //NSProgress *progress = (__bridge NSProgress *)(context);  bug未修改前，只一个进度条更新
        NSProgress *progress = object;
        int64_t total = progress.totalUnitCount;
        // 计算出进度
        float progressValue = (float)completed / (float)total;
        
        if ([[NSThread currentThread] isMainThread]) {
            // 更新进度条
            _downloadProgress.progress = progressValue;
        } else {
            NSLog(@"非主线程!");
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新进度条
                UIProgressView *progressView = (__bridge UIProgressView *)(context);
                progressView.progress = progressValue;
            });
        }
        
    }
}

@end
