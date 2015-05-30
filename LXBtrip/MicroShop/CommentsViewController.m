//
//  CommentsViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/29.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentTableViewCell.h"

@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    NSInteger page_num;
}
@property (strong, nonatomic) IBOutlet UITextView *writeCommentTextView;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *commentsTableView;

@property (nonatomic, copy) NSMutableArray *commentsArray;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sendButton.layer.cornerRadius = 5.f;
    if (!_commentsArray) {
        _commentsArray = [[NSMutableArray alloc] init];
    }
    
    [_commentsTableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentTableViewCell"];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
    [cell setCellContentWithCommentInfo:_commentsArray[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setTitle:@"查看更多" forState:UIControlStateNormal];
    bt.titleLabel.textColor = RED_FF0075;
    [bt setImage:ImageNamed(@"detail_disclusure") forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(fetchMoreComments) forControlEvents:UIControlEventTouchUpInside];
    
    return bt;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 78.f;
}

- (IBAction)sendButtonClicked:(id)sender {
    // send comment...
    
}

- (void)fetchMoreComments
{
    
}






@end
