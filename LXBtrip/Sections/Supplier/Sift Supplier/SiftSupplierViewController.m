//
//  SiftSupplierViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/4.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "SiftSupplierViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppMacro.h"
#import "Global.h"
#import "SiftSupplierCollectionView.h"
#import "SiftSupplierCollectionViewCell.h"
#import "SiftSupplierCollectionViewFlowLayout.h"
#import "ReusableHeaderView_SiftSupplier.h"

@interface SiftSupplierViewController ()<CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
{
    NSString *startCity;
    NSInteger selectedIndex; // 0~4
    
    NSMutableArray *allSupplierListsArrayInOrder;
    NSMutableArray *allSupplierListsArrayUnsorted;
    NSMutableArray *fourSectionsListsArrayInOrder;


    NSMutableArray *allFirstLettersArray;
    NSMutableArray *collectionViewsArray;
}

//navigationbar part
- (IBAction)selectButtonClicked:(id)sender;
- (IBAction)myButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *locationButton;
- (IBAction)locationButtonClicked:(id)sender;
- (IBAction)searchProductButtonClicked:(id)sender;

//专线part
@property (strong, nonatomic) IBOutlet UIButton *zhuanXianButton;
@property (strong, nonatomic) IBOutlet UIButton *domesticButton_zhuanXian;
- (IBAction)domesticButton_zhuanXianClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *abroadButton_zhuanXian;
- (IBAction)abroadButton_zhuanXianClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *nearbyButton_zhuanXian;
- (IBAction)nearbyButton_zhuanXianClicked:(id)sender;

// 地接part
@property (strong, nonatomic) IBOutlet UIButton *diJieButton;
@property (strong, nonatomic) IBOutlet UIButton *domesticButton_diJie;
- (IBAction)domesticButton_diJieClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *abroadBUtton_diJie;
- (IBAction)abroadBUtton_diJieClicked:(id)sender;

- (IBAction)cancelButtonClicked:(id)sender;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *underLineLabel;

@end

