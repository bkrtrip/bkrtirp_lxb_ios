//
//  MicroShopDetailViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/5/25.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "MicroShopDetailViewController.h"

const CGFloat Img_Width_To_Height = 730.f/760.f;

@interface MicroShopDetailViewController ()
{
    UIImage *fullImage;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIScrollView *fullImageScrollView;
@property (strong, nonatomic) UIButton *dismissFullImageButton;

@property (strong, nonatomic) IBOutlet UIButton *addToMyShopButton;
- (IBAction)addToMyShopButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *hasAddedToMyShopButton;

- (IBAction)showFullImageButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *shopImageView;
@property (strong, nonatomic)  UIImageView *fullImageView;

@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopProviderLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopIntroductionLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopMonthUsageLabel;



@property (nonatomic, strong) MicroShopInfo *info;
@end

@implementation MicroShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getShopDetail];
    self.title = @"微店详情";
//    self.automaticallyAdjustsScrollViewInsets = YES;

    _addToMyShopButton.layer.cornerRadius = 5.f;
    if (_isMyShop == NO) {
        _addToMyShopButton.hidden = NO;
        _hasAddedToMyShopButton.hidden = YES;
    } else {
        _addToMyShopButton.hidden = YES;
        _hasAddedToMyShopButton.hidden = NO;
    }
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
    CGFloat yOrigin = 0;
    [[NoNetworkView sharedNoNetworkView] showWithYOrigin:yOrigin height:SCREEN_HEIGHT - 77.f];
}

- (void)networkAvailable
{
    [super networkAvailable];
}

- (void)getShopDetail
{
    [HTTPTool getMicroShopDetailWithShopId:_shopId success:^(id result) {
        NSDictionary *data = result[@"RS100003"];
        _info = [[MicroShopInfo alloc] initWithDict:data];
        
        [_shopImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST_IMG_BASE_URL, _info.shopImg]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                fullImage = [image copy];
                
                CGFloat imgWidth = image.size.width;
                CGFloat cropedHeight = imgWidth/Img_Width_To_Height;
                CGRect rect =  CGRectMake(0, 0, imgWidth, cropedHeight);//要裁剪的图片区域，按照原图的像素大小来，超过原图大小的边自动适配
                CGImageRef cgimg = CGImageCreateWithImageInRect([image CGImage], rect);
                _shopImageView.image = [UIImage imageWithCGImage:cgimg];
                CGImageRelease(cgimg);//用完一定要释放，否则内存泄露
            }
        }];
        
        _shopNameLabel.text = _info.shopName;
        _shopProviderLabel.text = _info.shopProvider;
        
        TemplateType templateType = [_info.shopType intValue];
        switch (templateType) {
            case Exclusive_Shop:// 专卖（供应商为您专门定制的产品和微店）
                _shopTypeLabel.text = @"专卖（供应商为您专门定制的产品和微店）";
                break;
            case Template_By_LXB:// 模板（可自由选择供应商的产品同步到我的微店）
                _shopTypeLabel.text = @"模板（可自由选择供应商的产品同步到我的微店）";
                break;
            case Template_By_Supplier:// 模板（可自由选择供应商的产品同步到我的微店）
                _shopTypeLabel.text = @"模板（可自由选择供应商的产品同步到我的微店）";
                break;
            default:
                break;
        }
        
        _shopIntroductionLabel.text = _info.shopIntroduction;

        _shopMonthUsageLabel.text = [NSString stringWithFormat:@"%@次", _info.shopUsageAmount];
        
        CGSize instructionSize = [_shopIntroductionLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 20.f - 60.f - 20.f, MAXFLOAT)];
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 580.f + instructionSize.height)];
    } fail:^(id result) {
        
        if ([[Global sharedGlobal] networkAvailability] == NO) {
            [self networkUnavailable];
            return ;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取微店详情失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)addToMyShopButtonClicked:(id)sender {
    if (![UserModel companyId] || ![UserModel staffId]) {
        // go to login page
        [self presentViewController:[[Global sharedGlobal] loginNavViewControllerFromSb] animated:YES completion:nil];
    } else
    {
        // add to myshop
        [HTTPTool addToMyShopWithShopId:_shopId companyId:[UserModel companyId] staffId:[UserModel staffId] success:^(id result) {
            id obj = result[@"RS100004"];
            [[Global sharedGlobal] codeHudWithObject:obj succeed:^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加成功" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                [alert show];
                _addToMyShopButton.hidden = YES;
                _hasAddedToMyShopButton.hidden = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOP_LIST_NEEDS_UPDATE" object:self];
            }];
        } fail:^(id result) {
            
            if ([[Global sharedGlobal] networkAvailability] == NO) {
                [self networkUnavailable];
                return ;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
        }];
    }
}
- (IBAction)showFullImageButtonClicked:(id)sender {
    if (!fullImage) {
        return;
    }
    CGFloat fullImgWidthToHeight = fullImage.size.width/fullImage.size.height;
    
    if (!_fullImageScrollView) {
        _fullImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, SCREEN_HEIGHT - 20.f)];
        _fullImageScrollView.backgroundColor = [UIColor whiteColor];
        [_fullImageScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/fullImgWidthToHeight)];
        [self.view addSubview:_fullImageScrollView];
    }
    
    if (!_fullImageView) {
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 10.f, SCREEN_WIDTH-2*10.f, SCREEN_WIDTH/fullImgWidthToHeight - 2*10.f)];
        _fullImageView.image = fullImage;
        _fullImageView.contentMode = UIViewContentModeScaleToFill;
        [_fullImageScrollView addSubview:_fullImageView];
    }
    
    if (!_dismissFullImageButton) {
        _dismissFullImageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/fullImgWidthToHeight)];
        _dismissFullImageButton.backgroundColor = [UIColor clearColor];
        [_dismissFullImageButton addTarget:self action:@selector(dismissFullImage) forControlEvents:UIControlEventTouchUpInside];
        [_fullImageScrollView addSubview:_dismissFullImageButton];
    }
    
    _fullImageScrollView.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)dismissFullImage
{
    _fullImageScrollView.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}


@end



