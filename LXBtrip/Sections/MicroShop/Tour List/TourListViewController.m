//
//  TourListViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/31.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourListViewController.h"
#import "TourListTableViewCell.h"
#import "TourListCell_Destination.h"
#import "TourListCell_WalkType.h"
#import "AppMacro.h"
#import "AccompanyInfoViewController.h"
#import "AccompanyInfoView.h"
#import "ShareView.h"
#import "TourWebPreviewViewController.h"
#import "TourDetailTableViewController.h"

@interface TourListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, TourListTableViewCell_Delegate, UIScrollViewDelegate, AccompanyInfoView_Delegate, ShareViewDelegate>
{
    NSString *startCity;
    NSString *endCity;
    NSString *lineName;
    NSString *walkType;
    NSInteger pageNum;
    
    NSMutableArray *citiesArray;
    NSMutableArray *productsArray;
    NSArray *walkTypesArray;
    
    SupplierProduct *selectedProduct;
    
    TourListCell_Destination *selectedCell_Destination;
    TourListCell_WalkType *selectedCell_WalkType;
    
    BOOL isRefreshing;
}


@property (strong, nonatomic) IBOutlet UIButton *locationButton;

@property (strong, nonatomic) IBOutlet UIButton *destinationButton;
@property (strong, nonatomic) IBOutlet UIButton *walkTypeButton;

- (IBAction)locationButtonClicked:(id)sender;
- (IBAction)backButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)searchButtonClicked:(id)sender;

- (IBAction)destinationButtonClicked:(id)sender;
- (IBAction)walkTypeButtonClicked:(id)sender;

- (IBAction)toTopButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) IBOutlet UITableView *destinationTableView;
@property (strong, nonatomic) IBOutlet UITableView *walkTypeTableView;

@property (strong, nonatomic) IBOutlet UIControl *darkMask;

@property (strong, nonatomic) IBOutlet UIView *noProductView;

@property (nonatomic, strong) AccompanyInfoView *accompanyInfoView;
@property (nonatomic, strong) ShareView *shareView;

@property (nonatomic, copy) SupplierInfo *info;

@end

