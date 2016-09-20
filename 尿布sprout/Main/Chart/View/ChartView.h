//
//  ChartView.h
//  尿布sprout
//
//  Created by Macbook on 16/9/18.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGBPeeColor [UIColor colorWithRed:240.0 / 255 green:184.0 / 255 blue:38.0 / 255 alpha:1]
#define RGBShitColor [UIColor colorWithRed:70.0 / 255 green:42.0 / 255 blue:20.0 / 255 alpha:1]
#define RGBBothColor [UIColor colorWithRed:120.0 / 255 green:83.0 / 255 blue:20.0 / 255 alpha:1]

@interface ChartView : UIView
@property(nonatomic, assign)NSNumber *number;
@end
