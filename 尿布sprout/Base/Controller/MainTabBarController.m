//
//  MainTabBarController.m
//  尿布sprout
//
//  Created by Macbook on 16/8/26.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import "MainTabBarController.h"
#define kTabBarSpaceWidth 15
#define kTabBarButtonWidth 35
@interface MainTabBarController(){
}
@end
@implementation MainTabBarController
- (instancetype)init
{
    self = [super init];
    if (self) {
        //添加tabbar子视图
        [self createSubViewController];
        //添加自定义按钮
        [self createCustomTabbar];
        
    }
    return self;
}
- (void)createSubViewController{
    NSArray *storyboardNames = @[@"Home",@"Total",@"Chart",@"Email",@"AddLost"];
    NSMutableArray *viewControllerArray = [[NSMutableArray alloc]init];
    for (NSString *storyboardName in storyboardNames) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        UINavigationController *navigationController = [storyboard instantiateInitialViewController];
        [viewControllerArray addObject:navigationController];
        
        
    }
    self.viewControllers = [viewControllerArray copy];
}
- (void)createCustomTabbar{
    //移除原有按钮 212 70
    for (UIView *view in self.tabBar.subviews) {
        Class buttonClass = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:buttonClass]) {
            [view removeFromSuperview];
        }
    }
    //添加自定义按钮
//    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeCustom];
//    button5.frame = CGRectMake(kScreenWidth - 106 , 0, 106, 49);
//    [button5 setImage:[UIImage imageNamed:@"tabbarButton5"] forState:UIControlStateNormal];
//    [self.tabBar addSubview:button5];
//    button5.tag = 105;
//    [button5 addTarget:self action:@selector(tabBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *nameArray = @[@"今天",@"全部",@"图表",@"邮件",@"遗漏"];
    CGFloat tabBarButtonWidth = kScreenWidth / 5;
    _shawImageView = [[UIImageView alloc]init];
    _shawImageView.frame = CGRectMake(0, 0, tabBarButtonWidth, 49);
    for (int i = 0; i < 5; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabbarButton%i", i + 1]] forState:UIControlStateNormal];
        button.frame = CGRectMake(tabBarButtonWidth * i + (tabBarButtonWidth - 30) / 2, 0 , 30, 30);
        [self.tabBar addSubview:button];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(tabBarButtonWidth * i, 27, tabBarButtonWidth, 15)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = nameArray[i];
        label.font = [UIFont systemFontOfSize:10];
        [self.tabBar addSubview:label];
        UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        actionButton.frame = CGRectMake(tabBarButtonWidth * i, 0, tabBarButtonWidth, 49);
        actionButton.tag = 101 + i;
        [actionButton addTarget:self action:@selector(tabBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:actionButton];
        if (i == 0) {
            _shawImageView.center = actionButton.center;
        }
    
    }
    //添加阴影视图
    
    _shawImageView.image = [UIImage imageNamed:@"home_bottom_tab_arrow2"];
    [self.tabBar addSubview:_shawImageView];
    
}
- (void)tabBarButtonAction:(UIButton *)button{
    self.selectedIndex = button.tag - 101;

    
        [UIView animateWithDuration:0.3 animations:^{
            _shawImageView.center = button.center;

    }];
    
}
-(void)viewDidLoad{
    
}
@end