@implementation TourListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_darkMask addTarget:self action:@selector(hidePopUpViews) forControlEvents:UIControlEventTouchUpInside];
    _darkMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _darkMask.alpha = 0;// initally transparent
    
    _searchButton.layer.cornerRadius = 5.f;
    [_searchBar setImage:ImageNamed(@"search") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    [_mainTableView registerNib:[UINib nibWithNibName:@"TourListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TourListTableViewCell"];
    
    [_destinationTableView registerNib:[UINib nibWithNibName:@"TourListCell_Destination" bundle:nil] forCellReuseIdentifier:@"TourListCell_Destination"];
    
    [_walkTypeTableView registerNib:[UINib nibWithNibName:@"TourListCell_WalkType" bundle:nil] forCellReuseIdentifier:@"TourListCell_WalkType"];
    
    UIScrollView *scroll = (UIScrollView *)_mainTableView;
    scroll.delegate = self;

    walkTypesArray = @[@"不限", @"跟团游", @"自由行", @"半自助"];
    
    _noProductView.hidden = YES;
    pageNum = 1;
    [self setWalkTypeTableViewHidden:YES];
    [self setDestinationCityTableViewHidden:YES];
    
    // --TEST--
    isRefreshing = NO;
    startCity = @"西安";
    [self getTourList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)hidePopUpViews
{
    [self setDestinationCityTableViewHidden:YES];
    [self setWalkTypeTableViewHidden:YES];
    [self hideAccompanyInfoViewWithCompletionBlock:nil];
    [self hideShareViewWithCompletionBlock:nil];
    _darkMask.alpha = 0;
}

- (void)getTourList
{
    [[CustomActivityIndicator sharedActivityIndicator] startSynchAnimating];
    [HTTPTool getTourListWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] templateId:_templateId customId:_customId startCity:startCity endCity:endCity walkType:walkType lineName:lineName pageNum:@(pageNum) success:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        
        if (isRefreshing == YES) {
            _info = nil;
            [productsArray removeAllObjects];
            isRefreshing = NO;
        }
        id data = result[@"RS100007"];
        [[Global sharedGlobal] codeHudWithObject:data succeed:^{
            SupplierInfo *info = [[SupplierInfo alloc] initWithDict:data];
            if (!_info) {
                _info = info;
                self.title = _info.supplierCustomName;
                if (!endCity) {
                    citiesArray = [[_info.supplierEndCity componentsSeparatedByString:@"#"] mutableCopy];
                    [_destinationTableView reloadData];
                }
                productsArray = [info.supplierProductsArray mutableCopy];
                if (productsArray.count == 0) {
                    _noProductView.hidden = NO;
                    return ;
                } else {
                    _noProductView.hidden = YES;
                }
                
                [_mainTableView reloadData];
                pageNum++;
                return ;
            }
            
            if (info.supplierProductsArray.count == 0) {
                return ;
            }
            [productsArray addObjectsFromArray:info.supplierProductsArray];
            _info.supplierProductsArray = [productsArray mutableCopy];
            [_mainTableView reloadData];
            pageNum++;
        }];
    } fail:^(id result) {
        [[CustomActivityIndicator sharedActivityIndicator] stopSynchAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}


#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _mainTableView) {
        return _info.supplierProductsArray.count;
    }
    
    if (tableView == _walkTypeTableView) {
        return 4;
    }
    
    if (tableView == _destinationTableView) {
        return citiesArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mainTableView) {
        TourListTableViewCell *cell = (TourListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TourListTableViewCell" forIndexPath:indexPath];
        [cell setCellContentWithSupplierProduct:_info.supplierProductsArray[indexPath.row]];
        cell.delegate = self;
        return cell;
    }
    
    if (tableView == _walkTypeTableView) {
        TourListCell_WalkType *cell = (TourListCell_WalkType *)[tableView dequeueReusableCellWithIdentifier:@"TourListCell_WalkType" forIndexPath:indexPath];
        [cell setCellContentWithWalkType:walkTypesArray[indexPath.row]];
        return cell;
    }
    
    TourListCell_Destination *cell = (TourListCell_Destination *)[tableView dequeueReusableCellWithIdentifier:@"TourListCell_Destination" forIndexPath:indexPath];
    [cell setCellContentWithDestination:citiesArray[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mainTableView) {
        return 138.f;
    }
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mainTableView) {
        TourDetailTableViewController *detail = [[TourDetailTableViewController alloc] init];
        detail.product = productsArray[indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    if (tableView == _destinationTableView) {
        [selectedCell_Destination setSelected:NO];
        selectedCell_Destination = (TourListCell_Destination *)[_destinationTableView cellForRowAtIndexPath:indexPath];
        [selectedCell_Destination setSelected:YES];
        
        endCity = citiesArray[indexPath.row];
        if (indexPath.row == 0) {
            [_destinationButton setTitle:@"目的地城市" forState:UIControlStateNormal];
        } else {
            [_destinationButton setTitle:endCity forState:UIControlStateNormal];
        }
        [self hidePopUpViews];
        
        pageNum = 1;
        isRefreshing = YES;
        [self getTourList];
    }
    
    if (tableView == _walkTypeTableView) {
        [selectedCell_WalkType setSelected:NO];
        selectedCell_WalkType = (TourListCell_WalkType *)[_walkTypeTableView cellForRowAtIndexPath:indexPath];
        [selectedCell_WalkType setSelected:YES];
        
        WalkType walk = indexPath.row - 1;
        switch (walk) {
            case All_Kinds:
            {
                walkType = nil;
                [_walkTypeButton setTitle:@"出行方式" forState:UIControlStateNormal];
            }
                break;
            case Follow_Group:
            {
                walkType = @"0";
                [_walkTypeButton setTitle:@"跟团游" forState:UIControlStateNormal];
            }
                break;
            case Free_Run:
            {
                walkType = @"1";
                [_walkTypeButton setTitle:@"自由行" forState:UIControlStateNormal];
            }
                break;
            case Half_Free:
            {
                walkType = @"2";
                [_walkTypeButton setTitle:@"半自助" forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        
        [self hidePopUpViews];
        
        pageNum = 1;
        isRefreshing = YES;
        [self getTourList];
    }
}

- (IBAction)locationButtonClicked:(id)sender {
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)searchButtonClicked:(id)sender {
}
- (IBAction)destinationButtonClicked:(id)sender {
    [self setWalkTypeTableViewHidden:YES];
    if (_destinationTableView.hidden == YES) {
        [self setDestinationCityTableViewHidden:NO];
        _darkMask.alpha = 1.0;
        if (!selectedCell_Destination) {
            selectedCell_Destination = (TourListCell_Destination *)[_destinationTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [selectedCell_Destination setSelected:YES];
        }
    } else {
        [self setDestinationCityTableViewHidden:YES];
        _darkMask.alpha = 0;
    }
}

- (IBAction)walkTypeButtonClicked:(id)sender {
    [self setDestinationCityTableViewHidden:YES];
    if (_walkTypeTableView.hidden == YES) {
        [self setWalkTypeTableViewHidden:NO];
        _darkMask.alpha = 1.0;
        if (!selectedCell_WalkType) {
            selectedCell_WalkType = (TourListCell_WalkType *)[_walkTypeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [selectedCell_WalkType setSelected:YES];
        }
    } else {
        [self setWalkTypeTableViewHidden:YES];
        _darkMask.alpha = 0;
    }
}

- (IBAction)toTopButtonClicked:(id)sender {
    [_mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - TourListTableViewCell_Delegate
- (void)supportClickWithShareButtonWithProduct:(SupplierProduct *)product
{
    selectedProduct = product;
    if (!_shareView) {
        _shareView = [[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:nil options:nil][0];
        CGFloat viewHeight = [_shareView shareViewHeightWithShareObject:product];
        [_shareView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, viewHeight)];
        _shareView.delegate = self;
        [self.view addSubview:_shareView];
    }
    
    [self showShareView];

}
- (void)supportClickWithPreviewButtonWithProduct:(SupplierProduct *)product
{
    selectedProduct = product;
    if (selectedProduct.productPreviewURL) {
        TourWebPreviewViewController *web = [[TourWebPreviewViewController alloc] init];
        web.tourURLString = selectedProduct.productPreviewURL;
        [self.navigationController pushViewController:web animated:YES];
    }
}
- (void)supportClickWithAccompanyInfoWithProduct:(SupplierProduct *)product
{
    selectedProduct = product;
    if (!_accompanyInfoView) {
        _accompanyInfoView = [[NSBundle mainBundle] loadNibNamed:@"AccompanyInfoView" owner:nil options:nil][0];
        CGFloat viewHeight = [_accompanyInfoView accompanyInfoViewHeightWithSupplierName:product.productCompanyName introduce:product.productIntroduce price:product.productMarketPrice instructions:product.productPeerNotice];
        
         [_accompanyInfoView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, viewHeight)];
        _accompanyInfoView.delegate = self;
         [self.view addSubview:_accompanyInfoView];
    }
    [self showAccompanyInfoView];
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", selectedProduct.productCompanyContactPhone]]];
}
- (void)supportClickWithShortMessage
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", selectedProduct.productCompanyContactPhone]]];
}

#pragma mark - ShareViewDelegate
- (void)supportClickWithWeChatWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithQQWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithQZoneWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithShortMessageWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithSendingToComputerWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithYiXinWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithWeiboWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithFriendsWithShareObject:(id)obj
{
    [self hideShareViewWithCompletionBlock:nil];
}

- (void)supportClickWithCancel
{
    [self hideShareViewWithCompletionBlock:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _mainTableView) {
        CGFloat delta = scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height;
        if (fabs(delta) < 10) {
            [self getTourList];
        }
    }
}

#pragma mark - Private methods
- (void)setDestinationCityTableViewHidden:(BOOL)hidden
{
    _destinationTableView.hidden = hidden;
}

- (void)setWalkTypeTableViewHidden:(BOOL)hidden
{
    _walkTypeTableView.hidden = hidden;
}

// show/hide accompanyInfoView
- (void)hideAccompanyInfoViewWithCompletionBlock:(void (^)())block
{
    if (_accompanyInfoView.frame.origin.y == SCREEN_HEIGHT) {
        return;
    }
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_accompanyInfoView setFrame:CGRectOffset(_accompanyInfoView.frame, 0, _accompanyInfoView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view insertSubview:_darkMask aboveSubview:_mainTableView];
            if (block) {
                block();
            }
        }
    }];
}

- (void)showAccompanyInfoView
{
    [self.view insertSubview:_darkMask aboveSubview:_walkTypeTableView];
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 1;
        [_accompanyInfoView setFrame:CGRectOffset(_accompanyInfoView.frame, 0, -_accompanyInfoView.frame.size.height)];
    }];
}

// show/hide ShareView
- (void)showShareView
{
    [self.view insertSubview:_darkMask aboveSubview:_walkTypeTableView];
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 1;
        [_shareView setFrame:CGRectOffset(_shareView.frame, 0, -_shareView.frame.size.height)];
    }];
}

- (void)hideShareViewWithCompletionBlock:(void (^)())block
{
    if (_shareView.frame.origin.y == SCREEN_HEIGHT) {
        return;
    }
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 0;
        [_shareView setFrame:CGRectOffset(_shareView.frame, 0, _shareView.frame.size.height)];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view insertSubview:_darkMask aboveSubview:_mainTableView];
            if (block) {
                block();
            }
        }
    }];
}

@end
