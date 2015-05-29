//
//  CommentInfo.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/29.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "CommentInfo.h"

@implementation CommentInfo

- (id)initWithDict:(NSDictionary *)dict
{
    self.commentUserPhoto = [dict[@""] isKindOfClass:[NSNull class]]?nil:dict[@""];
    self.commentUserName = [dict[@""] isKindOfClass:[NSNull class]]?nil:dict[@""];
    self.commentContent = [dict[@""] isKindOfClass:[NSNull class]]?nil:dict[@""];
    self.commentCreatedTime = [dict[@""] isKindOfClass:[NSNull class]]?nil:dict[@""];
    
    return self;
}




@end
