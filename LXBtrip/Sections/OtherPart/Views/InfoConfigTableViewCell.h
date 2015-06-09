//
//  InfoConfigTableViewCell.h
//  lxb
//
//  Created by Sam on 6/9/15.
//  Copyright (c) 2015 Bkrtrip. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WebChatConfig,
    UserInfoConfig,
} ConfigType;

typedef enum : NSUInteger {
    WCPublicUserName,
    WCPwd,
    PublicAppId,
    PublicSecret,
    WCPayAcount,
    WCPaySecret
} ConfigContentType;

@interface InfoConfigTableViewCell : UITableViewCell

- (void)changeUIStateForType:(ConfigType)type;

- (void)initializeCellForType:(ConfigContentType)type;

- (void)setcontentInformation:(NSString *)content;

@end
