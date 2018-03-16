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

- (void)requestUrl:(NSString *)url
{
    NSLog(@"send request: %@ with thread: %@", url, [NSThread currentThread]);
    
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"error occured");
        } else {
            NSLog(@"response arrived with request URL: %@ with thread: %@", response.URL, [NSThread currentThread]);
        }
    }];
    [task resume];
}

- (void)sendNetworkRequests
{
    NSLog(@"begin");
    
    for (NSString *url in [self urls]) {
        [self requestUrl:url];
    }
    
    NSLog(@"end");
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
