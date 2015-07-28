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
#import "YesOrNoView.h"
#import "ShareView.h"
#import "AccompanyInfoView.h"
#import "TourWebPreviewViewController.h"
#import "SetShopNameViewController.h"
#import "SetShopContactViewController.h"
#import "AccompanyInfoViewController.h"
#import "TourDetailTableViewController.h"
#import "UMSocialWechatHandler.h"

@interface SupplierDetailViewController()<UITableViewDataSource, UITableViewDelegate, YesOrNoViewDelegate, TourListTableViewCell_Delegate, ShareViewDelegate, AccompanyInfoView_Delegate, UIScrollViewDelegate>
{
    NSInteger pageNum;
    PopUpViewType popUpType;
    SupplierProduct *selectedProduct;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *addToOrRemoveFromMyShopButton;

@property (strong, nonatomic) YesOrNoView *yesOrNoView;
@property (strong, nonatomic) ShareView *shareView;
@property (strong, nonatomic) AccompanyInfoView *accompanyInfoView;

@property (strong, nonatomic) UIControl *darkMask;
@property (copy, nonatomic) NSString *isMinetype;


- (IBAction)addToOrRemoveFromMyShopButtonClicked:(id)sender;

@end

@implementation SupplierDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _addToOrRemoveFromMyShopButton.layer.cornerRadius = 5.f;
    
