//
//  QALoadViewTools.h
//  QianAiMall
//
//  Created by qianyuan on 2017/6/21.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QALoadViewTools : NSObject

/**
 *  加载Xib - xibName(string),owner
 */
id loadViewFromXibWithName(NSString *xibName,id owner);
/**
 *  加载ViewController - storyBoardName(string),identifier(string)
 */
id loadViewControllerFromStoryboard(NSString *name,NSString *identifier);

@end