@implementation SiftSupplierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    allSupplierListsArrayInOrder = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [allSupplierListsArrayInOrder addObject:array];
    }
    
    allSupplierListsArrayUnsorted = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [allSupplierListsArrayUnsorted addObject:array];
    }
    
    allFirstLettersArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [allFirstLettersArray addObject:array];
    }
    
    fourSectionsListsArrayInOrder = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:4];
        [fourSectionsListsArrayInOrder addObject:array];
    }
    
    // --TEST--
    startCity = @"西安";
    selectedIndex = 0;
    
    
    CGFloat yOrigin = 20.f + 44.f + 82.f;
    _underLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yOrigin-2, (SCREEN_WIDTH/2.f)/3, 2)];
    _underLineLabel.backgroundColor = TEXT_4CA5FF;
    [self.view addSubview:_underLineLabel];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yOrigin, SCREEN_WIDTH, self.view.frame.size.height - yOrigin - 49.f)];
    [self.view addSubview:_scrollView];
    
    collectionViewsArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        SiftSupplierCollectionViewFlowLayout *flow = [[SiftSupplierCollectionViewFlowLayout alloc] init];
        
        SiftSupplierCollectionView *collectionView = [[SiftSupplierCollectionView alloc] initWithFrame:CGRectOffset(_scrollView.bounds, i*SCREEN_WIDTH, 0) collectionViewLayout:flow];
        [collectionView registerNib:[UINib nibWithNibName:@"SiftSupplierCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SiftSupplierCollectionViewCell"];
        
        [collectionView registerNib:[UINib nibWithNibName:@"ReusableHeaderView_SiftSupplier" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableHeaderView_SiftSupplier"];
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:collectionView];
        
        [collectionViewsArray addObject:collectionView];
    }
    
    [_scrollView setContentSize:CGSizeMake(5*SCREEN_WIDTH, _scrollView.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    _scrollView.delegate = self;
    // --TEST--
    [self getSiftSupplierList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)getSiftSupplierList
{
    [HTTPTool getSiftedSuppliersWithSuccess:^(id result) {
        [[Global sharedGlobal] codeHudWithObject:result[@"RS100011"] succeed:^{
            id data = result[@"RS100011"];
            if ([data isKindOfClass:[NSArray class]]) {
                [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    SiftedLine *siftLine= [[SiftedLine alloc] initWithDict:obj];
                    
                    // separator for each collection view
                    SiftedLineType type = [siftLine.siftedLineType intValue];
                    switch (type) {
                        case Domestic_ZhuanXian:
                            [allSupplierListsArrayUnsorted[0] addObject:obj];
                            break;
                        case Abroad_ZhuanXian:
                            [allSupplierListsArrayUnsorted[1] addObject:obj];
                            break;
                        case Nearby_ZhuanXian:
                            [allSupplierListsArrayUnsorted[2] addObject:obj];
                            break;
                        case Domestic_DiJie:
                            [allSupplierListsArrayUnsorted[3] addObject:obj];
                            break;
                        case Abroad_DiJie:
                            [allSupplierListsArrayUnsorted[4] addObject:obj];
                            break;
                        default:
                            break;
                    }
                }];
            }
            
            // now sort data with initials
            [self sortSuppliersUsingInitialsWithUnsortedArray:allSupplierListsArrayUnsorted[selectedIndex]];
            
            // now group data into four sections
            [self groupDataIntoFourSections];
            [collectionViewsArray[selectedIndex] reloadData];
        } fail:^(id result) {
        }];

    } fail:^(id result) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取筛选供应商失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)sortSuppliersUsingInitialsWithUnsortedArray:(NSArray *)array
{
    NSMutableArray *tempParent = [[NSMutableArray alloc] init];
    // create unsorted keys array and values array separately
    [array enumerateObjectsUsingBlock:^(SiftedLine *obj, NSUInteger idx, BOOL *stop) {
        if ([allFirstLettersArray[selectedIndex] containsObject:obj.siftedLineFirstLetter]) {
            NSInteger index = [allFirstLettersArray[selectedIndex] indexOfObject:obj.siftedLineFirstLetter];
            NSMutableArray *tempSon = tempParent[index];
            if (![tempSon containsObject:obj]) {
                [tempSon addObject:obj];
            }
        } else {
            [allFirstLettersArray[selectedIndex] addObject:obj.siftedLineFirstLetter];
            NSMutableArray *tempNewSon = [[NSMutableArray alloc] init];
            [tempNewSon addObject:obj];
            [tempParent addObject:tempNewSon];
        }
    }];
    
    // sort initials array
    allFirstLettersArray[selectedIndex] = [[allFirstLettersArray[selectedIndex] sortedArrayUsingFunction:initialSort context:NULL] mutableCopy];
    
    // create final initial-keyed dictionaries' array
    [allFirstLettersArray[selectedIndex] enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
        [tempParent enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
            if ([[arr[0] cityInitail] isEqualToString:str]) {
                NSDictionary *temp = @{str:arr};
                [allSupplierListsArrayInOrder[selectedIndex] addObject:temp];
            }
        }];
    }];
}

- (void)groupDataIntoFourSections
{
    [allSupplierListsArrayInOrder[selectedIndex] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop2) {
        NSString *curFirstLetter = allFirstLettersArray[idx];
        if ([curFirstLetter compare:@"A" options:NSCaseInsensitiveSearch] != NSOrderedAscending &&
            [curFirstLetter compare:@"G" options:NSCaseInsensitiveSearch] != NSOrderedDescending) {
            [fourSectionsListsArrayInOrder[selectedIndex][0] addObjectsFromArray:dict[curFirstLetter]];
        }
        if ([curFirstLetter compare:@"H" options:NSCaseInsensitiveSearch] != NSOrderedAscending &&
            [curFirstLetter compare:@"N" options:NSCaseInsensitiveSearch] != NSOrderedDescending) {
            [fourSectionsListsArrayInOrder[selectedIndex][1] addObjectsFromArray:dict[curFirstLetter]];
        }
        if ([curFirstLetter compare:@"O" options:NSCaseInsensitiveSearch] != NSOrderedAscending &&
            [curFirstLetter compare:@"T" options:NSCaseInsensitiveSearch] != NSOrderedDescending) {
            [fourSectionsListsArrayInOrder[selectedIndex][2] addObjectsFromArray:dict[curFirstLetter]];
        }
        if ([curFirstLetter compare:@"U" options:NSCaseInsensitiveSearch] != NSOrderedAscending &&
            [curFirstLetter compare:@"Z" options:NSCaseInsensitiveSearch] != NSOrderedDescending) {
            [fourSectionsListsArrayInOrder[selectedIndex][3] addObjectsFromArray:dict[curFirstLetter]];
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [fourSectionsListsArrayInOrder[selectedIndex][section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SiftSupplierCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SiftSupplierCollectionViewCell" forIndexPath:indexPath];
    NSArray *subArray = fourSectionsListsArrayInOrder[selectedIndex][indexPath.section];
    SiftedLine *siftline = subArray[indexPath.row];
    [cell setCellContentWithSiftLine:siftline];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ReusableHeaderView_SiftSupplier *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableHeaderView_SiftSupplier" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            [header setSiftSupplierReusableHeaderWithHeaderNames:[NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", nil]];
            break;
        case 1:
            [header setSiftSupplierReusableHeaderWithHeaderNames:[NSArray arrayWithObjects:@"H", @"I", @"J", @"K", @"L", @"M", @"N", nil]];
            break;
        case 2:
            [header setSiftSupplierReusableHeaderWithHeaderNames:[NSArray arrayWithObjects:@"O", @"P", @"Q", @"R", @"S", @"T", @"", nil]];
            break;
        case 3:
            [header setSiftSupplierReusableHeaderWithHeaderNames:[NSArray arrayWithObjects:@"U", @"V", @"W", @"X", @"Y", @"Z", @"", nil]];
            break;
        default:
            break;
    }
    
    return header;
}

#pragma mark - UICollectionViewDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 23.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // jump bak to SupplierViewController
    NSArray *subArray = fourSectionsListsArrayInOrder[selectedIndex][indexPath.section];
    SiftedLine *siftline = subArray[indexPath.row];
    
    NSDictionary *info = @{@"lineclass":LINE_CLASS[@(selectedIndex)], @"linetype":siftline.siftedLineName};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SIFT_SUPPLIER_WITH_LINE_CLASS_AND_LINE_TYPE" object:self userInfo:info];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)myButtonClicked:(id)sender {
}
- (IBAction)locationButtonClicked:(id)sender {
//    SwitchCityViewController *switchCity = [[SwitchCityViewController alloc] init];
//    switchCity.curCityName = startCity;
//    [self.navigationController pushViewController:switchCity animated:YES];
}

- (IBAction)searchProductButtonClicked:(id)sender {
}
- (IBAction)domesticButton_zhuanXianClicked:(id)sender {
    selectedIndex = 0;
    [self scrollToVisibleWithSelectedIndex:selectedIndex];
}
- (IBAction)abroadButton_zhuanXianClicked:(id)sender {
    selectedIndex = 1;
    [self scrollToVisibleWithSelectedIndex:selectedIndex];
}
- (IBAction)nearbyButton_zhuanXianClicked:(id)sender {
    selectedIndex = 2;
    [self scrollToVisibleWithSelectedIndex:selectedIndex];
}
- (IBAction)domesticButton_diJieClicked:(id)sender {
    selectedIndex = 3;
    [self scrollToVisibleWithSelectedIndex:selectedIndex];
}
- (IBAction)abroadBUtton_diJieClicked:(id)sender {
    selectedIndex = 4;
    [self scrollToVisibleWithSelectedIndex:selectedIndex];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollToVisibleWithSelectedIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2 animations:^{
        [_scrollView scrollRectToVisible:CGRectOffset(_scrollView.frame, index*SCREEN_WIDTH, 0) animated:NO];
        if (index < 3) {
            [_underLineLabel setFrame:CGRectMake(index*(SCREEN_WIDTH/2.0)/3, _underLineLabel.frame.origin.y, (SCREEN_WIDTH/2.0)/3, _underLineLabel.frame.size.height)];
        } else {
            [_underLineLabel setFrame:CGRectMake(SCREEN_WIDTH/2.0 + (index-3)*(SCREEN_WIDTH/2.0)/2, _underLineLabel.frame.origin.y, (SCREEN_WIDTH/2.0)/2, _underLineLabel.frame.size.height)];
        }
    }];
}




@end
