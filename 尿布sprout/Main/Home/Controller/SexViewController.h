//
//  SexViewController.h
//  尿布sprout
//
//  Created by Macbook on 16/8/30.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReturnSexBlock)(NSString *sex);
@interface SexViewController : UIViewController
@property (nonatomic, copy)ReturnSexBlock sexBlock;
- (void)returnSexBlock:(ReturnSexBlock)block;
@end
