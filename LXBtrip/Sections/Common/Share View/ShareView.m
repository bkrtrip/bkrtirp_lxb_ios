//
//  ShareView.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/27.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "ShareView.h"

@interface ShareView()
{
    id shareObj;
}

@end

@implementation ShareView

- (CGFloat)shareViewHeightWithShareObject:(id)object
{
    shareObj = object;
    return 350.f;
}


- (IBAction)shareToQQClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithQQWithShareObject:)]) {
        [self.delegate supportClickWithQQWithShareObject:shareObj];
    }
}

- (IBAction)shareToWeChatClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithWeChatWithShareObject:)]) {
        [self.delegate supportClickWithWeChatWithShareObject:shareObj];
    }
}

- (IBAction)shareToFriendsClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithFriendsWithShareObject:)]) {
        [self.delegate supportClickWithFriendsWithShareObject:shareObj];
    }
}

- (IBAction)shareToShortMessageClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithShortMessageWithShareObject:)]) {
        [self.delegate supportClickWithShortMessageWithShareObject:shareObj];
    }
}

- (IBAction)shareToMyComputerClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithSendingToComputerWithShareObject:)]) {
        [self.delegate supportClickWithSendingToComputerWithShareObject:shareObj];
    }
}

- (IBAction)shareToWeiBoClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithWeiboWithShareObject:)]) {
        [self.delegate supportClickWithWeiboWithShareObject:shareObj];
    }
}

- (IBAction)shareToQZoneClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithQZoneWithShareObject:)]) {
        [self.delegate supportClickWithQZoneWithShareObject:shareObj];
    }
}

- (IBAction)shareToYiXinClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(supportClickWithYiXinWithShareObject:)]) {
        [self.delegate supportClickWithYiXinWithShareObject:shareObj];
    }
}

@end
