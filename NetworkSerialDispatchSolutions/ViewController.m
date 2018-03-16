//
//  ViewController.m
//  NetworkSerialDispatchSolutions
//
//  Created by Ralph Zhou on 2018/03/16.
//  Copyright © 2018 Genmis Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDelegate>

@property (nonatomic) NSURLSession *session;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureNetworkSession];
}

- (IBAction)sendRequestButtonTapped:(id)sender
{
    [self sendNetworkRequests];
}

#pragma mark - Private

- (void)configureNetworkSession
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
}

- (void)request:(NSMutableArray<NSString *> *)urls completion:(void (^)(void))completion
{
    if (urls.count > 0) {
        NSString *url = urls.firstObject;
        [urls removeObjectAtIndex:0];
        [self requestUrl:url completion:^{
            [self request:urls completion:completion];
        }];
    } else {
        if (completion) {
            completion();
        }
    }
}

- (void)requestUrl:(NSString *)url completion:(void (^)(void))completion
{
    NSLog(@"send request: %@ with thread: %@", url, [NSThread currentThread]);
    
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error occured");
        } else {
            NSLog(@"response arrived with request URL: %@ with thread: %@", response.URL, [NSThread currentThread]);
        }
        
        if (completion) {
            completion();
        }
    }];
    [task resume];
}

- (void)sendNetworkRequests
{
    NSLog(@"begin");
    
    [self request:[NSMutableArray arrayWithArray:[self urls]] completion:^{
        NSLog(@"end");
    }];
}

- (NSArray<NSString *> *)urls
{
    return @[@"https://ad-api-v01-jp-dev.ulizaex.com/reqVMAP.php?EpisodeCode=sdk-dev1&DistributorID=861",
             @"https://ad-api-v01-jp-dev.ulizaex.com/reqVMAP.php?EpisodeCode=sdk-dev2&DistributorID=861",
             @"https://ad-api-v01-jp-dev.ulizaex.com/reqVMAP.php?EpisodeCode=sdk-dev3&DistributorID=861",
             @"https://ad-api-v01-jp-dev.ulizaex.com/reqVMAP.php?EpisodeCode=sdk-dev4&DistributorID=861",
             @"https://ad-api-v01-jp-dev.ulizaex.com/reqVMAP.php?EpisodeCode=sdk-dev5&DistributorID=861"];
}

@end
