//
//  HTTPTool.m
//  LXBtrip
//
//  Created by MACPRO on 15/5/11.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "HTTPTool.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
@implementation HTTPTool
#pragma mark GET方式请求HTTP
+(void)getWithUrl:(NSString *)url params:(NSDictionary *)param contentType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail{
    //1.创建Http操作管理器
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    //2.设置返回类型
    if (type) {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:type];
    }
    //3.创建Http请求对象
    AFHTTPRequestOperation *op = [manager GET:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
    //4.发送请求
    [op start];
    
}
#pragma mark POST方式请求HTTP
+(void)postWithUrl:(NSString *)url params:(NSDictionary *)param contentType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail{
    //1.创建HTTP请求管理器
    AFHTTPRequestOperationManager *manager  = [AFHTTPRequestOperationManager new];
    //2.设置返回类型
    if (type) {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:type];
    }
    //3.创建HTTP请求操作对象
    AFHTTPRequestOperation *op = [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
    //4.发送请求
    [op start];
}
#pragma mark Http的multipart的POST请求,上传文件
+(void)multipartPostWithUrl:(NSString *)urlStr params:(NSDictionary *)params fileDatas:(NSArray *)datas contentType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail{
    //1.创建HTTP请求管理器
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    //2.设置返回类型
    if (type) {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:type];
    }
    //3.创建HTTP请求操作对象
    AFHTTPRequestOperation *op = [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //上传多张图片
        for (NSDictionary *dic in datas) {
            NSString *name = [dic allKeys][0];
            [formData appendPartWithFileData:dic[name] name:name fileName:@"upload.png" mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
    //4.HTTP请求操作对象开始发送请求
    [op start];
}
#pragma mark 异步下载图片
+(void)downloadImageWithUrl:(NSString *)urlStr placeholderImage:(UIImage *)image inImageView:(UIImageView *)imageView{
    NSURL *url = [NSURL URLWithString:urlStr];
    [imageView setImageWithURL:url placeholderImage:image];
}
#pragma mark 一步下载图片（系统自带）
+(void)systemDownloadImageWithUrl:(NSString *)urlStr placeholderImage:(UIImage *)image inImageView:(UIImageView *)imageView{
    //设置默认图片
    imageView.image = image;
    //异步下载图片
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr] options:NSDataReadingMappedIfSafe error:&error];
        if (error) {
            NSLog(@"图片下载失败");
        }
        else{
            //主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData:data];
            });
        }
    });
    
}

@end