    self.title = @"供应商信息";
    [_tableView registerNib:[UINib nibWithNibName:@"TourListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TourListTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SupplierDetailTopImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"SupplierDetailTopImageTableViewCell"];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    UIScrollView *scroll = (UIScrollView *)_tableView;
    scroll.delegate = self;
    
    pageNum = 1;
    popUpType = None_Type;
    
    _darkMask = [[UIControl alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_darkMask addTarget:self action:@selector(hidePopUpViews) forControlEvents:UIControlEventTouchUpInside];
    _darkMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _darkMask.alpha = 0;// initally transparent
    [self.view addSubview:_darkMask];
    
    self.isMinetype = _info.supplierIsMy;
    
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [self getSupplierDetail];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    if ([[Global sharedGlobal] networkAvailability] == NO) {
        [self networkUnavailable];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark - Override
- (void)networkUnavailable
{
    CGFloat yOrigin = 64.f;
    [[NoNetworkView sharedNoNetworkView] showWithYOrigin:yOrigin height:SCREEN_HEIGHT - yOrigin];
}

- (void)networkAvailable
{
    [super networkAvailable];
}

- (void)setIsMinetype:(NSString *)type
{
    _isMinetype = type;
    if (!_isMinetype || [_isMinetype intValue] == 1) {
        _isMinetype = @"1";
        [_addToOrRemoveFromMyShopButton setTitle:@"同步到我的微店" forState:UIControlStateNormal];
    } else {
        _isMinetype = @"0";
        [_addToOrRemoveFromMyShopButton setTitle:@"取消同步到微店" forState:UIControlStateNormal];
    }
}

- (void)hidePopUpViews
{
    [self hideAccompanyInfoViewWithCompletionBlock:nil];
    [self hideYesOrNoView];
    [self hideShareView];
    _darkMask.alpha = 0;
}

- (IBAction)addToOrRemoveFromMyShopButtonClicked:(id)sender
{
    if ([self ifNotLogin] == YES) {
        if ([self ifShopNameNotSet] == YES) {
            if ([self ifShopContactNotSet] == YES) {
                [self syncOrCancelSyncMySupplier];
            }
        }
    }
}

#pragma mark - HTTP
- (void)getSupplierDetail
{
    if ([UserModel companyId] && [UserModel staffId]) {
        [HTTPTool getSupplierDetailWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] supplierId:_info.supplierId pageNum:@(pageNum) isMy:_isMinetype lineClass:_lineClass lineType:_lineType success:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            [[Global sharedGlobal] codeHudWithObject:result[@"RS100016"] succeed:^{
                SupplierInfo *tempInfo = [[SupplierInfo alloc] initWithDict:result[@"RS100016"]];

                if ([tempInfo.supplierProductsArray count] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有更多了" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                    [alert show];
                    return ;
                }
                
                if (_info.supplierProductsArray.count == 0) {
                    _info = tempInfo;
                    [_tableView reloadData];
                    pageNum++;
                    return ;
                }
                
                NSMutableArray *tempProducts = [_info.supplierProductsArray mutableCopy];
                [tempProducts addObjectsFromArray:tempInfo.supplierProductsArray];
                _info.supplierProductsArray = [tempProducts mutableCopy];
                [_tableView reloadData];
                pageNum++;
            }];
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    } else {
        [HTTPTool getSupplierDetailWithSupplierId:_info.supplierId pageNum:@(pageNum) isMy:_info.supplierIsMy lineClass:_lineClass lineType:_lineType success:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            [[Global sharedGlobal] codeHudWithObject:result[@"RS100015"] succeed:^{
                SupplierInfo *tempInfo = [[SupplierInfo alloc] initWithDict:result[@"RS100015"]];
                
                if ([tempInfo.supplierProductsArray count] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有更多了" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                    [alert show];
                    return ;
                }
                
                if (_info.supplierProductsArray.count == 0) {
                    _info = tempInfo;
                    [_tableView reloadData];
                    pageNum++;
                    return ;
                }
                
                NSMutableArray *tempProducts = [_info.supplierProductsArray mutableCopy];
                [tempProducts addObjectsFromArray:tempInfo.supplierProductsArray];
                _info.supplierProductsArray = [tempProducts mutableCopy];
                [_tableView reloadData];
                pageNum++;
            }];
        } fail:^(id result) {
            [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
}

- (void)syncOrCancelSyncMySupplier
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];

    [HTTPTool syncOrCancelSyncMySupplierWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] supplierId:_info.supplierId supplierName:_info.supplierName supplierBrand:_info.supplierBrand type:[@(![_isMinetype boolValue]) stringValue] success:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100017"] succeed:^{
            self.isMinetype = [@(![_isMinetype boolValue]) stringValue];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MY_SHOP_HAS_UPDATED object:self];
            
            switch (popUpType) {
                case None_Type:
                    break;
                case Accompany_Type:
                    [self showAcompanyInfoView];
                    break;
                case Preview_Type:
                    // go to webview
                    if (selectedProduct.productPreviewURL) {
                        TourWebPreviewViewController *web = [[TourWebPreviewViewController alloc] init];
                        web.tourURLString = selectedProduct.productPreviewURL;
                        [self.navigationController pushViewController:web animated:YES];
                    }
                    break;
                case Share_Type:
                    [self showShareView];
                    break;
                default:
                    break;
            }
            // restore initial state
            popUpType = None_Type;
        }];
    } fail:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        NSString *title;
        if ([_isMinetype intValue] == 1) {
            title = @"同步失败";
        } else if ([_isMinetype intValue] == 0) {
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
    cell.delegate = self;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        TourDetailTableViewController *detail = [[TourDetailTableViewController alloc] init];
        SupplierProduct *curProduct = _info.supplierProductsArray[indexPath.row-1];
        detail.product = curProduct;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - TourListTableViewCell_Delegate
- (void)supportClickWithShareButtonWithProduct:(SupplierProduct *)product
{
    if ([self ifNotLogin] == YES) {
        if ([self ifShopNameNotSet] == YES) {
            if ([self ifShopContactNotSet] == YES) {
                popUpType = Share_Type;
                selectedProduct = product;
                
                // 已同步
                if ([_isMinetype intValue] == 0) {
                    // go to share
                    [self showShareView];
                    // 未同步
                } else if ([_isMinetype intValue] == 1){
                    [self showYesOrNoViewWithIntroductionString:@"产品同步到我的微店后，便可直接转发产品详情页给游客浏览！\n（产品详情页将显示您的联系信息）" confirmString:@"现在是否要同步产品到我的微店？"];
                }
            }
        }
    }
}
- (void)supportClickWithPreviewButtonWithProduct:(SupplierProduct *)product
{
    if ([self ifNotLogin] == YES) {
        if ([self ifShopNameNotSet] == YES) {
            if ([self ifShopContactNotSet] == YES) {
                popUpType = Preview_Type;
                selectedProduct = product;
                
                //已同步
                if ([_isMinetype intValue] == 0) {
                    // go to preview webview
                    
                    if (product.productPreviewURL) {
                        TourWebPreviewViewController *web = [[TourWebPreviewViewController alloc] init];
                        web.tourURLString = product.productPreviewURL;
                        [self.navigationController pushViewController:web animated:YES];
                        popUpType = None_Type;
                    }
                    //未同步
                } else if ([_isMinetype intValue] == 1){
                    [self showYesOrNoViewWithIntroductionString:@"产品同步到我的微店后，便可直接预览产品详情页！\n（页面将显示您的联系信息）" confirmString:@"现在是否要同步产品到我的微店？"];
                }
            }
        }
    }
}
- (void)supportClickWithAccompanyInfoWithProduct:(SupplierProduct *)product
{
    if ([self ifNotLogin] == YES) {
        if ([self ifShopNameNotSet] == YES) {
            if ([self ifShopContactNotSet] == YES) {
                popUpType = Accompany_Type;
                selectedProduct = product;
                
                [self setUpAccompanyInfoView];
                [self showAcompanyInfoView];
            }
        }
    }
}

#pragma mark - AccompanyInfoView_Delegate
- (void)supportClickWithMoreInstructions
{
    [self hideAccompanyInfoViewWithCompletionBlock:^{
        AccompanyInfoViewController *info = [[AccompanyInfoViewController alloc] initWithNibName:@"AccompanyInfoViewController" bundle:nil];
        info.product = selectedProduct;
        [self.navigationController pushViewController:info animated:YES];
    }];
}
- (void)supportClickWithPhoneCall
{
    [[Global sharedGlobal] callWithPhoneNumber:selectedProduct.productCompanyContactPhone];
    [self hideAccompanyInfoViewWithCompletionBlock:nil];
}
- (void)supportClickWithShortMessage
{
    [[Global sharedGlobal] sendShortTextWithPhoneNumber:selectedProduct.productCompanyContactPhone];
    [self hideAccompanyInfoViewWithCompletionBlock:nil];
}

#pragma mark - ShareViewDelegate
- (void)supportClickWithWeChatWithShareObject:(id)obj
{
    [self hideShareView];
    if ([obj isKindOfClass:[SupplierProduct class]]) {
        SupplierProduct *sharePrd = (SupplierProduct *)obj;
        NSString *shareURL = sharePrd.productShareURL;
        if (!shareURL) {
            shareURL = sharePrd.productPreviewURL;
            if (!shareURL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享和预览链接地址为空" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                return ;
            }
        }
        [[Global sharedGlobal] shareViaWeChatWithURLString:shareURL title:sharePrd.productTravelGoodsName content:sharePrd.productIntroduce image:nil location:nil presentedController:self shareType:Wechat_Share_Session];
    }
}

- (void)supportClickWithQQWithShareObject:(id)obj
{
    [self hideShareView];
    if ([obj isKindOfClass:[SupplierProduct class]]) {
        SupplierProduct *sharePrd = (SupplierProduct *)obj;
        NSString *shareURL = sharePrd.productShareURL;
        if (!shareURL) {
            shareURL = sharePrd.productPreviewURL;
            if (!shareURL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享和预览链接地址为空" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                return ;
            }
        }
        [[Global sharedGlobal] shareViaQQWithURLString:shareURL title:sharePrd.productTravelGoodsName content:sharePrd.productIntroduce image:nil location:nil presentedController:self shareType:QQ_Share_Session];
    }
}

- (void)supportClickWithQZoneWithShareObject:(id)obj
{
    [self hideShareView];
    if ([obj isKindOfClass:[SupplierProduct class]]) {
        SupplierProduct *sharePrd = (SupplierProduct *)obj;
        NSString *shareURL = sharePrd.productShareURL;
        if (!shareURL) {
            shareURL = sharePrd.productPreviewURL;
            if (!shareURL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享和预览链接地址为空" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                return ;
            }
        }
        [[Global sharedGlobal] shareViaQQWithURLString:shareURL title:sharePrd.productTravelGoodsName content:sharePrd.productIntroduce image:nil location:nil presentedController:self shareType:QQ_Share_QZone];
    }
}

- (void)supportClickWithShortMessageWithShareObject:(id)obj
{
    [self hideShareView];
    if ([obj isKindOfClass:[SupplierProduct class]]) {
        SupplierProduct *sharePrd = (SupplierProduct *)obj;
        NSString *shareURL = sharePrd.productShareURL;
        if (!shareURL) {
            shareURL = sharePrd.productPreviewURL;
            if (!shareURL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享和预览链接地址为空" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                return ;
            }
        }
        [[Global sharedGlobal] shareViaSMSWithContent:[NSString stringWithFormat:@"%@\n%@", sharePrd.productTravelGoodsName, shareURL] presentedController:self];
    }
}

- (void)supportClickWithSendingToComputerWithShareObject:(id)obj
{
    [self supportClickWithQQWithShareObject:obj];
}

- (void)supportClickWithYiXinWithShareObject:(id)obj
{
    [self hideShareView];
    if ([obj isKindOfClass:[SupplierProduct class]]) {
        SupplierProduct *sharePrd = (SupplierProduct *)obj;
        NSString *shareURL = sharePrd.productShareURL;
        if (!shareURL) {
            shareURL = sharePrd.productPreviewURL;
            if (!shareURL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享和预览链接地址为空" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                return ;
            }
        }
        [[Global sharedGlobal] shareViaYiXinWithURLString:shareURL content:sharePrd.productIntroduce image:nil location:nil presentedController:self shareType:YiXin_Share_Session];
    }
}

- (void)supportClickWithWeiboWithShareObject:(id)obj
{
    [self hideShareView];
    if ([obj isKindOfClass:[SupplierProduct class]]) {
        SupplierProduct *sharePrd = (SupplierProduct *)obj;
        NSString *shareURL = sharePrd.productShareURL;
        if (!shareURL) {
            shareURL = sharePrd.productPreviewURL;
            if (!shareURL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享和预览链接地址为空" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                return ;
            }
        }
        [[Global sharedGlobal] shareViaSinaWithURLString:shareURL content:sharePrd.productIntroduce image:nil location:nil presentedController:self];
    }
}

- (void)supportClickWithFriendsWithShareObject:(id)obj
{
    [self hideShareView];
    if ([obj isKindOfClass:[SupplierProduct class]]) {
        SupplierProduct *sharePrd = (SupplierProduct *)obj;
        NSString *shareURL = sharePrd.productShareURL;
        if (!shareURL) {
            shareURL = sharePrd.productPreviewURL;
            if (!shareURL) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享和预览链接地址为空" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                return ;
            }
        }
        [[Global sharedGlobal] shareViaWeChatWithURLString:shareURL title:sharePrd.productTravelGoodsName content:sharePrd.productIntroduce image:nil location:nil presentedController:self shareType:Wechat_Share_Timeline];
    }
}

- (void)supportClickWithCancel
{
    [self hideShareView];
}

#pragma mark - YesOrNoViewDelegate
- (void)supportClickWithNo
{
    [self hideYesOrNoView];
}

- (void)supportClickWithYes
{
    [self hideYesOrNoView];
    
    if ([self ifNotLogin] == YES) {
        if ([self ifShopNameNotSet] == YES) {
            if ([self ifShopContactNotSet] == YES) {
                //同步
                [self syncOrCancelSyncMySupplier];
            }
        }
    }
}

#pragma mark - private
// set up accessory views
- (void)setUpAccompanyInfoView {
    if (!_accompanyInfoView) {
        _accompanyInfoView = [[NSBundle mainBundle] loadNibNamed:@"AccompanyInfoView" owner:nil options:nil][0];
        _accompanyInfoView.delegate = self;
        [self.view addSubview:_accompanyInfoView];
    }
    
    CGFloat viewHeight = [_accompanyInfoView accompanyInfoViewHeightWithSupplierName:selectedProduct.productCompanyName productName:selectedProduct.productTravelGoodsName price:selectedProduct.productMarketPrice instructions:selectedProduct.productPeerNotice];
    [_accompanyInfoView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, viewHeight)];
}
- (void)setUpShareView {
    if (!_shareView) {
        _shareView = [[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:nil options:nil][0];
        _shareView.delegate = self;
        [self.view addSubview:_shareView];
    }
    CGFloat viewHeight = [_shareView shareViewHeightWithShareObject:selectedProduct];
    [_shareView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, viewHeight)];
}
- (void)setUpYesOrNoViewWithIntroductionString:(NSString *)introduction confirmString:(NSString *)confirm {
    if (!_yesOrNoView) {
        _yesOrNoView = [[NSBundle mainBundle] loadNibNamed:@"YesOrNoView" owner:nil options:nil][0];
        [_yesOrNoView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _yesOrNoView.containerView.frame.size.height)];
        _yesOrNoView.delegate = self;
        [self.view addSubview:_yesOrNoView];
    }
    [_yesOrNoView setYesOrNoViewWithIntroductionString:introduction confirmString:confirm];
}

// hide/show accessory views
- (void)hideYesOrNoView {
    if (_yesOrNoView.frame.origin.y == self.view.frame.size.height) {
        return;
    }
    self.navigationController.navigationBar.alpha = 1;
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_yesOrNoView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _yesOrNoView.frame.size.height)];
    }];
}
- (void)showYesOrNoViewWithIntroductionString:(NSString *)introduction confirmString:(NSString *)confirm {
    [self setUpYesOrNoViewWithIntroductionString:introduction confirmString:confirm];
    self.navigationController.navigationBar.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 1;
        [_yesOrNoView setFrame:CGRectMake(0, self.view.frame.size.height-_yesOrNoView.frame.size.height, SCREEN_WIDTH, _yesOrNoView.frame.size.height)];
    }];
}

