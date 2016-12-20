//
//  ViewController.m
//  HWJson
//
//  Created by huanwh on 2016/12/19.
//  Copyright © 2016年 huanwh. All rights reserved.
//

#import "ViewController.h"
#import "HWJson.h"


@interface ViewController ()
{
    HWJson * json;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest * request = [self requestWhether];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString * resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        json = [[HWJson alloc] initWithString:resString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resString) {
                _textView.text =[NSString stringWithFormat:@"%@",json];
            }
        });
        
        NSLog(@"加载完成");
    }];
    
    [task resume];
}

- (NSURLRequest *)requestWhether {
    NSString * urlString = @"http://apis.baidu.com/tianyiweather/basicforecast/weatherapi?area=101010100";
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"9fe31d289ac7abf25244f79300c41ca4" forHTTPHeaderField:@"apikey"];
    
    return request;
}

-(NSURLRequest *)request {
    NSURL * url = [NSURL URLWithString:@"https://api.github.com/users/octocat/followers"];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    return request;
}

- (IBAction)cul:(id)sender {
    
    NSLog(@"%@",[json objectForQuery:_textField.text]);
    
    HWJson * secondJson = [json objectForQuery:_textField.text];
    
    secondJson = [secondJson objectForQuery:_secondQueryTextField.text];
    
    _resultTextView.text =[NSString stringWithFormat:@"%@", secondJson];
}
@end
