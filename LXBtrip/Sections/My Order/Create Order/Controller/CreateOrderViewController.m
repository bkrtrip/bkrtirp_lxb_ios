//
//  CreateOrderViewController.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "CreateOrderViewController.h"
#import "CreateOrderCell_OrderId.h"
#import "CreateOrderCell_BookHeader.h"
#import "CreateOrderCell_Input.h"
#import "CreateOrderCell_Price.h"
#import "CreateOrderCell_StartOrEndDate.h"
#import "TourDetailTableViewController.h"

@interface CreateOrderViewController ()<UITableViewDataSource, UITableViewDelegate, CreateOrderCell_Price_Delegate, CreateOrderCell_Input_Delegate>
{
    CGFloat keyBoardHeight;
    NSInteger touristsNumPlusTow;
    NSIndexPath *editingCellIndexPath;
    NSInteger priceGroupNum;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *totalCostLabel;

- (IBAction)confirmOrderButtonClicked:(id)sender;

@property (copy, nonatomic) NSMutableArray *textFieldsIndexesArray;
@property (copy, nonatomic) NSMutableArray *touristsArray;

@end

@implementation CreateOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"线路订单";
    [_tableView registerNib:[UINib nibWithNibName:@"CreateOrderCell_OrderId" bundle:nil] forCellReuseIdentifier:@"CreateOrderCell_OrderId"];
    [_tableView registerNib:[UINib nibWithNibName:@"CreateOrderCell_BookHeader" bundle:nil] forCellReuseIdentifier:@"CreateOrderCell_BookHeader"];
    [_tableView registerNib:[UINib nibWithNibName:@"CreateOrderCell_Input" bundle:nil] forCellReuseIdentifier:@"CreateOrderCell_Input"];
    [_tableView registerNib:[UINib nibWithNibName:@"CreateOrderCell_Price" bundle:nil] forCellReuseIdentifier:@"CreateOrderCell_Price"];
    [_tableView registerNib:[UINib nibWithNibName:@"CreateOrderCell_StartOrEndDate" bundle:nil] forCellReuseIdentifier:@"CreateOrderCell_StartOrEndDate"];
    
    _touristsArray = [_item.orderTouristGroup mutableCopy]; // 不能只用orderTouristGroup来判断人数，因为人数>0，游客信息仍可能为空！
    
    NSInteger totalNum = [_item.orderReservePriceGroup.adultNum integerValue] + [_item.orderReservePriceGroup.kidBedNum integerValue] + [_item.orderReservePriceGroup.kidNum integerValue];
    
    NSInteger initialTouristsArrayCount = _touristsArray.count; //必须先取出来，且不能用（totalNum - _touristsArray.count）作为上限，不然后面会随着_touristsArray.count的变化而循环次数减少！！
    if (totalNum > initialTouristsArrayCount) {
        for (int i = 0; i < totalNum - initialTouristsArrayCount; i++) {
            TouristInfo *tourist = [[TouristInfo alloc] init];
            tourist.touristName = @"";
            tourist.touristCode = @"";
            if (!_touristsArray) {
                _touristsArray = [[NSMutableArray alloc] init];
            }
            [_touristsArray addObject:tourist];
        }
    }
    _item.orderTouristGroup = [_touristsArray mutableCopy];
    
    touristsNumPlusTow = totalNum * 2; // 乘以二统计旅客信息的texfield个数
    
    _textFieldsIndexesArray = [[NSMutableArray alloc] init];
    [_textFieldsIndexesArray addObject:[NSIndexPath indexPathForRow:0 inSection:2]];
    [_textFieldsIndexesArray addObject:[NSIndexPath indexPathForRow:1 inSection:2]];
    for (int i = 0; i < touristsNumPlusTow; i++) {
        [_textFieldsIndexesArray addObject:[NSIndexPath indexPathForRow:i inSection:3]];
    }
    
