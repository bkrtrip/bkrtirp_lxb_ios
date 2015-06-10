//
//  HTTPTool.m
//  LXBtrip
//
//  Created by MACPRO on 15/5/11.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "HTTPTool.h"
#import "AFNetworking.h"

@implementation HTTPTool
singleton_implementation(HTTPTool)

// 获取在线微店列表 - LXB1111 - 未登录
+ (void)getOnlineMicroShopListWithProvince:(NSString *)province success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{@"province":province} mutableCopy];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB1111" forHTTPHeaderField:@"AUTHCODE"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"mstore/onLine"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 获取在线微店列表 - LXB1122 - 已登录
+ (void)getOnlineMicroShopListWithProvince:(NSString *)province companyId:(NSNumber *)companyId staffId:(NSNumber *)staffId success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{@"province":province} mutableCopy];
    if (companyId) {
        [param setObject:companyId forKey:@"companyid"];
    } else
        return;
    
    if (staffId) {
        [param setObject:staffId forKey:@"staffid"];
    } else
        return;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB1122" forHTTPHeaderField:@"AUTHCODE"];
    [manager.requestSerializer setValue:[UserModel userToken] forHTTPHeaderField:@"TOKEN"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"mstore/onLine"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 获取我的微店列表 - LXB1125 - 已登录
+ (void)getMyMicroShopListWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (companyId) {
        [param setObject:companyId forKey:@"companyid"];
    } else
        return;
    
    if (staffId) {
        [param setObject:staffId forKey:@"staffid"];
    } else
        return;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB1125" forHTTPHeaderField:@"AUTHCODE"];
    [manager.requestSerializer setValue:[UserModel userToken] forHTTPHeaderField:@"TOKEN"];

    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"mstore/myTemplate"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 获取我的微店列表 - LXB11148 - 未登录
+ (void)getMyMicroShopListWithSuccess:(SuccessBlock)success fail:(FailBlock)fail
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB11148" forHTTPHeaderField:@"AUTHCODE"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"mstore/myTemplate"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 删除微店 - LXB1426
+ (void)deleteMyShopWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId shopId:(NSNumber *)shopId success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{@"templateid":shopId} mutableCopy];
    if (companyId) {
        [param setObject:companyId forKey:@"companyid"];
    } else
        return;
    
    if (staffId) {
        [param setObject:staffId forKey:@"staffid"];
    } else
        return;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB1426" forHTTPHeaderField:@"AUTHCODE"];
    [manager.requestSerializer setValue:[UserModel userToken] forHTTPHeaderField:@"TOKEN"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"mstore/delTemplate"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 获取微店详情 - LXB1113
+ (void)getMicroShopDetailWithShopId:(NSNumber *)shopId success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSDictionary *param = @{@"templateid":shopId};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB1113" forHTTPHeaderField:@"AUTHCODE"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"mstore/template"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

//线路列表页 - LXB1127
+ (void)getTourListWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId templateId:(NSNumber *)templateId customId:(NSString *)customId startCity:(NSString *)startCity endCity:(NSString *)endCity dayNum:(NSNumber *)dayNum lineName:(NSString *)lineName pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{@"templateid":templateId, @"customid":customId, @"startcity":startCity, @"pagenum":pageNum} mutableCopy];
    if (companyId) {
        [param setObject:companyId forKey:@"companyid"];
    } else
        return;
    
    if (staffId) {
        [param setObject:staffId forKey:@"staffid"];
    } else
        return;
    
    if (endCity) {
        [param setObject:endCity forKey:@"endciity"];
    }
    
    if (dayNum) {
        [param setObject:dayNum forKey:@"daynum"];
    }
    
    if (lineName) {
        [param setObject:lineName forKey:@"linename"];
    }
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB1224" forHTTPHeaderField:@"AUTHCODE"];
    [manager.requestSerializer setValue:[UserModel userToken] forHTTPHeaderField:@"TOKEN"];

    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"mstore/lineList"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 添加到我的微店 - LXB1224
+ (void)addToMyShopWithShopId:(NSNumber *)shopId companyId:(NSNumber *)companyId staffId:(NSNumber *)staffId success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{@"templateid":shopId} mutableCopy];
    if (companyId) {
        [param setObject:companyId forKey:@"companyid"];
    } else
        return;
    
    if (staffId) {
        [param setObject:staffId forKey:@"staffid"];
    } else
        return;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB1224" forHTTPHeaderField:@"AUTHCODE"];
    [manager.requestSerializer setValue:[UserModel userToken] forHTTPHeaderField:@"TOKEN"];

    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"mstore/addTemplate"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 锁定微店 - LXB13244
