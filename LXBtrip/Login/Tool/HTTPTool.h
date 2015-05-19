//
//  HTTPTool.h
//  LXBtrip
//
//  Created by MACPRO on 15/5/11.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HTTPTool : NSObject
// 5.请求成功时的回调代码块
typedef void(^SuccessBlock)(id responseObject); // 成功时回调的代码块
typedef void(^FailBlock)(NSError *error); // 失败时回调的代码块
/*
 *GET方式请求HTTP/ POST方式请求HTTP
 *url:url字符串
 *params:参数
 *contentType:接收响应类型
 *success:请求成功代码块
 *fail：请求失败代码块
 */
+(void)getWithUrl:(NSString *)url params:(NSDictionary *)param contentType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail;

+(void)postWithUrl:(NSString *)url params:(NSDictionary *)param contentType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail;

/*
 * Http的multipart的POST请求（上传文件用）
 */
+ (void)multipartPostWithUrl:(NSString *)urlStr params:(NSDictionary *)params fileDatas:(NSArray *)datas contentType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail;
/*
 * 异步下载图片(AFNetworking)
 */
+ (void)downloadImageWithUrl:(NSString *)urlStr placeholderImage:(UIImage *)image inImageView:(UIImageView *)imageView;

/*
 * 异步下载图片(系统方法)
 */
+ (void)systemDownloadImageWithUrl:(NSString *)urlStr placeholderImage:(UIImage *)image inImageView:(UIImageView *)imageView;

@end