    _totalCostLabel.text = [NSString stringWithFormat:@"￥%@", _item.orderDealPrice];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self registerNotification];
    if ([[Global sharedGlobal] networkAvailability] == NO) {
        [self networkUnavailable];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotification];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
        {
            NSInteger least = 3;
            if (_item.orderReservePriceGroup.adultPrice && [_item.orderReservePriceGroup.adultPrice integerValue] > 0) {
                least++;
            }
            if (_item.orderReservePriceGroup.kidBedPrice && [_item.orderReservePriceGroup.kidBedPrice integerValue] > 0) {
                least++;
            }
            if (_item.orderReservePriceGroup.kidPrice && [_item.orderReservePriceGroup.kidPrice integerValue] > 0) {
                least++;
            }
            priceGroupNum = least-3;
            return least;
        }
            break;
        case 2:
            return 2;
            break;
        case 3:
            return touristsNumPlusTow;
            break;
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            CreateOrderCell_OrderId *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_OrderId" forIndexPath:indexPath];
            [cell setCellContentWithMyOrderItem:_item];
            return cell;
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    CreateOrderCell_BookHeader *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_BookHeader" forIndexPath:indexPath];
                    cell.headerLabel.text = @"预订信息";
                    return cell;
                }
                    break;
                case 1:
                {
                    CreateOrderCell_StartOrEndDate *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_StartOrEndDate" forIndexPath:indexPath];
                    [cell setCellContentWithTitle:@"出发日期" date:_item.orderStartDate dateColor:RED_FF0075];
                    return cell;
                }
                    break;
                case 2:
                {
                    CreateOrderCell_StartOrEndDate *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_StartOrEndDate" forIndexPath:indexPath];
                    [cell setCellContentWithTitle:@"返程日期" date:_item.orderReturnDate dateColor:TEXT_333333];
                    return cell;
                }
                    break;
                case 3:
                {
                    CreateOrderCell_Price *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_Price" forIndexPath:indexPath];
                    BOOL shouldShowSeparator = NO;
                    if (priceGroupNum+3-1 == 3) {
                        cell.separatorInset = UIEdgeInsetsMake(0, 414, 0, 0);
                        shouldShowSeparator = YES;
                    }
                    if (_item.orderReservePriceGroup.adultPrice && [_item.orderReservePriceGroup.adultPrice integerValue] > 0) {
                        [cell setCellContentWithOrder:_item touristType:Adult shouldShowGraySeparator:shouldShowSeparator];
                    } else if (_item.orderReservePriceGroup.kidBedPrice && [_item.orderReservePriceGroup.kidBedPrice integerValue] > 0) {
                        [cell setCellContentWithOrder:_item touristType:Kid_Bed shouldShowGraySeparator:shouldShowSeparator];
                    } else if (_item.orderReservePriceGroup.kidPrice && [_item.orderReservePriceGroup.kidPrice integerValue] > 0) {
                        [cell setCellContentWithOrder:_item touristType:Kid_No_Bed shouldShowGraySeparator:shouldShowSeparator];
                    }
                    cell.delegate = self;
                    return cell;
                }
                    break;
                case 4:
                {
                    CreateOrderCell_Price *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_Price" forIndexPath:indexPath];
                    BOOL shouldShowSeparator = NO;
                    if (priceGroupNum+3-1 == 4) {
                        cell.separatorInset = UIEdgeInsetsMake(0, 414, 0, 0);
                        shouldShowSeparator = YES;
                    }
                    if (_item.orderReservePriceGroup.adultPrice && [_item.orderReservePriceGroup.adultPrice integerValue] > 0) {
                        if (_item.orderReservePriceGroup.kidBedPrice && [_item.orderReservePriceGroup.kidBedPrice integerValue] > 0) {
                            [cell setCellContentWithOrder:_item touristType:Kid_Bed shouldShowGraySeparator:shouldShowSeparator];
                        } else if (_item.orderReservePriceGroup.kidPrice && [_item.orderReservePriceGroup.kidPrice integerValue] > 0) {
                            [cell setCellContentWithOrder:_item touristType:Kid_No_Bed shouldShowGraySeparator:shouldShowSeparator];
                        }
                    } else if (_item.orderReservePriceGroup.kidBedPrice && [_item.orderReservePriceGroup.kidBedPrice integerValue] > 0) {
                        if (_item.orderReservePriceGroup.kidPrice && [_item.orderReservePriceGroup.kidPrice integerValue] > 0) {
                            [cell setCellContentWithOrder:_item touristType:Kid_No_Bed shouldShowGraySeparator:shouldShowSeparator];
                        }
                    }
                    cell.delegate = self;
                    return cell;
                }
                    break;
                case 5:
                {
                    CreateOrderCell_Price *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_Price" forIndexPath:indexPath];
                    BOOL shouldShowSeparator = NO;
                    if (priceGroupNum+3-1 == 5) {
                        cell.separatorInset = UIEdgeInsetsMake(0, 414, 0, 0);
                        shouldShowSeparator = YES;
                    }
                    if (_item.orderReservePriceGroup.adultPrice && [_item.orderReservePriceGroup.adultPrice integerValue] > 0) {
                        if (_item.orderReservePriceGroup.kidBedPrice && [_item.orderReservePriceGroup.kidBedPrice integerValue] > 0) {
                            if (_item.orderReservePriceGroup.kidPrice && [_item.orderReservePriceGroup.kidPrice integerValue] > 0) {
                                [cell setCellContentWithOrder:_item touristType:Kid_No_Bed shouldShowGraySeparator:shouldShowSeparator];
                            }
                        }
                    }
                    cell.delegate = self;
                    return cell;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    CreateOrderCell_Input *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_Input" forIndexPath:indexPath];
                    [cell setCellContentWithInputType:@"联系人：" section:2 row:0 placeHolder:@"必填" text:_item.orderContactName];
                    cell.delegate = self;
                    return cell;
                }
                    break;
                case 1:
                {
                    CreateOrderCell_Input *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_Input" forIndexPath:indexPath];
                    [cell setCellContentWithInputType:@"手机号码：" section:2 row:1 placeHolder:@"必填" text:_item.orderContactPhone];
                    cell.separatorInset = UIEdgeInsetsMake(0, 414, 0, 0);
                    cell.delegate = self;
                    return cell;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            NSInteger oddOrEven = indexPath.row%2;
            switch (oddOrEven) {
                case 0:
                {
                    CreateOrderCell_Input *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_Input" forIndexPath:indexPath];
                    if ([_item.orderTouristGroup[indexPath.row/2] touristName].length > 0) {
                        [cell setCellContentWithInputType:@"游客姓名：" section:3 row:indexPath.row placeHolder:@"选填" text:[_item.orderTouristGroup[indexPath.row/2] touristName]];
                    } else {
                        [cell setCellContentWithInputType:@"游客姓名：" section:3 row:indexPath.row placeHolder:@"选填" text:nil];
                    }
                    cell.delegate = self;
                    return cell;
                }
                    break;
                case 1:
                {
                    CreateOrderCell_Input *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_Input" forIndexPath:indexPath];
                    if ([_item.orderTouristGroup[indexPath.row/2] touristCode].length > 0) {
                        [cell setCellContentWithInputType:@"身份证号：" section:3 row:indexPath.row placeHolder:@"选填" text:[_item.orderTouristGroup[indexPath.row/2] touristCode]];
                    } else {
                        [cell setCellContentWithInputType:@"身份证号：" section:3 row:indexPath.row placeHolder:@"选填" text:nil];
                    }
                    cell.delegate = self;
                    return cell;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return nil;

}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 70.f;
            break;
        case 1:
        {
            if (_item.orderReservePriceGroup.diffPrice && [_item.orderReservePriceGroup.diffPrice integerValue] > 0) {
                if (priceGroupNum+3-1 == indexPath.row) {
                    return 93.f;
                } else {
                    return 57.f;
                }
            } else {
                if (priceGroupNum+3-1 == indexPath.row) {
                    return 67.f;
                } else {
                    return 57.f;
                }
            }
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                return 57.f;
            } else {
                return 67.f;
            }
        }
        case 3:
        {
            if (_item.orderTouristGroup.count == 0) {
                return 0;
            }
            if (indexPath.row == _item.orderTouristGroup.count*2-1) {
                return 67.f;
            } else {
                return 57.f;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TourDetailTableViewController *detail = [[TourDetailTableViewController alloc] init];
        SupplierProduct *product = [[SupplierProduct alloc] init];
        product.productTravelGoodsId = _item.orderTravelGoodsId;
        product.productTravelGoodsCode = _item.orderTravelGoodsCode;
        detail.product = product;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - CreateOrderCell_Price_Delegate
- (void)supportClickPlusOrMinusWithDeltaNum:(NSInteger)num touristType:(TouristType)type
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TextFieldIResignFirstResponder" object:self];
    // minus
    if (num < 0) {
        
        switch (type) {
            case Adult:
            {
                _item.orderReservePriceGroup.adultNum = [@([_item.orderReservePriceGroup.adultNum integerValue] - 1) stringValue];
                _item.orderDealPrice = @([_item.orderDealPrice floatValue] - [_item.orderReservePriceGroup.adultPrice floatValue]);
            }
                break;
            case Kid_Bed:
            {
                _item.orderReservePriceGroup.kidBedNum = [@([_item.orderReservePriceGroup.kidBedNum integerValue] - 1) stringValue];
                _item.orderDealPrice = @([_item.orderDealPrice floatValue] - [_item.orderReservePriceGroup.kidBedPrice floatValue]);
            }
                break;
            case Kid_No_Bed:
            {
                _item.orderReservePriceGroup.kidNum = [@([_item.orderReservePriceGroup.kidNum integerValue] - 1) stringValue];
                _item.orderDealPrice = @([_item.orderDealPrice floatValue] - [_item.orderReservePriceGroup.kidPrice floatValue]);
            }
                break;
            default:
                break;
        }
        
        touristsNumPlusTow -= 2;
        [_touristsArray removeLastObject];
        _item.orderTouristGroup = [_touristsArray mutableCopy];
        
        // 删掉两行
        [_textFieldsIndexesArray removeLastObject];
        [_textFieldsIndexesArray removeLastObject];
        [_tableView reloadData];
    }
    
    // plus
    if (num > 0) {
        
        switch (type) {
            case Adult:
            {
                _item.orderReservePriceGroup.adultNum = [@([_item.orderReservePriceGroup.adultNum integerValue] + 1) stringValue];
                _item.orderDealPrice = @([_item.orderDealPrice floatValue] + [_item.orderReservePriceGroup.adultPrice floatValue]);
            }
                break;
            case Kid_Bed:
            {
                _item.orderReservePriceGroup.kidBedNum = [@([_item.orderReservePriceGroup.kidBedNum integerValue] + 1) stringValue];
                _item.orderDealPrice = @([_item.orderDealPrice floatValue] + [_item.orderReservePriceGroup.kidBedPrice floatValue]);
            }
                break;
            case Kid_No_Bed:
            {
                _item.orderReservePriceGroup.kidNum = [@([_item.orderReservePriceGroup.kidNum integerValue] + 1) stringValue];
                _item.orderDealPrice = @([_item.orderDealPrice floatValue] + [_item.orderReservePriceGroup.kidPrice floatValue]);
            }
                break;
            default:
                break;
        }
        
        touristsNumPlusTow += 2;
        TouristInfo *tourist = [[TouristInfo alloc] init];
        tourist.touristName = @"";
        tourist.touristCode = @"";
        [_touristsArray addObject:tourist];
        _item.orderTouristGroup = [_touristsArray mutableCopy];

        // 插入两行
        NSIndexPath *lastButTwoPath = [NSIndexPath indexPathForRow:touristsNumPlusTow-2 inSection:3];
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:touristsNumPlusTow-1 inSection:3];
        [_textFieldsIndexesArray addObject:lastButTwoPath];
        [_textFieldsIndexesArray addObject:lastPath];
        [_tableView reloadData];
    }
    
    _totalCostLabel.text = [NSString stringWithFormat:@"￥%@", _item.orderDealPrice];
}

#pragma mark - CreateOrderCell_Input_Delegate
- (void)setEditingCellIndexWithIndexPath:(NSIndexPath *)indexPath
{
    editingCellIndexPath = indexPath;
    [self updateToolBarButtonItemsStatusWithIndexPath:indexPath];
}

- (void)setEditingCellTextWithText:(NSString *)text
{
    if (editingCellIndexPath.section == 2) {
        if (editingCellIndexPath.row == 0) {
            _item.orderContactName = text;
        } else if (editingCellIndexPath.row == 1) {
            _item.orderContactPhone = text;
        }
    }
    
    if (editingCellIndexPath.section == 3) {
        //偶数为游客姓名
        if (editingCellIndexPath.row%2 == 0) {
            [_touristsArray[editingCellIndexPath.row/2] setTouristName:text];
        } else {
            //奇数为游客身份证号码
            [_touristsArray[editingCellIndexPath.row/2] setTouristCode:text];
        }
        _item.orderTouristGroup = [_touristsArray mutableCopy];
    }
}

- (void)supportClickWithPreviousIndexPath:(NSIndexPath *)curIndexPath
{
    NSIndexPath *indexPathToBe;
    CreateOrderCell_Input *prevCell;
    
    if (curIndexPath.section == 3 && curIndexPath.row == 0) {
        indexPathToBe = [NSIndexPath indexPathForRow:1 inSection:2];
    } else {
        indexPathToBe = [NSIndexPath indexPathForRow:curIndexPath.row-1 inSection:curIndexPath.section];
    }
    
    prevCell = (CreateOrderCell_Input *)[_tableView cellForRowAtIndexPath:indexPathToBe];
    if (!prevCell) {
        prevCell = (CreateOrderCell_Input *)[self tableView:_tableView cellForRowAtIndexPath:indexPathToBe];
    }
    [prevCell.inputTextField becomeFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        [_tableView scrollToRowAtIndexPath:editingCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
    [self updateToolBarButtonItemsStatusWithIndexPath:indexPathToBe];
}

- (void)supportClickWithNextIndexPath:(NSIndexPath *)curIndexPath
{
//    [_tableView reloadRowsAtIndexPaths:@[curIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [_tableView endUpdates];
    [_tableView reloadData];
    NSIndexPath *indexPathToBe;
    CreateOrderCell_Input *nextCell;
    
    if (curIndexPath.section == 2 && curIndexPath.row == 1) {
        indexPathToBe = [NSIndexPath indexPathForRow:0 inSection:3];
    } else {
        indexPathToBe = [NSIndexPath indexPathForRow:curIndexPath.row+1 inSection:curIndexPath.section];
    }
    
//    nextCell = (CreateOrderCell_Input *)[_tableView cellForRowAtIndexPath:indexPathToBe];
//    if (!nextCell) {
        nextCell = (CreateOrderCell_Input *)[self tableView:_tableView cellForRowAtIndexPath:indexPathToBe];
//    }
    [nextCell.inputTextField becomeFirstResponder];
    [self updateToolBarButtonItemsStatusWithIndexPath:indexPathToBe];
    
    [UIView animateWithDuration:0.4 animations:^{
        [_tableView scrollToRowAtIndexPath:editingCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
}

#pragma mark - HTTP
// status 订单状态：0：未确认 1：已确认/修改 2：已取消/取消
- (void)modifyOrder
{
    [HTTPTool modifyOrCancelMyOrderWithCompanyId:[UserModel companyId]
                                         staffId:[UserModel staffId]
                                         orderId:_item.orderLineId
                                       startDate:_item.orderStartDate
                                      returnDate:_item.orderReturnDate
                                      priceGroup:[self jsonStringFromReservePriceGroup:_item.orderReservePriceGroup]
                                   contactPerson:_item.orderContactName
                                  contactPhoneNo:_item.orderContactPhone
                                    touristGroup:[self jsonStringFromTouristGroupToDictionaryArrayWithArray:_item.orderTouristGroup]
                                      totalPrice:[_item.orderDealPrice stringValue]
                                          status:@"1"
                                         success:^(id result) {
                                             [[Global sharedGlobal] codeHudWithObject:result[@"RS100032"] succeed:^{
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDER_HAS_CONFIRMED" object:self];
                                                 
                                                 [self.navigationController popViewControllerAnimated:YES];
                                                 
                                             }];
                                         } fail:^(id result) {
                                             
                                             if ([[Global sharedGlobal] networkAvailability] == NO) {
                                                 [self networkUnavailable];
                                                 return ;
                                             }
                                             
                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
                                             [alert show];
                                         }];
}

#pragma mark - Private
- (NSString *)jsonStringFromReservePriceGroup:(ReservePriceGroup *)group
{
    if (!group) {
        return nil;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (group.adultPrice && [group.adultPrice integerValue] > 0) {
        [dict setObject:group.adultPrice forKey:@"adult_price"];
    }

    if (group.adultNum && [group.adultNum integerValue] > 0) {
        [dict setObject:group.adultNum forKey:@"adult_person"];
    }
    
    if (group.kidPrice && [group.kidPrice integerValue] > 0) {
        [dict setObject:group.kidPrice forKey:@"kid_nbed_price"];
    }
    
    if (group.kidNum && [group.kidNum integerValue] > 0) {
        [dict setObject:group.kidNum forKey:@"kid_nbed_person"];
    }
    
    if (group.kidBedNum && [group.kidBedNum integerValue] > 0) {
        [dict setObject:group.kidBedNum forKey:@"kid_person"];
    }
    
    if (group.kidBedPrice && [group.kidBedPrice integerValue] > 0) {
        [dict setObject:group.kidBedPrice forKey:@"kid_price"];
    }
    
    if (group.diffPrice && [group.diffPrice integerValue] > 0) {
        [dict setObject:group.diffPrice forKey:@"diff_price"];
    }
    
    return [self DataTOjsonString:dict];
}

- (NSString *)jsonStringFromTouristGroupToDictionaryArrayWithArray:(NSArray *)touristsArray
{
    if (!touristsArray || touristsArray.count == 0) {
        return nil;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [touristsArray enumerateObjectsUsingBlock:^(TouristInfo *tourist, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if (tourist.touristName) {
            [dict setObject:tourist.touristName forKey:@"user"];
        }
        if (tourist.touristCode) {
            [dict setObject:tourist.touristCode forKey:@"cred"];
        }
        [arr addObject:dict];
    }];
    
    return [self DataTOjsonString:arr];
}

- (NSString *)DataTOjsonString:(id)object
{
    if (!object) {
        return nil;
    }
    
    if ([object isKindOfClass:[NSArray class]]) {
        if ([object count] == 0) {
            return nil;
        }
    }
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (void)updateToolBarButtonItemsStatusWithIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:_textFieldsIndexesArray.firstObject]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TopTextFieldIsReached" object:self];
    } else if ([indexPath isEqual:_textFieldsIndexesArray.lastObject]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BottomTextFieldIsReached" object:self];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NormalTextFieldStatus" object:self];
    }
}

#pragma mark - UIKeyboard
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - notification handler
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    keyBoardHeight = endKeyboardRect.size.height;
    
    [self updateToolBarButtonItemsStatusWithIndexPath:editingCellIndexPath];
    [UIView animateWithDuration:duration animations:^{
        [_tableView setFrame:CGRectMake(_tableView.frame.origin.x,
                                            _tableView.frame.origin.y,
                                            _tableView.bounds.size.width,
                                            self.view.frame.size.height - keyBoardHeight)];
        [_tableView scrollToRowAtIndexPath:editingCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    //    NSLog(@"hide...");
    NSDictionary* info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        [_tableView setFrame:CGRectMake(_tableView.frame.origin.x,
                                            _tableView.frame.origin.y,
                                            _tableView.bounds.size.width,
                                            self.view.frame.size.height - 56.f)];
        // 滚到最下面
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:touristsNumPlusTow-1 inSection:3] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
}


- (IBAction)confirmOrderButtonClicked:(id)sender {
    if ([_item.orderReservePriceGroup.adultNum integerValue] + [_item.orderReservePriceGroup.kidBedNum integerValue] + [_item.orderReservePriceGroup.kidNum integerValue] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"人数为0，不能确认参团" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *validValueForPhoneNumber = @"^1+[3578]+\\d{9}$";
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validValueForPhoneNumber];
    if ([predict evaluateWithObject:_item.orderContactPhone] == YES) {
        [self modifyOrder];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手机号码格式不正确" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }
}
@end
