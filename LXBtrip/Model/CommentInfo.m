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
    self.commentUserPhoto = [dict[@"head_url"] isKindOfClass:[NSNull class]]?nil:dict[@"head_url"];
    self.commentUserName = [dict[@"staff_name"] isKindOfClass:[NSNull class]]?nil:dict[@"staff_name"];
    self.commentContent = [dict[@"content"] isKindOfClass:[NSNull class]]?nil:dict[@"content"];
    self.commentCreatedTime = [dict[@"create_date"] isKindOfClass:[NSNull class]]?nil:dict[@"create_date"];
    
    return self;
}




@end
