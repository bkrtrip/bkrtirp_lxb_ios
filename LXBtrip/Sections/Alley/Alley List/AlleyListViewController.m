//
//  AlleyListViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/29.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "AlleyListViewController.h"
#import "AlleyListCollectionView.h"
#import "AlleyListCollectionViewCell.h"
#import "AlleyListCollectionViewFlowLayout.h"
#import "AppMacro.h"
#import "Global.h"
#import "AlleyDetailViewController.h"

@interface AlleyListViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSString *curCountry;
    NSString *curProvince;
    NSString *curCity;
    NSInteger pageNum;
}

@property (strong, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSMutableArray *alleysArray;

@end

@implementation AlleyListViewController

- (id)init
{
    self = [super init];
    if (self) {
        // tabBarItem
        UIImage *normal = [ImageNamed(@"service_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selected = [ImageNamed(@"service_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"服务" image:normal selectedImage:selected];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    _alleysArray = [[NSMutableArray alloc] init];
    
    AlleyListCollectionViewFlowLayout *flow = [[AlleyListCollectionViewFlowLayout alloc] init];
    
    CGFloat yOrigin = 117.f + 37.f;
    _collectionView = [[AlleyListCollectionView alloc] initWithFrame:CGRectMake(0, yOrigin, SCREEN_WIDTH, SCREEN_HEIGHT - yOrigin) collectionViewLayout:flow];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"AlleyListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AlleyListCollectionViewCell"];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    
    // --TEST--
    curCity = @"西安";
    curProvince = @"陕西";
    curCountry = @"中国";
    
    pageNum = 1;
    [self getAlleyList];
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _alleysArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlleyListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlleyListCollectionViewCell" forIndexPath:indexPath];
    [cell setCellContentWithAlleyInfo:_alleysArray[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 50.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // jump to detail
    AlleyDetailViewController *detail = [[AlleyDetailViewController alloc] init];
    detail.alley = _alleysArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)getAlleyList
{
    if ([UserModel companyId] && [UserModel staffId]) {
        [HTTPTool getServiceListWithWithCompanyId:[UserModel companyId] staffId:[UserModel staffId] county:curCountry province:curProvince city:curCity pageNum:@(pageNum) success:^(id result) {
            id data = result[@"RS100020"];
            [[Global sharedGlobal] codeHudWithObject:data succeed:^{
                if ([data isKindOfClass:[NSArray class]]) {
                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        AlleyInfo *alley = [[AlleyInfo alloc] initWithDict:obj];
                        [_alleysArray addObject:alley];
                    }];
                }
                [_collectionView reloadData];
            }];
        } fail:^(id result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];

        }];
    } else {
        [HTTPTool getServiceListWithCounty:curCountry province:curProvince city:curCity pageNum:@(pageNum) success:^(id result) {
            id data = result[@"RS100019"];
            [[Global sharedGlobal] codeHudWithObject:data succeed:^{
                if ([data isKindOfClass:[NSArray class]]) {
                    [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        AlleyInfo *alley = [[AlleyInfo alloc] initWithDict:obj];
                        [_alleysArray addObject:alley];
                    }];
                }
                [_collectionView reloadData];
            }];
        } fail:^(id result) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取列表失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
            
        }];
    }
}

@end