+ (void)lockMicroshopWithShopId:(NSNumber *)shopId companyId:(NSNumber *)companyId staffId:(NSNumber *)staffId success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{@"templateid":shopId} mutableCopy];
    if (companyId) {
        [param setObject:companyId forKey:@"companyid"];
    } else
        return;
    
    if (staffId) {
        [param setObject:staffId forKey:@"staffid"];
    } else
        return;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB13244" forHTTPHeaderField:@"AUTHCODE"];
    [manager.requestSerializer setValue:[UserModel userToken] forHTTPHeaderField:@"TOKEN"];

    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"mstore/myLock"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}












// 专线/地接 - 未登录 - LXB2119
+ (void)getSuppliersListWithStartCity:(NSString *)startCity lineClass:(NSString *)lineClass lineType:(NSString *)lineType pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{@"startcity":startCity, @"lineclass":lineClass, @"pagenum":pageNum} mutableCopy];
    if (lineType) {
        [param setObject:lineType forKey:@"linetype"];
    }
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB2119" forHTTPHeaderField:@"AUTHCODE"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"supplier/onLine"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 专线/地接 - 已登录 - LXB21210
+ (void)getSuppliersListWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId StartCity:(NSString *)startCity lineClass:(NSString *)lineClass lineType:(NSString *)lineType pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{@"startcity":startCity, @"lineclass":lineClass,  @"pagenum":pageNum} mutableCopy];
    
    if (companyId) {
        [param setObject:companyId forKey:@"companyid"];
    } else
        return;
    
    if (staffId) {
        [param setObject:staffId forKey:@"staffid"];
    } else
        return;
    
    if (lineType) {
        [param setObject:staffId forKey:@"linetype"];
    }
    

    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB21210" forHTTPHeaderField:@"AUTHCODE"];
    [manager.requestSerializer setValue:[UserModel userToken] forHTTPHeaderField:@"TOKEN"];

    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"supplier/onLine"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 供应商详情 - 未登录 - LXB21115
+ (void)getSupplierDetailWithSupplierId:(NSNumber *)supplierId pageNum:(NSNumber *)pageNum isMy:(NSNumber *)isMy success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{@"supplierid":supplierId, @"pagenum":pageNum} mutableCopy];
    
    if (isMy) {
        [param setObject:isMy forKey:@"ismy"];
    } else {
        [param setObject:@"1" forKey:@"ismy"];
    }
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB21115" forHTTPHeaderField:@"AUTHCODE"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"supplier/details"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 供应商详情 - 已登录 - LXB21216
+ (void)getSupplierDetailWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId supplierId:(NSNumber *)supplierId pageNum:(NSNumber *)pageNum isMy:(NSNumber *)isMy success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{@"supplierid":supplierId, @"pagenum":pageNum, @"ismy":isMy} mutableCopy];
    
    if (companyId) {
        [param setObject:companyId forKey:@"companyid"];
    } else
        return;
    
    if (staffId) {
        [param setObject:staffId forKey:@"staffid"];
    } else
        return;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB21216" forHTTPHeaderField:@"AUTHCODE"];
    [manager.requestSerializer setValue:[UserModel userToken] forHTTPHeaderField:@"TOKEN"];

    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"supplier/details"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 我的供应商 - LXB21218
+ (void)getMySuppliersWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId lineClass:(NSString *)lineClass success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{@"lineclass":lineClass} mutableCopy];
    
    if (companyId) {
        [param setObject:companyId forKey:@"companyid"];
    } else
        return;
    
    if (staffId) {
        [param setObject:staffId forKey:@"staffid"];
    } else
        return;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB21218" forHTTPHeaderField:@"AUTHCODE"];
    [manager.requestSerializer setValue:[UserModel userToken] forHTTPHeaderField:@"TOKEN"];

    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"supplier/mySelf"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 筛选供应商 - LXB21111
+ (void)getSiftedSuppliersWithSuccess:(SuccessBlock)success fail:(FailBlock)fail
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB21111" forHTTPHeaderField:@"AUTHCODE"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"supplier/screen"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 同步/取消同步供应商 - LXB22217 - type:0同步，1取消
+ (void)syncOrCancelSyncMySupplierWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId supplierId:(NSNumber *)supplierId supplierName:(NSString *)supplierName supplierBrand:(NSString *)supplierBrand type:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{@"supplierid":supplierId, @"suppliername":supplierName, @"supplierbrand":supplierBrand, @"type":type} mutableCopy];
    
    if (companyId) {
        [param setObject:companyId forKey:@"companyid"];
    } else
        return;
    
    if (staffId) {
        [param setObject:staffId forKey:@"staffid"];
    } else
        return;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB22217" forHTTPHeaderField:@"AUTHCODE"];
    [manager.requestSerializer setValue:[UserModel userToken] forHTTPHeaderField:@"TOKEN"];

    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"supplier/ifSync"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 当地热门搜索列表 - LXB21112