- (void)hideShareView {
    if (_shareView.frame.origin.y == self.view.frame.size.height) {
        return;
    }
    popUpType = None_Type;
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_shareView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _shareView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (finished) {
            self.navigationController.navigationBar.alpha = 1;
        }
    }];
}
- (void)showShareView {
    [self setUpShareView];
    self.navigationController.navigationBar.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 1;
        [_shareView setFrame:CGRectMake(0, self.view.frame.size.height-_shareView.frame.size.height, SCREEN_WIDTH, _shareView.frame.size.height)];
    }];
}

- (void)hideAccompanyInfoViewWithCompletionBlock:(void (^)())block {
    if (_accompanyInfoView.frame.origin.y == self.view.frame.size.height) {
        return;
    }
    
    popUpType = None_Type;
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_accompanyInfoView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, _accompanyInfoView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (finished) {
            self.navigationController.navigationBar.alpha = 1;
            if (block) {
                block();
            }
        }
    }];
}
- (void)showAcompanyInfoView {
    [self setUpAccompanyInfoView];
    self.navigationController.navigationBar.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 1;
        [_accompanyInfoView setFrame:CGRectMake(0, self.view.frame.size.height-_accompanyInfoView.frame.size.height, SCREEN_WIDTH, _accompanyInfoView.frame.size.height)];
    }];
}

// evaluate user status
- (BOOL)ifNotLogin {
    if (![UserModel companyId] || ![UserModel staffId]) {
        // go to login page
        [self presentViewController:[[Global sharedGlobal] loginNavViewControllerFromSb] animated:YES completion:nil];
        return NO;
    }
    return YES;
}
- (BOOL)ifShopNameNotSet {
    if (![UserModel staffDepartmentName]) {
        SetShopNameViewController *setName = [[SetShopNameViewController alloc] init];
        [self.navigationController pushViewController:setName animated:YES];
        return NO;
    }
    return YES;
}
- (BOOL)ifShopContactNotSet {
    if (![UserModel staffRealName]) {
        SetShopContactViewController *setContact = [[SetShopContactViewController alloc] init];
        [self.navigationController pushViewController:setContact animated:YES];
        return NO;
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        CGFloat delta = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
        if (fabs(delta) < 10) {
            [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
            [self getSupplierDetail];
        }
    }
}


@end
