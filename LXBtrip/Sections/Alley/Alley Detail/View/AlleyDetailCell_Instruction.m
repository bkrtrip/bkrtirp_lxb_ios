//
//  AlleyDetailCell_Instruction.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/8.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AlleyDetailCell_Instruction.h"

@interface AlleyDetailCell_Instruction() <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *instructionsWebView;


@end

@implementation AlleyDetailCell_Instruction

- (void)awakeFromNib {
    // Initialization code
    if (!_instructionsWebView) {
        _instructionsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(8, 38.f, SCREEN_WIDTH-2*8.f, 50.f)];
        _instructionsWebView.scrollView.scrollEnabled = NO;
        [self.contentView addSubview:_instructionsWebView];
        _instructionsWebView.delegate = self;
    }
}

- (CGFloat)cellHeightWithAlleyInfo:(AlleyInfo *)info
{
    CGFloat cellHeight = 38.f;
    [_instructionsWebView loadHTMLString:info.alleyServiceNotice baseURL:nil];
    
    return cellHeight;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat webViewHeight = webView.scrollView.contentSize.height;
    [webView setFrame:CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, webViewHeight)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"INSTRUCTION_CELL_HTML_HAS_FINISHED_LOADING" object:self userInfo:@{@"instruction_cell_height":@(webViewHeight+38.f)}];
}

@end