+ (void)getHotSearchListWithSuccess:(SuccessBlock)success fail:(FailBlock)fail
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB21112" forHTTPHeaderField:@"AUTHCODE"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"supplier/hotSearchList"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 关键字搜索列表页 - LXB21113
+ (void)searchSupplierListWithStartCity:(NSString *)startCity lineClass:(NSString *)lineClass hotTheme:(NSString *)hotTheme keyword:(NSString *)keyword pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{@"startcity":startCity, @"lineclass":lineClass, @"pagenum":pageNum} mutableCopy];
    
    if (hotTheme) {
        [param setObject:hotTheme forKey:@"hottheme"];
    }
    
    if (keyword) {
        [param setObject:keyword forKey:@"keyword"];
    }
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB21113" forHTTPHeaderField:@"AUTHCODE"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"supplier/searchList"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 我的订单列表 - LXB41231 - 订单状态：0：未确认 1：已确认 2：已取消
+ (void)getMyOrderListWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId status:(NSString *)status pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{@"status":status, @"pagenum":pageNum} mutableCopy];
    
    if (companyId) {
        [param setObject:companyId forKey:@"companyid"];
    } else
        return;
    
    if (staffId) {
        [param setObject:staffId forKey:@"staffid"];
    } else
        return;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB41231" forHTTPHeaderField:@"AUTHCODE"];
    [manager.requestSerializer setValue:[UserModel userToken] forHTTPHeaderField:@"TOKEN"];

    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"myself/lineOrderList"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 服务商列表 - LXB31119 - 未登录
+ (void)getServiceListWithCounty:(NSString *)country province:(NSString *)province city:(NSString *)city pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSDictionary *param = @{@"country":country, @"province":province, @"city":city, @"pagenum":pageNum};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB31119" forHTTPHeaderField:@"AUTHCODE"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"join/onLine"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 服务商列表 - LXB31220 - 已登录
+ (void)getServiceListWithWithCompanyId:(NSNumber *)companyId staffId:(NSNumber *)staffId county:(NSString *)country province:(NSString *)province city:(NSString *)city pageNum:(NSNumber *)pageNum success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{@"country":country, @"province":province, @"city":city, @"pagenum":pageNum} mutableCopy];
    
    if (companyId) {
        [param setObject:companyId forKey:@"companyid"];
    } else
        return;
    
    if (staffId) {
        [param setObject:staffId forKey:@"staffid"];
    } else
        return;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB31220" forHTTPHeaderField:@"AUTHCODE"];
    [manager.requestSerializer setValue:[UserModel userToken] forHTTPHeaderField:@"TOKEN"];

    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"join/onLine"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 服务商详情 - LXB31121
+ (void)getServiceDetailWithServiceId:(NSNumber *)serviceId success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSDictionary *param = @{@"serviceid":serviceId};
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB31121" forHTTPHeaderField:@"AUTHCODE"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"join/details"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];

}























// 获取国家 - LXB51139
+ (void)getCountriesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB51139" forHTTPHeaderField:@"AUTHCODE"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"common/country"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 获取省份 - LXB51140
+ (void)getProvincesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB51140" forHTTPHeaderField:@"AUTHCODE"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"common/province"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 获取城市 - LXB51141
+ (void)getCitiesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB51141" forHTTPHeaderField:@"AUTHCODE"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"common/city"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 获取热门城市 - LXB51142
+ (void)getHotCitiesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB51142" forHTTPHeaderField:@"AUTHCODE"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"common/hotCity"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}

// 获取热门国家 - LXB51143
+ (void)getHotCountriesWithSuccess:(SuccessBlock)success fail:(FailBlock)fail
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager.requestSerializer setValue:@"LXB51143" forHTTPHeaderField:@"AUTHCODE"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", HOST_BASE_URL, @"common/hotCountry"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([self dictionaryWithBase64EncodedJsonString:operation.responseString]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
}


















#pragma mark - Private methods
+ (NSDictionary *)dictionaryWithBase64EncodedJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:jsonString options:0];
    
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:decodedData options:NSJSONReadingAllowFragments error:&error];
    return obj;
}

@end
