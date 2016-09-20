//
//  BrithdayViewController.m
//  尿布sprout
//
//  Created by Macbook on 16/8/30.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import "BrithdayViewController.h"
#import "AddMoreTableViewController.h"
@class AddMoreTableViewController;
static NSDate *lastDate;
@interface BrithdayViewController ()
{
    NSDateFormatter *dateFormatter;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation BrithdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (lastDate) {
        
        _datePicker.date = lastDate;
    }
    //这种方式获取到的类并不是和之前拿到数据类的同一个类
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    
    NSString *dateString = [dateFormatter stringFromDate:_datePicker.date];
    [self dateValueChange];
    [_datePicker addTarget:self action:@selector(dateValueChange) forControlEvents:UIControlEventValueChanged];
    
    _birthdayLabel.text = dateString;
    //NSLog(@"%@",_birthdayLabel.text);
    //_ageLabel.text = @"新生";
    
// Do any additional setup after loading the view.
}

- (void)dateValueChange{
    lastDate = _datePicker.date;
    _birthdayLabel.text = [dateFormatter stringFromDate:_datePicker.date];
   // NSLog(@"%@",_birthdayLabel.text);
    NSDate *date = [NSDate date];
    int timeInterval = ([date timeIntervalSinceDate:_datePicker.date] / 3600) / 24;
   // NSLog(@"%d",timeInterval);
    if (timeInterval < 0) {
        NSString *dateString = [dateFormatter stringFromDate:_datePicker.date];

        _ageLabel.text = [NSString stringWithFormat:@"预产期%@",dateString];
    }else if (timeInterval == 0) {
        _ageLabel.text = @"新生";

    }else if ((timeInterval / 7) == 0) {
        _ageLabel.text = [NSString stringWithFormat:@"%d天大",timeInterval];
    }else if ((timeInterval / 7) <= 4){
        _ageLabel.text = [NSString stringWithFormat:@"%d周大",timeInterval / 7];
    }else if (((timeInterval  / (365 / 12))) < 12){
        _ageLabel.text = [NSString stringWithFormat:@"%d个月大",((timeInterval / (365 / 12)))];
    }else{
        _ageLabel.text = [NSString stringWithFormat:@"%d岁",timeInterval / 365];

    }
    NSNotification *noti = [[NSNotification alloc]initWithName:@"dateChange" object:nil userInfo:@{@"dateInfo":_birthdayLabel.text}];
    
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
