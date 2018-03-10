
//
//  QYNetworkManager.m
//  SimulateForSaltedfish
//
//  Created by qianyuan on 17/3/3.
//  Copyright © 2017年 飘风七叶. All rights reserved.
//

#import "QYNetworkManager.h"
#import <AFNetworking.h>
#import "AFURLSessionManager.h"
@implementation QYNetworkManager
/**
 *  方法作用:GET请求
 *
 *  @param urlStr   数据请求接口地址
 *  @param dic      接口请求数据参数
 *  @param finsh    数据请求成功的回调
 *  @param conError 数据请求失败的回调
 */
+(void)RequestGETWithURLStr:(NSString *)urlStr parDic:(NSDictionary *)dic Finish:(void(^)(id resobject))finsh conError:(void(^)(NSError *error))conError {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/JavaScript", nil];
    [manager GET:urlStr parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        // 请求数据的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据请求完成的回调
        finsh(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 数据请求失败的回调
        conError(error);
    }];
}

/**
 *  方法作用:POST请求
 *
 *  @param urlStr   数据请求接口地址
 *  @param dic      接口请求数据参数
 *  @param finsh    数据请求成功的回调
 *  @param conError 数据请求失败的回调
 */
+(void)RequestPOSTWithURLStr:(NSString *)urlStr parDic:(NSDictionary *)dic Finish:(void(^)(id resobject))finsh conError:(void(^)(NSError *error))conError {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/JavaScript", nil];
    [manager POST:urlStr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        // 请求数据的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据请求完成的回调
            finsh(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 数据请求失败的回调
        conError(error);
    }];
}

+ (void)CommentPicWithUrl:(NSString *)url
                      Dic:(NSDictionary *)dic//上传图片时可能有的附加条件如userid;
               withImages:(NSDictionary *)imageDic//存图片的字典
                  success:(void (^)(NSDictionary *))success
                    faile:(void (^)(NSError *))faile
{
    //    NSString *urlStr = @"上传到的地址";
    AFHTTPSessionManager *Manager = [AFHTTPSessionManager manager];
    Manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    [Manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
    //        for (id key in imageDic) {
    //            UIImage *image = [imageDic objectForKey:key];
    //            //FileData:图片压缩后的data类型
    //            //name: 后台规定的key
    //            //fileName:自己给文件起名
    //            //mimeType :图片类型
    //            [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:[NSString stringWithFormat:@"%@",key] fileName:[NSString stringWithFormat:@"%@.png",key] mimeType:@"image/png"];
    //        }
    //    }success:^(AFHTTPRequestOperation *operation, id responseObject){
    //
    //        success(responseObject);
    //    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
    //
    //        faile(error);
    //    }];
    [Manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (id key in imageDic) {
            UIImage *image = [imageDic objectForKey:key];
            //FileData:图片压缩后的data类型
            //name: 后台规定的key
            //fileName:自己给文件起名
            //mimeType :图片类型
            NSData *data;
            if (UIImagePNGRepresentation(image)) {
                data = UIImagePNGRepresentation(image);
            }else{
                data = UIImageJPEGRepresentation(image, 1.0);
            }
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"%@",key] fileName:[NSString stringWithFormat:@"%@.png",key] mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faile(error);
    }];
}

@end
