//
//  QYNetworkManager.h
//  SimulateForSaltedfish
//
//  Created by qianyuan on 17/3/3.
//  Copyright © 2017年 飘风七叶. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYNetworkManager : NSObject
/**
 *  方法作用:GET请求
 *
 *  @param urlStr   数据请求接口地址
 *  @param dic      接口请求数据参数
 *  @param finsh    数据请求成功的回调
 *  @param conError 数据请求失败的回调
 */
+(void)RequestGETWithURLStr:(NSString *)urlStr parDic:(NSDictionary *)dic Finish:(void(^)(id resobject))finsh conError:(void(^)(NSError *error))conError;
/**
 *  方法作用:POST请求
 *
 *  @param urlStr   数据请求接口地址
 *  @param dic      接口请求数据参数
 *  @param finsh    数据请求成功的回调
 *  @param conError 数据请求失败的回调
 */
+(void)RequestPOSTWithURLStr:(NSString *)urlStr parDic:(NSDictionary *)dic Finish:(void(^)(id resobject))finsh conError:(void(^)(NSError *error))conError;

+ (void)CommentPicWithUrl:(NSString *)url
                      Dic:(NSDictionary *)dic//上传图片时可能有的附加条件如userid;
               withImages:(NSDictionary *)imageDic//存图片的字典
                  success:(void (^)(NSDictionary *))success
                    faile:(void (^)(NSError *))faile;
@end
