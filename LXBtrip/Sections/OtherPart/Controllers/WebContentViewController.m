//
//  WebContentViewController.m
//  LXBtrip
//
//  Created by Delta-AEC-APP on 15/7/1.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "WebContentViewController.h"

@interface WebContentViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;

@end

@implementation WebContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.contentUrl) {
        [self startLoadUrl:self.contentUrl];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startLoadUrl:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [self.contentWebView loadRequest:request];
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
