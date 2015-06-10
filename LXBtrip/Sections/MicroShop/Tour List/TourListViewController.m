//
//  TourListViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/31.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "TourListViewController.h"
#import "TourListTableViewCell.h"
#import "TourListCell_Destination_Left.h"
#import "TourListCell_Destination_Right.h"
#import "TourListCell_WalkType.h"
#import "AppMacro.h"
#import "AccompanyInfoViewController.h"
#import "AccompanyInfoView.h"

@interface TourListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, TourListTableViewCell_Delegate, UIScrollViewDelegate, AccompanyInfoView_Delegate>
{
    NSString *startCity;
    NSString *endCity;
    NSNumber *dayNum;
    NSString *lineName;
    NSInteger pageNum;
    
    NSArray *cityCategoriesArray;
    NSMutableArray *innerCitiesArray;
    NSMutableArray *outerCitiesArray;
    NSMutableArray *curCitiesArray;
    NSMutableArray *productsArray;
    NSArray *walkTypesArray;
    
    SupplierProduct *selectedProduct;
}

@property (strong, nonatomic) IBOutlet UIButton *locationButton;
- (IBAction)locationButtonClicked:(id)sender;
- (IBAction)backButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)searchButtonClicked:(id)sender;

- (IBAction)destinationButtonClicked:(id)sender;
- (IBAction)walkTypeButtonClicked:(id)sender;

- (IBAction)toTopButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) IBOutlet UITableView *leftTableView_EndCity;
@property (strong, nonatomic) IBOutlet UITableView *rightTableView_EndCity;
@property (strong, nonatomic) IBOutlet UITableView *walkTableView;

@property (strong, nonatomic) IBOutlet UIControl *darkMask;
@property (nonatomic, strong) AccompanyInfoView *accompanyInfoView;

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
    
    [_leftTableView_EndCity registerNib:[UINib nibWithNibName:@"TourListCell_Destination_Left" bundle:nil] forCellReuseIdentifier:@"TourListCell_Destination_Left"];
    [_rightTableView_EndCity registerNib:[UINib nibWithNibName:@"TourListCell_Destination_Right" bundle:nil] forCellReuseIdentifier:@"TourListCell_Destination_Right"];
    _leftTableView_EndCity.backgroundColor = [UIColor whiteColor];
    _rightTableView_EndCity.backgroundColor = BG_F5F5F5;
    
    [_walkTableView registerNib:[UINib nibWithNibName:@"TourListCell_WalkType" bundle:nil] forCellReuseIdentifier:@"TourListCell_WalkType"];
    
    UIScrollView *scroll = (UIScrollView *)_mainTableView;
    scroll.delegate = self;

    cityCategoriesArray = @[@"国内", @"国外"];
    walkTypesArray = @[@"不限", @"跟团游", @"自由行", @"半自助"];
    
    pageNum = 0;
    [self setWalkTypeTableViewHidden:YES];
    [self setDestinationCityTableViewHidden:YES];
    
    // --TEST--
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
    [self hideAccompanyInfoView];
    _darkMask.alpha = 0;
}

