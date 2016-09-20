//
//  ChartView.m
//  尿布sprout
//
//  Created by Macbook on 16/9/18.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import "ChartView.h"
#define kHeight self.frame.size.height
#define kWidth self.frame.size.width
#define kZWidth 20
#define kMWidth 6

@interface ChartView(){
    NSArray *_fetchResult;
    NSArray *_weekArray;
}
@end
@implementation ChartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect{
    _fetchResult = [app fetchChild];
    if ([_number intValue] == 1) {
        [self monthDraw];
    }else{
    [self drawStrLine];
    }
}
- (void)drawStrLine
{
    //1、获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2、设置需要绘制的图形（当前为直线）
    CGContextMoveToPoint(context, 50, 0);
    //设置其他连接点
    CGContextAddLineToPoint(context, 50, kHeight - 60);
    CGContextAddLineToPoint(context, kWidth - 30, kHeight - 60);
    
    CGContextMoveToPoint(context, 50, 0);
    
    
    
    //写间隔点

    //3、设置需要绘制的属性 （颜色，边框，阴影等）
    
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
  
    //设置线的宽度
    CGContextSetLineWidth(context, 4);
    
    //    填充的颜色，如果不是一个封闭区间
   // CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    
    //4、开始绘制  fill 填充区域 stroke 路径
    CGContextDrawPath(context, kCGPathStroke);
    CGContextSetLineWidth(context, 3);
    
    //    填充的颜色，如果不是一个封闭区间
    // CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    
    //4、开始绘制  fill 填充区域 stroke 路径
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M月dd日"];
    NSMutableArray *dateArray = [NSMutableArray array];
    NSDate *date = [NSDate date];
    float interval = [date timeIntervalSince1970] ;
    for (int i = 0; i < 7; i ++) {
        NSDate *oneDate = [NSDate dateWithTimeIntervalSince1970:interval - i * 24 * 3600];
        NSString *dateString = [dateFormatter stringFromDate:oneDate];
        [dateArray addObject:dateString];
    }
    for (int i = 1; i < 8; i ++) {
        
        CGContextMoveToPoint(context, (kWidth - 100) / 7 * i + 50, kHeight - 60);
        //设置其他连接点
        CGContextAddLineToPoint(context,  (kWidth - 100) / 7 * i + 50, kHeight - 55);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kWidth - 100) / 7 * i + 50 - 7.5, kHeight - 55, 15, 50)];
        label.numberOfLines = 0;
        label.text = dateArray[7 - i];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkGrayColor];
        [self addSubview:label];
        
    }
    CGContextDrawPath(context, kCGPathStroke);

    int max = 0;
    for (NSDictionary *dic in _fetchResult) {
        //比较日前
       int day = [self compare: (Defecate *)((NSArray *)dic[@"data"]).firstObject];
        if (day < 7) {
            if ([dic[@"total"] intValue] > max) {
                max = [dic[@"total"] intValue];
            }
        }else{
            break;
            
        }
    }
    float oneHeight = (kHeight - 100) / max;
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    for (int i = 1; i < max + 2; i ++) {
        CGContextMoveToPoint(context, 50, kHeight - 60 - oneHeight * i - 1);
        //设置其他连接点
        CGContextAddLineToPoint(context, kWidth - 30, kHeight - 60 - oneHeight * i - 1);
        CGContextDrawPath(context, kCGPathStroke);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(33,  kHeight - 60 - oneHeight * i - 1, 15, 10)];
        label.text = [NSString stringWithFormat:@"%d", i];
        [self addSubview:label];
        label.font = [UIFont systemFontOfSize:10];
    }
    CGContextSetLineWidth(context, 0);
    for (NSDictionary *dic in _fetchResult) {
        //比较日前
        int day = [self compare: (Defecate *)((NSArray *)dic[@"data"]).firstObject];
        if (day < 7) {
            CGContextSetFillColorWithColor(context, RGBPeeColor.CGColor);
            CGContextAddRect(context, CGRectMake((kWidth - 100) / 7 * (7 - day) + 50 - kZWidth / 2,kHeight - 60 - [dic[@"pee"] intValue] * oneHeight - 1.5, kZWidth, [dic[@"pee"] intValue] * oneHeight));
            CGContextDrawPath(context, kCGPathFillStroke);
            CGContextSetFillColorWithColor(context, RGBShitColor.CGColor);
            CGContextAddRect(context, CGRectMake((kWidth - 100) / 7 * (7 - day) + 50 - kZWidth / 2,kHeight - 60 - [dic[@"pee"] intValue] * oneHeight - 1.5 - [dic[@"shit"] intValue] * oneHeight, kZWidth, [dic[@"shit"] intValue] * oneHeight));
            CGContextDrawPath(context, kCGPathFillStroke);
            CGContextSetFillColorWithColor(context, RGBBothColor.CGColor);
            CGContextAddRect(context, CGRectMake((kWidth - 100) / 7 * (7 - day) + 50 - kZWidth / 2,kHeight - 60 - [dic[@"pee"] intValue] * oneHeight - 1.5 - [dic[@"shit"] intValue] * oneHeight - [dic[@"both"] intValue] * oneHeight, kZWidth, [dic[@"both"] intValue] * oneHeight));
            CGContextDrawPath(context, kCGPathFillStroke);
    }else{
        break;
    }

 }

}
- (void)monthDraw{
            CGContextRef context = UIGraphicsGetCurrentContext();
        
        //2、设置需要绘制的图形（当前为直线）
        CGContextMoveToPoint(context, 50, 0);
        //设置其他连接点
        CGContextAddLineToPoint(context, 50, kHeight - 60);
        CGContextAddLineToPoint(context, kWidth - 30, kHeight - 60);
        
        CGContextMoveToPoint(context, 50, 0);
        
        
        
        //写间隔点
        
        //3、设置需要绘制的属性 （颜色，边框，阴影等）
        
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        
        //设置线的宽度
        CGContextSetLineWidth(context, 4);
        
        //    填充的颜色，如果不是一个封闭区间
        // CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        
        //4、开始绘制  fill 填充区域 stroke 路径
        CGContextDrawPath(context, kCGPathStroke);
        CGContextSetLineWidth(context, 3);
        
        //    填充的颜色，如果不是一个封闭区间
        // CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        
        //4、开始绘制  fill 填充区域 stroke 路径
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M月dd日"];
        NSMutableArray *dateArray = [NSMutableArray array];
        NSDate *date = [NSDate date];
        float interval = [date timeIntervalSince1970] ;
        for (int i = 0; i < 30; i ++) {
            NSDate *oneDate = [NSDate dateWithTimeIntervalSince1970:interval - i * 24 * 3600];
            NSString *dateString = [dateFormatter stringFromDate:oneDate];
            [dateArray addObject:dateString];
        }
        for (int i = 1; i < 31; i ++) {
            
            CGContextMoveToPoint(context, (kWidth - 100) / 30 * i + 50, kHeight - 60);
            //设置其他连接点
            CGContextAddLineToPoint(context,  (kWidth - 100) / 30 * i + 50, kHeight - 55);
            if (i % 2 == 0) {
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kWidth - 100) / 30 * i + 50 - 7.5, kHeight - 55, 15, 50)];
                label.numberOfLines = 0;
                label.text = dateArray[30 - i];
                label.font = [UIFont systemFontOfSize:10];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor darkGrayColor];
                [self addSubview:label];
            }
            
        }
        CGContextDrawPath(context, kCGPathStroke);
        
        int max = 0;
        for (NSDictionary *dic in _fetchResult) {
            //比较日前
            int day = [self compare: (Defecate *)((NSArray *)dic[@"data"]).firstObject];
            if (day < 30) {
                if ([dic[@"total"] intValue] > max) {
                    max = [dic[@"total"] intValue];
                }
            }else{
                break;
                
            }
        }
        float oneHeight = (kHeight - 100) / max;
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        
        for (int i = 1; i < max + 2; i ++) {
            CGContextMoveToPoint(context, 50, kHeight - 60 - oneHeight * i - 1);
            //设置其他连接点
            CGContextAddLineToPoint(context, kWidth - 30, kHeight - 60 - oneHeight * i - 1);
            CGContextDrawPath(context, kCGPathStroke);
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(33,  kHeight - 60 - oneHeight * i - 1, 15, 10)];
            label.text = [NSString stringWithFormat:@"%d", i];
            [self addSubview:label];
            label.font = [UIFont systemFontOfSize:10];
        }
        CGContextSetLineWidth(context, 0);
        for (NSDictionary *dic in _fetchResult) {
            //比较日前
            int day = [self compare: (Defecate *)((NSArray *)dic[@"data"]).firstObject];
            if (day < 7) {
                CGContextSetFillColorWithColor(context, RGBPeeColor.CGColor);
                CGContextAddRect(context, CGRectMake((kWidth - 100) / 30 * (30 - day) + 50 - kMWidth / 2,kHeight - 60 - [dic[@"pee"] intValue] * oneHeight - 1.5, kMWidth, [dic[@"pee"] intValue] * oneHeight));
                CGContextDrawPath(context, kCGPathFillStroke);
                CGContextSetFillColorWithColor(context, RGBShitColor.CGColor);
                CGContextAddRect(context, CGRectMake((kWidth - 100) / 30 * (30 - day) + 50 - kMWidth / 2,kHeight - 60 - [dic[@"pee"] intValue] * oneHeight - 1.5 - [dic[@"shit"] intValue] * oneHeight, kMWidth, [dic[@"shit"] intValue] * oneHeight));
                CGContextDrawPath(context, kCGPathFillStroke);
                CGContextSetFillColorWithColor(context, RGBBothColor.CGColor);
                CGContextAddRect(context, CGRectMake((kWidth - 100) / 30 * (30 - day) + 50 - kMWidth / 2,kHeight - 60 - [dic[@"pee"] intValue] * oneHeight - 1.5 - [dic[@"shit"] intValue] * oneHeight - [dic[@"both"] intValue] * oneHeight, kMWidth, [dic[@"both"] intValue] * oneHeight));
                CGContextDrawPath(context, kCGPathFillStroke);
            }else{
                break;
            }
            
        }
        
    
}
- (int)compare:(Defecate *)defecate{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    //获取今天早上零点的时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSArray *timeArray = [dateString componentsSeparatedByString:@":"];
    
    float tonight =([timeArray[0] intValue] - 8) * 3600 + [timeArray[1] intValue] * 60 + [timeArray[2] intValue];
    NSTimeInterval tonightInterval = tonight;
    NSDate *tonightDate = [NSDate dateWithTimeIntervalSinceNow: -tonightInterval];
    //  NSLog(@"%@",defecateResult);
    float clock0Interval = [tonightDate timeIntervalSince1970] - 8 * 3600;
    for (int i = 0; i < 30; i ++) {
        
        if ([defecate.timeInterval floatValue]> clock0Interval - 24 * 3600 * i) {
            return i;
        }
    }
    return 100;
}
//设置间隔点
@end
