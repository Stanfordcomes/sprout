//
//  BaseNavigationController.m
//  尿布sprout
//
//  Created by Macbook on 16/8/26.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import "BaseNavigationController.h"

@implementation BaseNavigationController
-(void)viewDidLoad{
    //设置导航栏字体颜色
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationBar.titleTextAttributes = attribute;
    self.navigationBar.translucent = YES;
    UIColor *color = [UIColor colorWithRed:116.0 / 255 green:177.0 / 255 blue:165.0 / 255 alpha:1];
    [self.navigationBar setBarTintColor:color];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end