- (void)getTourList
{
    [HTTPTool getTourListWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] templateId:_templateId customId:_customId startCity:startCity endCity:endCity dayNum:dayNum lineName:lineName pageNum:@(pageNum) success:^(id result) {
        id data = result[@"RS100007"];
        [[Global sharedGlobal] codeHudWithObject:data succeed:^{
            NSLog(@"pageNum: --- %ld", (long)pageNum);
            NSLog(@"_info.supplierProductsArray.count:------\n%lu", (unsigned long)_info.supplierProductsArray.count);

            SupplierInfo *info = [[SupplierInfo alloc] initWithDict:data];
            if (!_info) {
                _info = info;
                self.title = _info.supplierCustomName;
                innerCitiesArray = [[_info.supplierInnerEndCity componentsSeparatedByString:@"#"] mutableCopy];
                outerCitiesArray = [[_info.supplierOuterEndCity componentsSeparatedByString:@"#"] mutableCopy];
                curCitiesArray = [innerCitiesArray copy];
                productsArray = [info.supplierProductsArray mutableCopy];
                [_mainTableView reloadData];
                [_rightTableView_EndCity reloadData];
                pageNum++;
                return ;
            }
            
            if (info.supplierProductsArray.count == 0) {
                return ;
            }
            [productsArray addObjectsFromArray:info.supplierProductsArray];
            _info.supplierProductsArray = [productsArray mutableCopy];
            [_mainTableView reloadData];
            [_rightTableView_EndCity reloadData];
            pageNum++;
        }];
    } fail:^(id result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _mainTableView) {
        return _info.supplierProductsArray.count;
    }
    
    if (tableView == _walkTableView) {
        return 4;
    }
    
    if (tableView == _leftTableView_EndCity) {
        return 2;
    }
    
    if (tableView == _rightTableView_EndCity) {
        return curCitiesArray.count;
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
    
    if (tableView == _walkTableView) {
        TourListCell_WalkType *cell = (TourListCell_WalkType *)[tableView dequeueReusableCellWithIdentifier:@"TourListCell_WalkType" forIndexPath:indexPath];
        UIColor *textColor;
        if (indexPath.row == 0) {
            textColor = TEXT_4CA5FF;
        } else {
            textColor = nil;
        }
        [cell setCellContentWithWalkType:walkTypesArray[indexPath.row] textColor:textColor];
        return cell;
    }
    
    if (tableView == _leftTableView_EndCity) {
        TourListCell_Destination_Left *cell = (TourListCell_Destination_Left *)[tableView dequeueReusableCellWithIdentifier:@"TourListCell_Destination_Left" forIndexPath:indexPath];
        [cell setCellContentWithDestination:cityCategoriesArray[indexPath.row]];
        UIView *selectBgView = [[UIView alloc] init];
        selectBgView.backgroundColor = BG_F5F5F5;
        cell.selectedBackgroundView = selectBgView;
        return cell;
    }
    
    TourListCell_Destination_Right *cell = (TourListCell_Destination_Right *)[tableView dequeueReusableCellWithIdentifier:@"TourListCell_Destination_Right" forIndexPath:indexPath];
    [cell setCellContentWithDestination:curCitiesArray[indexPath.row]];
    cell.backgroundColor = BG_F5F5F5;
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
    if (tableView == _leftTableView_EndCity) {
        if (indexPath.row == 0) {
            curCitiesArray = [innerCitiesArray copy];
        } else if (indexPath.row == 1) {
            curCitiesArray = [outerCitiesArray copy];
        }
        [_rightTableView_EndCity reloadData];
    }
    
    if (tableView == _rightTableView_EndCity) {
        endCity = curCitiesArray[indexPath.row];
        pageNum = 0;
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
    if (_leftTableView_EndCity.hidden == YES) {
        _darkMask.alpha = 1.0;
        [self setDestinationCityTableViewHidden:NO];
        [self tableView:_leftTableView_EndCity didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    } else {
        _darkMask.alpha = 0;
        [self setDestinationCityTableViewHidden:YES];
    }
}

- (IBAction)walkTypeButtonClicked:(id)sender {
    [self setDestinationCityTableViewHidden:YES];
    if (_walkTableView.hidden == YES) {
        _darkMask.alpha = 1.0;
        [self setWalkTypeTableViewHidden:NO];
    } else {
        _darkMask.alpha = 0;
        [self setWalkTypeTableViewHidden:YES];
    }
}

- (IBAction)toTopButtonClicked:(id)sender {
    [_mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - TourListTableViewCell_Delegate
- (void)supportClickWithShareButton
{
    
}
- (void)supportClickWithPreviewButton
{
    
}
- (void)supportClickWithAccompanyInfoWithProduct:(SupplierProduct *)product
{
    selectedProduct = product;
    if (!_accompanyInfoView) {
        _accompanyInfoView = [[NSBundle mainBundle] loadNibNamed:@"AccompanyInfoView" owner:nil options:nil][0];
        CGFloat viewHeight = [_accompanyInfoView accompanyInfoViewHeightWithSupplierName:product.productCompanyName introduce:product.productIntroduce price:product.productMarketPrice instructions:product.productPeerNotice];
        
         [_accompanyInfoView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, viewHeight)];
        _accompanyInfoView.delegate = self;
         [self.view addSubview:_accompanyInfoView];
    }
    [self showAccompanyInfoView];
}

#pragma mark - AccompanyInfoView_Delegate
- (void)supportClickWithMoreInstructions
{
    AccompanyInfoViewController *info = [[AccompanyInfoViewController alloc] initWithNibName:@"AccompanyInfoViewController" bundle:nil];
    info.product = selectedProduct;
    [self.navigationController pushViewController:info animated:YES];
}
- (void)supportClickWithPhoneCall
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", selectedProduct.productCompanyContactPhone]]];
}
- (void)supportClickWithShortMessage
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", selectedProduct.productCompanyContactPhone]]];
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
    _leftTableView_EndCity.hidden = hidden;
    _rightTableView_EndCity.hidden = hidden;
}

- (void)setWalkTypeTableViewHidden:(BOOL)hidden
{
    _walkTableView.hidden = hidden;
}

- (void)hideAccompanyInfoView
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
        }
    }];
}

- (void)showAccompanyInfoView
{
    [self.view insertSubview:_darkMask aboveSubview:_walkTableView];
    [UIView animateWithDuration:0.4 animations:^{
        _darkMask.alpha = 1;
        [_accompanyInfoView setFrame:CGRectOffset(_accompanyInfoView.frame, 0, -_accompanyInfoView.frame.size.height)];
    }];
}




@end
