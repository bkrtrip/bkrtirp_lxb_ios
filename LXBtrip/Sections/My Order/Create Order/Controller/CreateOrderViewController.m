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
#import "CreateOrderCell_Confirm.h"
#import "CreateOrderCell_Input.h"
#import "CreateOrderCell_Price.h"
#import "CreateOrderCell_StartOrEndDate.h"

@interface CreateOrderViewController ()<UITableViewDataSource, UITableViewDelegate, CreateOrderCell_Confirm_Delegate, CreateOrderCell_Price_Delegate, CreateOrderCell_Input_Delegate>
{
    CGFloat keyBoardHeight;
    NSInteger touristsNumPlusTow;
    NSIndexPath *editingCellIndexPath;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSMutableArray *textFieldsIndexesArray;
@property (copy, nonatomic) NSString *contactName;
@property (copy, nonatomic) NSString *contactPhone;
@property (copy, nonatomic) NSMutableArray *touristsArray;

@end

@implementation CreateOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"线路订单";
    [_tableView registerNib:[UINib nibWithNibName:@"CreateOrderCell_OrderId" bundle:nil] forCellReuseIdentifier:@"CreateOrderCell_OrderId"];
    [_tableView registerNib:[UINib nibWithNibName:@"CreateOrderCell_BookHeader" bundle:nil] forCellReuseIdentifier:@"CreateOrderCell_BookHeader"];
    [_tableView registerNib:[UINib nibWithNibName:@"CreateOrderCell_Confirm" bundle:nil] forCellReuseIdentifier:@"CreateOrderCell_Confirm"];
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
    touristsNumPlusTow = totalNum * 2; // 乘以二统计旅客信息的texfield个数
    
    _textFieldsIndexesArray = [[NSMutableArray alloc] init];
    [_textFieldsIndexesArray addObject:[NSIndexPath indexPathForRow:0 inSection:2]];
    [_textFieldsIndexesArray addObject:[NSIndexPath indexPathForRow:1 inSection:2]];
    for (int i = 0; i < touristsNumPlusTow; i++) {
        [_textFieldsIndexesArray addObject:[NSIndexPath indexPathForRow:i inSection:3]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self registerNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotification];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 6;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return touristsNumPlusTow;
            break;
        case 4:
            return 1;
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
                    [cell setCellContentWithTitle:@"出发日期" date:_item.orderStartDate];
                    return cell;
                }
                    break;
                case 2:
                {
                    CreateOrderCell_StartOrEndDate *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_StartOrEndDate" forIndexPath:indexPath];
                    [cell setCellContentWithTitle:@"返程日期" date:_item.orderReturnDate];
                    return cell;
                }
                    break;
                case 3:
                {
                    CreateOrderCell_Price *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_Price" forIndexPath:indexPath];
                    [cell setCellContentWithOrder:_item touristType:Adult];
                    cell.delegate = self;
                    return cell;
                }
                    break;
                case 4:
                {
                    CreateOrderCell_Price *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_Price" forIndexPath:indexPath];
                    [cell setCellContentWithOrder:_item touristType:Kid_Bed];
                    cell.delegate = self;
                    return cell;
                }
                    break;
                case 5:
                {
                    CreateOrderCell_Price *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_Price" forIndexPath:indexPath];
                    [cell setCellContentWithOrder:_item touristType:Kid_No_Bed];
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
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    CreateOrderCell_Input *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_Input" forIndexPath:indexPath];
                    [cell setCellContentWithInputType:@"联系人：" section:2 row:0];
                    cell.delegate = self;
//                    if ([_textFieldsIndexesArray containsObject:indexPath] == NO) {
//                        // 联系人 index=0
//                        [_textFieldsIndexesArray insertObject:indexPath atIndex:0];
//                    }
                    return cell;
                }
                    break;
                case 1:
                {
                    CreateOrderCell_Input *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_Input" forIndexPath:indexPath];
                    [cell setCellContentWithInputType:@"手机号码：" section:2 row:1];
                    cell.separatorInset = UIEdgeInsetsMake(0, 414, 0, 0);
                    cell.delegate = self;
//                    if ([_textFieldsIndexesArray containsObject:indexPath] == NO) {
//                        // 手机号码 index=1
//                        [_textFieldsIndexesArray insertObject:indexPath atIndex:1];
//                    }
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
                    [cell setCellContentWithInputType:@"游客姓名：" section:3 row:indexPath.row];
                    cell.delegate = self;
//                    if ([_textFieldsIndexesArray containsObject:indexPath] == NO) {
//                        // 手机号码 index=1
//                        [_textFieldsIndexesArray insertObject:indexPath atIndex:indexPath.row + 2];
//                    }
                    return cell;
                }
                    break;
                case 1:
                {
                    CreateOrderCell_Input *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_Input" forIndexPath:indexPath];
                    [cell setCellContentWithInputType:@"身份证号：" section:3 row:indexPath.row];
                    cell.delegate = self;
//                    if ([_textFieldsIndexesArray containsObject:indexPath] == NO) {
//                        // 手机号码 index=1
//                        [_textFieldsIndexesArray insertObject:indexPath atIndex:indexPath.row + 2];
//                    }
                    return cell;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 4:
        {
            CreateOrderCell_Confirm *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateOrderCell_Confirm" forIndexPath:indexPath];
            [cell setCellContentWithOrder:_item];
            cell.delegate = self;
            return cell;
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
            return 106.f;
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 5:
                    return 93.f;
                    break;
                default:
                    return 57.f;
                    break;
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
            if (indexPath.row == _item.orderTouristGroup.count-1) {
                return 67.f;
            } else {
                return 57.f;
            }
        }
            break;
        case 4:
            return 57.f;
            break;
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - CreateOrderCell_Confirm_Delegate
- (void)supportClickConfirmModification
{
    [self modifyOrder];
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
            }
                break;
            case Kid_Bed:
            {
                _item.orderReservePriceGroup.kidBedNum = [@([_item.orderReservePriceGroup.kidBedNum integerValue] - 1) stringValue];
            }
                break;
            case Kid_No_Bed:
            {
                _item.orderReservePriceGroup.kidNum = [@([_item.orderReservePriceGroup.kidNum integerValue] - 1) stringValue];
            }
                break;
            default:
                break;
        }
        
