//
//  defecateTableViewCell.m
//  尿布sprout
//
//  Created by Macbook on 16/9/3.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import "DefecateTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
@implementation DefecateTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth / 3, 40)];
            
            // wctimeLabel.backgroundColor = [UIColor redColor];
            [self addSubview:_timeLabel];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor darkGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _defecateLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 3 , 0, kScreenWidth / 3, 40)];
        
        _defecateLabel.textAlignment = NSTextAlignmentCenter;
        _defecateLabel.textColor = [UIColor darkGrayColor];
        _defecateLabel.font = [UIFont systemFontOfSize:13];
       [self addSubview:_defecateLabel];
//
//        _defecateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth / 3 * 2 , 0, kScreenWidth / 3, 50)];
//        [_defecateImageView setBackgroundColor:[UIColor redColor]];
        _shitLabel = [[UILabel alloc]initWithFrame:CGRectIntegral(CGRectMake(kScreenWidth / 6 * 5 - 15, 5, 30, 30))];
        _shitLabel.backgroundColor = [UIColor lightGrayColor];
        _shitLabel.textColor = [UIColor darkGrayColor];
        _shitLabel.textAlignment = NSTextAlignmentCenter;
        _shitLabel.font = font13;
        _shitLabel.layer.cornerRadius = 15;
        _shitLabel.layer.masksToBounds = YES;
        [self addSubview:_shitLabel];
        _remarkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 35, 5, 30, 30)];
        [_remarkImageView setImage:[UIImage imageNamed:@"milestones-button-edit-entry-on-phone"]];
        [self addSubview:_remarkImageView];
        _remarkImageView.hidden = YES;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
