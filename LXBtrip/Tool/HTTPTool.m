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
    // TEST
    province = @"陕西";
    // TEST
    
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
    // TEST
    province = @"陕西";
    // TEST
    
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
    NSMutableDictionary *param;
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

// 添加到我的微店 - LXB1224
+ (void)addToMyShopWithShopId:(NSNumber *)shopId companyId:(NSNumber *)companyId staffId:(NSNumber *)staffId success:(SuccessBlock)success fail:(FailBlock)fail
{
    NSMutableDictionary *param = [@{shopId:@"templateid"} mutableCopy];
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
    NSMutableDictionary *param = [@{@"startcity":startCity, @"lineclass":lineClass, @"linetype":lineType, @"pagenum":pageNum} mutableCopy];
    
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
    [manager.requestSerializer setValue:@"LXB21210" forHTTPHeaderField:@"AUTHCODE"];
    
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


















#pragma mark - Private methods
+ (NSDictionary *)dictionaryWithBase64EncodedJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:jsonString options:0];
    
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:decodedData options:NSJSONReadingMutableContainers error:&error];
    return obj;
}









//#pragma mark -
//#pragma mark - Private methods
//#pragma mark GET方式请求HTTP
//+(void)getWithUrl:(NSString *)url params:(NSDictionary *)param contentType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail{
//    //1.创建Http操作管理器
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
//    //2.设置返回类型
//    if (type) {
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:type];
//    }
//    //3.创建Http请求对象
//    [manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (fail) {
//            fail(error);
//        }
//    }];
//    //4.发送请求
////    [op start];
//    
//}
//#pragma mark POST方式请求HTTP
//+(void)postWithUrl:(NSString *)url params:(NSDictionary *)param contentType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail{
//    //1.创建HTTP请求管理器
//    AFHTTPRequestOperationManager *manager  = [AFHTTPRequestOperationManager new];
//    //2.设置返回类型
//    if (type) {
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:type];
//    }
//    //3.创建HTTP请求操作对象
//    [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (fail) {
//            fail(error);
//        }
//    }];
//    //4.发送请求
////    [op start];
//}
//#pragma mark Http的multipart的POST请求,上传文件
//+(void)multipartPostWithUrl:(NSString *)urlStr params:(NSDictionary *)params fileDatas:(NSArray *)datas contentType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail{
//    //1.创建HTTP请求管理器
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
//    //2.设置返回类型
//    if (type) {
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:type];
//    }
//    //3.创建HTTP请求操作对象
//    AFHTTPRequestOperation *op = [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        //上传多张图片
//        for (NSDictionary *dic in datas) {
//            NSString *name = [dic allKeys][0];
//            [formData appendPartWithFileData:dic[name] name:name fileName:@"upload.png" mimeType:@"image/png"];
//        }
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (fail) {
//            fail(error);
//        }
//    }];
//    //4.HTTP请求操作对象开始发送请求
//    [op start];
//}
//#pragma mark 异步下载图片
//+(void)downloadImageWithUrl:(NSString *)urlStr placeholderImage:(UIImage *)image inImageView:(UIImageView *)imageView{
//    NSURL *url = [NSURL URLWithString:urlStr];
//    [imageView setImageWithURL:url placeholderImage:image];
//}
//#pragma mark 一步下载图片（系统自带）
//+(void)systemDownloadImageWithUrl:(NSString *)urlStr placeholderImage:(UIImage *)image inImageView:(UIImageView *)imageView{
//    //设置默认图片
//    imageView.image = image;
//    //异步下载图片
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSError *error = nil;
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr] options:NSDataReadingMappedIfSafe error:&error];
//        if (error) {
//            NSLog(@"图片下载失败");
//        }
//        else{
//            //主线程更新UI
//            dispatch_async(dispatch_get_main_queue(), ^{
//                imageView.image = [UIImage imageWithData:data];
//            });
//        }
//    });
//    
//}

@end
