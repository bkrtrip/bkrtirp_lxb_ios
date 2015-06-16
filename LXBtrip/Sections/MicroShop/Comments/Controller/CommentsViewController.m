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
    NSInteger pageNum;
    BOOL isRefreshing;
}

@property (strong, nonatomic) IBOutlet UITextView *writeCommentTextView;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (strong, nonatomic) IBOutlet UITableView *commentsTableView;

@property (nonatomic, copy) NSMutableArray *commentsArray;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"所有评论";
    _sendButton.layer.cornerRadius = 5.f;
    
    _writeCommentTextView.layer.borderColor = TEXT_CCCCD2.CGColor;
    _writeCommentTextView.layer.borderWidth = .5f;
    _writeCommentTextView.layer.cornerRadius = 5.f;
 
    [_commentsTableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentTableViewCell"];
    [self setTableFooterView];
    
    isRefreshing = YES;
    pageNum = 1;
    [self getCommentsList];
}

- (void)setTableFooterView
{
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 78.f)];
    bt.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [bt setTitle:@"查看更多" forState:UIControlStateNormal];
    [bt setTitleColor:RED_FF0075 forState:UIControlStateNormal];
    [bt setImage:ImageNamed(@"arrow_down") forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(fetchMoreComments) forControlEvents:UIControlEventTouchUpInside];
    bt.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    bt.imageEdgeInsets = UIEdgeInsetsMake(0, 110, 0, 0);
    
    _commentsTableView.tableFooterView = bt;
}

- (void)getCommentsList
{
    if (isRefreshing) {
        pageNum = 1;
    }
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    
    if ([UserModel companyId] && [UserModel staffId]) {
        [HTTPTool getReviewsListWithCompanyId:_product.productTravelGoodsCompanyId staffId:[UserModel staffId] lineCode:_product.productTravelGoodsCode pageNum:@(pageNum) success:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            [[Global sharedGlobal] codeHudWithObject:result[@"RS100045"] succeed:^{
                if ([result[@"RS100045"] isKindOfClass:[NSArray class]]) {
                    
                    if (isRefreshing) {
                        [_commentsArray removeAllObjects];
                    }
                    
                    if ([result[@"RS100045"] count] == 0) {
                        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有更多了" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                        [alert show];
                        return ;
                    }
                    
                    [result[@"RS100045"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        CommentInfo *comment = [[CommentInfo alloc] initWithDict:obj];
                        if (!_commentsArray) {
                            _commentsArray = [[NSMutableArray alloc] init];
                        }
                        [_commentsArray addObject:comment];
                    }];
                    _commentNumLabel.text = [NSString stringWithFormat:@"已有评论%lu条", (unsigned long)_commentsArray.count];
                    [_commentsTableView reloadData];
                    pageNum++;
                } else {
                    _commentNumLabel.text = @"已有评论0条";
                }
            }];
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [HTTPTool getReviewsListWithLineCode:_product.productTravelGoodsCode pageNum:@(pageNum) success:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            [[Global sharedGlobal] codeHudWithObject:result[@"RS100058"] succeed:^{
                if ([result[@"RS100045"] isKindOfClass:[NSArray class]]) {
                    [result[@"RS100045"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        CommentInfo *comment = [[CommentInfo alloc] initWithDict:obj];
                        if (!_commentsArray) {
                            _commentsArray = [[NSMutableArray alloc] init];
                        }
                        [_commentsArray addObject:comment];
                    }];
                    [_commentsTableView reloadData];
                    pageNum ++;
                } else {
                    _commentNumLabel.text = @"已有评论0条";
                }
            }];
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

- (void)writeComment
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    
    if ([UserModel companyId] && [UserModel staffId]) {
        [HTTPTool postReviewWithCompanyIdA:[UserModel companyId] staffIdA:[UserModel staffId] companyId:_product.productTravelGoodsCompanyId lineCode:_product.productTravelGoodsCode reviewContent:_writeCommentTextView.text success:^(id result) {
            [[Global sharedGlobal] codeHudWithObject:result[@"RS100046"] succeed:^{
                [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布评论成功！" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                // refresh comments list
                isRefreshing = YES;
                [self getCommentsList];
                _writeCommentTextView.text = @"";
                [_writeCommentTextView resignFirstResponder];
            }];
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布评论失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [HTTPTool postReviewWithCompanyId:_product.productTravelGoodsCompanyId lineCode:_product.productTravelGoodsCode reviewContent:_writeCommentTextView.text success:^(id result) {
            [[Global sharedGlobal] codeHudWithObject:result[@"RS100059"] succeed:^{
                [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布评论成功！" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                // refresh comments list
                [self getCommentsList];
            }];
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布评论失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
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
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 78.f)];
//    bt.titleLabel.font = [UIFont systemFontOfSize:14.f];
//    [bt setTitle:@"查看更多" forState:UIControlStateNormal];
//    [bt setTitleColor:RED_FF0075 forState:UIControlStateNormal];
//    [bt setImage:ImageNamed(@"arrow_down") forState:UIControlStateNormal];
//    [bt addTarget:self action:@selector(fetchMoreComments) forControlEvents:UIControlEventTouchUpInside];
//    bt.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
//    bt.imageEdgeInsets = UIEdgeInsetsMake(0, 110, 0, 0);
//    return bt;
//}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78.f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 78.f;
//}

- (IBAction)sendButtonClicked:(id)sender {
    if (_writeCommentTextView.text.length > 0) {
        // send comment...
        [self writeComment];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"评论内容不能为空" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)fetchMoreComments
{
    isRefreshing = NO;
    [self getCommentsList];
}


@end
