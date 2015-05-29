//
//  CommentInfo.h
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/29.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInfo : NSObject

@property (nonatomic, copy) NSString *commentUserPhoto;
@property (nonatomic, copy) NSString *commentUserName;
@property (nonatomic, copy) NSString *commentContent;
@property (nonatomic, copy) NSString *commentCreatedTime;

- (id)initWithDict:(NSDictionary *)dict;

@end
