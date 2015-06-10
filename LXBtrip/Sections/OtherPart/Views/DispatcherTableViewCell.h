//
//  DispatcherTableViewCell.h
//  LXBtrip
//
//  Created by Sam on 6/10/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DialToDispatcher,
    ShareDispatcherInfo,
} Actiontypes;

@protocol DispatcherActionDelegate <NSObject>

- (void)responseForAction:(Actiontypes)type forContactIndex:(NSInteger)index;

@end

@interface DispatcherTableViewCell : UITableViewCell

@property (nonatomic, weak) id<DispatcherActionDelegate> delegate;

- (void)initialContactInformation:(NSDictionary *)infoDic;

@end