        touristsNumPlusTow -= 2;
        [_touristsArray removeLastObject];
        // 删掉两行
        NSIndexPath *lastPath = [_textFieldsIndexesArray lastObject];
        [_textFieldsIndexesArray removeLastObject];
        NSIndexPath *lastButTwoPath = [_textFieldsIndexesArray lastObject];
        [_textFieldsIndexesArray removeLastObject];
        
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:lastPath, lastButTwoPath, nil] withRowAnimation:UITableViewRowAnimationRight];
    }
    
    // plus
    if (num > 0) {
        
        switch (type) {
            case Adult:
            {
                _item.orderReservePriceGroup.adultNum = [@([_item.orderReservePriceGroup.adultNum integerValue] + 1) stringValue];
            }
                break;
            case Kid_Bed:
            {
                _item.orderReservePriceGroup.kidBedNum = [@([_item.orderReservePriceGroup.kidBedNum integerValue] + 1) stringValue];
            }
                break;
            case Kid_No_Bed:
            {
                _item.orderReservePriceGroup.kidNum = [@([_item.orderReservePriceGroup.kidNum integerValue] + 1) stringValue];
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
        // 插入两行
        NSIndexPath *lastButTwoPath = [NSIndexPath indexPathForRow:touristsNumPlusTow-2 inSection:3];
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:touristsNumPlusTow-1 inSection:3];
        [_textFieldsIndexesArray addObject:lastButTwoPath];
        [_textFieldsIndexesArray addObject:lastPath];
        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:lastPath, lastButTwoPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
    }
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
            _contactName = text;
        } else if (editingCellIndexPath.row == 1) {
            _contactPhone = text;
        }
    }
    
    if (editingCellIndexPath.section == 3) {
        _touristsArray[editingCellIndexPath.row] = text;
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
    NSIndexPath *indexPathToBe;
    CreateOrderCell_Input *nextCell;
    
    if (curIndexPath.section == 2 && curIndexPath.row == 1) {
        indexPathToBe = [NSIndexPath indexPathForRow:0 inSection:3];
    } else {
        indexPathToBe = [NSIndexPath indexPathForRow:curIndexPath.row+1 inSection:curIndexPath.section];
    }
    
    nextCell = (CreateOrderCell_Input *)[_tableView cellForRowAtIndexPath:indexPathToBe];
    if (!nextCell) {
        nextCell = (CreateOrderCell_Input *)[self tableView:_tableView cellForRowAtIndexPath:indexPathToBe];
    }
    [nextCell.inputTextField becomeFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        [_tableView scrollToRowAtIndexPath:editingCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
    [self updateToolBarButtonItemsStatusWithIndexPath:indexPathToBe];
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
    if (group.adultPrice) {
        [dict setObject:group.adultPrice forKey:@"adult_price"];
    }
    if (group.adultNum) {
        [dict setObject:group.adultNum forKey:@"adult_person"];
    }
    if (group.kidPrice) {
        [dict setObject:group.kidPrice forKey:@"kid_price"];
    }
    if (group.kidBedPrice) {
        [dict setObject:group.kidBedPrice forKey:@"kid_bed_price"];
    }
    if (group.kidNum) {
        [dict setObject:group.kidNum forKey:@"kid_person"];
    }
    if (group.kidBedNum) {
        [dict setObject:group.kidBedNum forKey:@"kid_bed_person"];
    }
    if (group.diffPrice) {
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
        if (tourist.touristCode) {
            [dict setObject:tourist.touristCode forKey:@"tourist_code"];
        }
        if (tourist.touristName) {
            [dict setObject:tourist.touristName forKey:@"tourist_name"];
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
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        [_tableView setFrame:CGRectMake(_tableView.frame.origin.x,
                                            _tableView.frame.origin.y,
                                            _tableView.bounds.size.width,
                                            self.view.frame.size.height)];
        // 滚到最下面
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
}


@end
