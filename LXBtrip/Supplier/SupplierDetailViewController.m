//
//  SupplierDetailViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/1.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SupplierDetailViewController.h"
#import "TourListTableViewCell.h"
#import "SupplierDetailTopImageTableViewCell.h"
#import "Global.h"

#import "YesOrNoView.h"
#import "ShareView.h"
#import "AccompanyInfoView.h"

#import "SetShopNameViewController.h"

typedef enum PopUpViewType
{
    None_Type = 0,
    Accompany_Type = 1,
    Preview_Type = 2,
    Share_Type = 3
} PopUpViewType;

@interface SupplierDetailViewController()<UITableViewDataSource, UITableViewDelegate, YesOrNoViewDelegate, TourListTableViewCell_Delegate, ShareViewDelegate, AccompanyInfoView_Delegate>
{
    NSInteger pageNum;
    PopUpViewType popUpType;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *addToOrRemoveFromMyShopButton;

@property (strong, nonatomic) YesOrNoView *yesOrNoView;
@property (strong, nonatomic) ShareView *shareView;
@property (strong, nonatomic) AccompanyInfoView *accompanyInfoView;

@property (strong, nonatomic) UIControl *darkMask;
@property (copy, nonatomic) NSString *type;


- (IBAction)addToOrRemoveFromMyShopButtonClicked:(id)sender;

@end

@implementation SupplierDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"供应商信息";
    [_tableView registerNib:[UINib nibWithNibName:@"TourListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TourListTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SupplierDetailTopImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"SupplierDetailTopImageTableViewCell"];
    
    pageNum = 0;
    popUpType = None_Type;
    
    _darkMask = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_darkMask addTarget:self action:@selector(dismissYesOrNoView) forControlEvents:UIControlEventTouchUpInside];
    _darkMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _darkMask.alpha = 0;// initally transparent
    [self.view addSubview:_darkMask];
    
    _yesOrNoView = [[NSBundle mainBundle] loadNibNamed:@"YesOrNoView" owner:nil options:nil][0];
    [_yesOrNoView setFrame:CGRectMake(0, SCREEN_HEIGHT - _yesOrNoView.frame.size.height, _yesOrNoView.frame.size.width, _yesOrNoView.frame.size.height)];
    _yesOrNoView.delegate = self;
    [self.view addSubview:_yesOrNoView];
    
    _shareView = [[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:nil options:nil][0];
    [_shareView setFrame:CGRectMake(0, SCREEN_HEIGHT - _shareView.frame.size.height, _shareView.frame.size.width, _shareView.frame.size.height)];
    _shareView.delegate = self;
    [self.view addSubview:_shareView];
    
    _accompanyInfoView = [[NSBundle mainBundle] loadNibNamed:@"AccompanyInfoView" owner:nil options:nil][0];
    [_accompanyInfoView setFrame:CGRectMake(0, SCREEN_HEIGHT - _accompanyInfoView.frame.size.height, _accompanyInfoView.frame.size.width, _accompanyInfoView.frame.size.height)];
    _accompanyInfoView.delegate = self;
    [self.view addSubview:_accompanyInfoView];
    
    [self getSupplierDetail];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setType:(NSString *)type
{
    _type = type;
    [self switchButtonStatus];
}

- (IBAction)addToOrRemoveFromMyShopButtonClicked:(id)sender
{
    // 未登录
    if (![[Global sharedGlobal] userInfo].companyId || ![[Global sharedGlobal] userInfo].staffId) {
        
        // go to login page
        // ...
        return;
    }
    
    // 未完成资料，合并后要修改
    if ([[Global sharedGlobal] userInfo]) {
        // go to open micro shop
        SetShopNameViewController *setName = [[SetShopNameViewController alloc] init];
        [self.navigationController pushViewController:setName animated:YES];
        return;
    }
    
    [self syncOrCancelSyncMySupplier];
}

#pragma mark - HTTP
- (void)getSupplierDetail
{
    if ([[Global sharedGlobal] userInfo].companyId && [[Global sharedGlobal] userInfo].staffId) {
        [HTTPTool getSupplierDetailWithCompanyId:[[Global sharedGlobal] userInfo].companyId staffId:[[Global sharedGlobal] userInfo].staffId supplierId:_info.supplierId pageNum:@(pageNum) isMy:_info.supplierIsMy success:^(id result) {
            id obj = result[@"RS100016"];
            [[Global sharedGlobal] codeHudWithObject:obj succeed:^{
                _info = [[SupplierInfo alloc] initWithDict:obj];
                if (_info.supplierIsMy) {
                    _type = [@(![_info.supplierIsMy boolValue]) stringValue];
                }

                [_tableView reloadData];
            }];
        } fail:^(id result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [HTTPTool getSupplierDetailWithSupplierId:_info.supplierId pageNum:@(pageNum) isMy:_info.supplierIsMy success:^(id result) {
            id obj = result[@"RS100015"];
            [[Global sharedGlobal] codeHudWithObject:obj succeed:^{
                _info = [[SupplierInfo alloc] initWithDict:obj];
                if (_info.supplierIsMy) {
                    _type = [@(![_info.supplierIsMy boolValue]) stringValue];
                }
                
                [_tableView reloadData];
            }];
        } fail:^(id result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

- (void)syncOrCancelSyncMySupplier
{
    [HTTPTool syncOrCancelSyncMySupplierWithCompanyId:[[Global sharedGlobal] userInfo].companyId staffId:[[Global sharedGlobal] userInfo].staffId supplierId:_info.supplierId supplierName:_info.supplierName supplierBrand:_info.supplierBrand type:_type success:^(id result) {
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100017"] succeed:^{
            _type = [@(![_type boolValue]) stringValue];
            switch (popUpType) {
                case None_Type:
                    break;
                case Accompany_Type:
                    [self showAcompanyInfoView];
                    break;
                case Preview_Type:
                    // go to webview
                    break;
                case Share_Type:
                    [self showShareView];
                    break;
                default:
                    break;
            }
            // restore popUpType
            popUpType = None_Type;
        }];
    } fail:^(id result) {
        NSString *title;
        if ([_type intValue] == 0) {
            title = @"同步失败";
        } else if ([_type intValue] == 1) {
            title = @"取消同步失败";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _info.supplierProductsArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SupplierDetailTopImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SupplierDetailTopImageTableViewCell" forIndexPath:indexPath];
        [cell setCellContentWithSupplierInfo:_info];
        return cell;
    }
    
    TourListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TourListTableViewCell" forIndexPath:indexPath];
    SupplierProduct *curProduct = _info.supplierProductsArray[indexPath.row-1];
    [cell setCellContentWithSupplierProduct:curProduct];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 200.f;
    }
    return 138.f;
}

#pragma mark - TourListTableViewCell_Delegate
- (void)supportClickWithShareButton
{
    popUpType = Share_Type;
    
    if ([_type intValue] == 1) {
        // go to share
        [self showShareView];
    } else if ([_type intValue] == 0){
        [_yesOrNoView setYesOrNoViewWithIntroductionString:@"产品同步到我的微店后，便可直接转发产品详情页给游客浏览！\n（产品详情页将显示您的联系信息）" confirmString:@"现在是否要同步产品到我的微店？"];
        [self showYesOrNoView];
    }
}
- (void)supportClickWithPreviewButton
{
    popUpType = Preview_Type;

    if ([_type intValue] == 1) {
        // go to preview webview
        // ...
    } else if ([_type intValue] == 0){
        [_yesOrNoView setYesOrNoViewWithIntroductionString:@"产品同步到我的微店后，便可直接预览产品详情页！\n（页面将显示您的联系信息）" confirmString:@"现在是否要同步产品到我的微店？"];
        [self showYesOrNoView];
    }
}
- (void)supportClickWithAccompanyButton
{
    popUpType = Accompany_Type;
    [self showAcompanyInfoView];
}

#pragma mark - YesOrNoViewDelegate
- (void)supportClickWithNo
{
    [self dismissYesOrNoView];
}

- (void)supportClickWithYes
{
    [self dismissYesOrNoView];
    // 未登录
    if (![[Global sharedGlobal] userInfo].companyId || ![[Global sharedGlobal] userInfo].staffId) {
        
        // go to login page
        // ...
        return;
    }
    
    // 未完成资料，合并后要修改
    if ([[Global sharedGlobal] userInfo]) {
        // go to open micro shop
        SetShopNameViewController *setName = [[SetShopNameViewController alloc] init];
        [self.navigationController pushViewController:setName animated:YES];
        return;
    }
    
    //同步
    [self syncOrCancelSyncMySupplier];
}

#pragma mark - private

// YesOrNoView
- (void)dismissYesOrNoView
{
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_yesOrNoView setFrame:CGRectOffset(_yesOrNoView.frame, 0, _yesOrNoView.frame.size.height)];
    }];
}
- (void)showYesOrNoView
{
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 1;
        [_yesOrNoView setFrame:CGRectOffset(_yesOrNoView.frame, 0, - _yesOrNoView.frame.size.height)];
    }];
}

// shareView
- (void)dismissShareView
{
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_shareView setFrame:CGRectOffset(_shareView.frame, 0, _shareView.frame.size.height)];
    }];
}
- (void)showShareView
{
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 1;
        [_shareView setFrame:CGRectOffset(_shareView.frame, 0, -_shareView.frame.size.height)];
    }];
}

// accompanyInfoView
- (void)dismissAccompanyInfoView
{
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_accompanyInfoView setFrame:CGRectOffset(_accompanyInfoView.frame, 0, _accompanyInfoView.frame.size.height)];
    }];
}
- (void)showAcompanyInfoView
{
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 1;
        [_accompanyInfoView setFrame:CGRectOffset(_accompanyInfoView.frame, 0, -_accompanyInfoView.frame.size.height)];
    }];
}



- (void)switchButtonStatus
{
    if ([_type intValue] == 0) {
        [_addToOrRemoveFromMyShopButton setTitle:@"同步到我的微店" forState:UIControlStateNormal];
    } else if ([_type intValue] == 1){
        [_addToOrRemoveFromMyShopButton setTitle:@"取消同步到微店" forState:UIControlStateNormal];
    }
}

@end
