//
//  PersonalInfoViewController.m
//  LXBtrip
//
//  Created by Sam on 6/10/15.
//  Copyright (c) 2015 LXB. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "UserInfoTableViewCell.h"
#import "PhotoTableViewCell.h"
#import "AlterUserInfoViewController.h"
#import "AlterPhoneNumViewController.h"
#import "NSDictionary+GetStringValue.h"
#import "AFNetworking.h"
#import "UIViewController+CommonUsed.h"

@interface PersonalInfoViewController ()<UpdateUserInformationDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *pInfoTableView;
@property (weak, nonatomic) IBOutlet UIView *areaPickerBgView;
@property (weak, nonatomic) IBOutlet UIPickerView *areaPickerView;

@property (retain, nonatomic) NSArray *provinceArray;
@property (retain, nonatomic) NSArray *cityArray;
@property (retain, nonatomic) NSArray *districtArray;

@property (retain, nonatomic) NSArray *corresondingCitiesArray;
@property (retain, nonatomic) NSArray *corresondingDistrictsArray;

@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.pInfoTableView registerNib:[UINib nibWithNibName:@"PhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"photoCell"];
    
    [self.pInfoTableView registerNib:[UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"userInfoCell"];

    self.pInfoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.title = @"我的信息";
    
    if (self.userInfoDic == nil) {
        [self getUserInformation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelChangeArea:(id)sender {
    self.areaPickerBgView.hidden = YES;
}

- (IBAction)confirmChangeArea:(id)sender {
    self.areaPickerBgView.hidden = YES;
    
    //update province and city id
    NSDictionary *provinceDic = [self.provinceArray objectAtIndex:[self.areaPickerView selectedRowInComponent:0]];
    NSDictionary *cityDic = [self.corresondingCitiesArray objectAtIndex:[self.areaPickerView selectedRowInComponent:1]];
    NSDictionary *districtDic = [self.corresondingDistrictsArray objectAtIndex:[self.areaPickerView selectedRowInComponent:2]];
    
    NSDictionary *alterInfoDic = @{@"staffid":[self.userInfoDic stringValueByKey:@"staff_id"], @"companyid":[self.userInfoDic stringValueByKey:@"company_id"], @"provinceid":[provinceDic stringValueByKey:@"province_id"], @"provincename":[provinceDic stringValueByKey:@"province_name"], @"cityid":[cityDic stringValueByKey:@"city_id"], @"cityname":[cityDic stringValueByKey:@"city_name"], @"areaid":[districtDic stringValueByKey:@"dictrict_id"], @"areaname":[districtDic stringValueByKey:@"district_name"]};
    
    [self updateUserInfo:alterInfoDic];
}

- (void)updateUserInfo:(NSDictionary *)userDic
{
    __weak PersonalInfoViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/setStaff", HOST_BASE_URL];
    
    [manager POST:partialUrl parameters:userDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100024"];
                 
                 //update user info successfully
                 if (resultDic && [[resultDic stringValueByKey:@"error_code"] isEqualToString:@"0"]) {
                     [weakSelf showAlertViewWithTitle:nil message:@"更新地址成功 ！" cancelButtonTitle:@"确定"];
                 }
             }
             
         }
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}

- (void)getUserInformation
{
    __weak PersonalInfoViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    NSDictionary *staffDic = [[UserModel getUserInformations] valueForKey:@"RS100034"];
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@myself/staffData", HOST_BASE_URL];
    NSDictionary *parameterDic = @{@"staffid":[staffDic stringValueByKey:@"staff_id" ], @"companyid":[staffDic stringValueByKey:@"dat_company_id"]};
    
    [manager POST:partialUrl parameters:parameterDic
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSDictionary *resultDic = [jsonObj objectForKey:@"RS100026"];
                 
                 if (resultDic) {
                     weakSelf.userInfoDic = resultDic;
                     [weakSelf.pInfoTableView reloadData];
                 }
             }
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        PhotoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
        
        return cell;
    }
    else {
        UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userInfoCell"];
        
        switch (indexPath.row) {
            case 1:
            {
                cell.titleLabel.text = @"微店联系人";
                cell.contentLabel.text = self.userInfoDic == nil ? @"" : [self.userInfoDic objectForKey:@"staff_real_name"];
            }
                break;
            case 2:
            {
                cell.titleLabel.text = @"微店名称";
                cell.contentLabel.text = self.userInfoDic == nil ? @"" : [self.userInfoDic objectForKey:@"staff_departments_name"];
            }
                break;
            case 3:
            {
                cell.titleLabel.text = @"联系电话";
                cell.contentLabel.text = self.userInfoDic == nil ? @"" : [self.userInfoDic objectForKey:@"wd_phone"];
            }
                break;
            case 4:
            {
                cell.titleLabel.text = @"所在地";
                if (self.userInfoDic) {
                    NSString *address = [NSString stringWithFormat:@"%@ %@", [self.userInfoDic stringValueByKey:@"staff_provinc_name"], [self.userInfoDic stringValueByKey:@"staff_city_name"]];
                    cell.contentLabel.text = address;
                }
            }
                break;
            case 5:
            {
                cell.titleLabel.text = @"详细地址";
                cell.contentLabel.text = self.userInfoDic == nil ? @"" : [self.userInfoDic objectForKey:@"staff_address"];
            }
                break;
                
                
            default:
                break;
        }
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }
    return 55;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 1:
        {
            [self goToAlterInfoPageWithType:ShopContactName withInformation:@""];
        }
            break;
        case 2:
        {
            [self goToAlterInfoPageWithType:ShopName withInformation:@""];
        }
            break;
        case 3://联系方式
        {
            AlterPhoneNumViewController *viewController = [[AlterPhoneNumViewController alloc] init];
            viewController.userInfoDic = self.userInfoDic;
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 4://地址
        {
            [self getAreaDataAndShowAreaSelectionPickerView];
            self.areaPickerBgView.hidden = NO;
        }
            break;
        case 5:
        {
            [self goToAlterInfoPageWithType:DetailAdress withInformation:@""];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)goToAlterInfoPageWithType:(AlterInfoTypes)type withInformation:(NSString *)info
{
    AlterUserInfoViewController *viewController = [[AlterUserInfoViewController alloc] init];
    viewController.userInfoDic = self.userInfoDic;
    viewController.type = type;
    viewController.delegate = self;
    
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - UpdateUserInformationDelegate

- (void)updateUserInformationSuccessfully
{
    [self getUserInformation];
}


- (void)getAreaDataAndShowAreaSelectionPickerView
{
    [self getProvinceData];
    [self getCityData];
    [self getDistrictsData];
}

- (void)getProvinceData
{
    __weak PersonalInfoViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@common/province", HOST_BASE_URL];
    
    [manager POST:partialUrl parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSArray *resultArray = [jsonObj objectForKey:@"RS100040"];
                 
                 if (resultArray) {
                     weakSelf.provinceArray = resultArray;
                     [weakSelf.areaPickerView reloadComponent:0];
                 }
             }
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}

- (void)getCityData
{
    __weak PersonalInfoViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@common/city", HOST_BASE_URL];
    
    [manager POST:partialUrl parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSArray *resultArray = [jsonObj objectForKey:@"RS100041"];
                 
                 if (resultArray) {
                     weakSelf.cityArray = resultArray;
                     [weakSelf.areaPickerView reloadComponent:1];
                 }
             }
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}

- (void)getDistrictsData
{
    __weak PersonalInfoViewController *weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval=10;
    
    
    NSString *partialUrl = [NSString stringWithFormat:@"%@common/District", HOST_BASE_URL];
    
    [manager POST:partialUrl parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (responseObject)
         {
             id jsonObj = [weakSelf jsonObjWithBase64EncodedJsonString:operation.responseString];
             NSLog(@"%@", jsonObj);
             
             if (jsonObj && [jsonObj isKindOfClass:[NSDictionary class]]) {
                 
                 NSArray *resultArray = [jsonObj objectForKey:@"RS100057"];
                 
                 if (resultArray) {
                     weakSelf.districtArray = resultArray;
                     [weakSelf.areaPickerView reloadComponent:2];
                 }
             }
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}


#pragma mark - UIPickerViewDatasource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.provinceArray ? self.provinceArray.count : 0;
    }
    else if (component == 1) {
        NSString *provinceId = [(NSDictionary *)[self.provinceArray objectAtIndex:[pickerView selectedRowInComponent:0]] stringValueByKey:@"province_id"];
        NSMutableArray *correspondingCity = [[NSMutableArray alloc]init];
        for (NSDictionary *cityDic  in self.cityArray) {
            if ([[cityDic stringValueByKey:@"province_id"] isEqualToString:provinceId]) {
                [correspondingCity addObject:cityDic];
            }
        }
        
        self.corresondingCitiesArray = correspondingCity;
        
        return correspondingCity.count;
    }
    else {
        NSString *cityId = [(NSDictionary *)[self.cityArray objectAtIndex:[pickerView selectedRowInComponent:1]] stringValueByKey:@"city_id"];
        NSMutableArray *correspondingDistricts = [[NSMutableArray alloc]init];
        for (NSDictionary *districtDic  in self.districtArray) {
            if ([[districtDic stringValueByKey:@"city_id"] isEqualToString:cityId]) {
                [correspondingDistricts addObject:districtDic];
            }
        }
        
        self.corresondingDistrictsArray = correspondingDistricts;
        
        return correspondingDistricts.count;
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSString *provinceName = [[self.provinceArray objectAtIndex:row] stringValueByKey:@"province_name"];
        return provinceName;
    }
    else if (component == 1) {
        NSString *cityName = [[self.corresondingCitiesArray objectAtIndex:row] stringValueByKey:@"city_name"];
        return cityName;
    }
    else {
        NSString *districtName = [[self.corresondingDistrictsArray objectAtIndex:row] stringValueByKey:@"district_name"];
        return districtName;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    if (component == 0) {
//        [self.areaPickerView reloadComponent:1];
//    }
//    else if (component == 1) {
//        [self.areaPickerView reloadComponent:2];
//    }
    [self.areaPickerView reloadAllComponents];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
