//
//  ChartViewController.m
//  尿布sprout
//
//  Created by Macbook on 16/8/26.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import "ChartViewController.h"
#import "SelectedDateController.h"
#import "ChartView.h"
#import "WeekOrMonthTableViewController.h"
@interface ChartViewController ()
{
    UIView *_view;
    UILabel *_first2Label;
    UILabel *_first3Label;
    UILabel *_second2Label;
    UILabel *_third2Label;
    UILabel *_forth2Label;
    UILabel *_fifth2Label;
    NSArray *_fetchResult;
    ChartView *chartView;
    UIView *_threeKindView;
    UISegmentedControl *segCtrl;
    NSNumber *_weekOrMonth;
}
@end

@implementation ChartViewController
- (void)viewWillAppear:(BOOL)animated{
    _fetchResult = [app fetchChild];
    [self setLabel];
    if (segCtrl.selectedSegmentIndex == 0) {
        [chartView removeFromSuperview];
        [self createFirstView];
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createFirstView];
    [self createSecondView];
    [self createThreeView];
    UIImageView *bottomView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottomImageBG"]];
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 69 - 34, kScreenWidth, 20);
    [self.view addSubview:bottomView];

    segCtrl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(bottomView.frame) + 5, kScreenWidth - 60, 20)];
    segCtrl.tintColor = RGBOrangeColor;
    [segCtrl insertSegmentWithTitle:@"共计" atIndex:0 animated:YES];
    [segCtrl insertSegmentWithTitle:@"概览" atIndex:1 animated:YES];
    [segCtrl addTarget:self action:@selector(segmentEvent:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segCtrl];
    UIButton *calendar = [UIButton buttonWithType:UIButtonTypeCustom];
    [calendar setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    calendar.frame = CGRectMake(kScreenWidth - 50,  CGRectGetMaxY(bottomView.frame) , 40, 30);
    [self.view addSubview:calendar];
    [calendar addTarget:self action:@selector(pushView) forControlEvents:UIControlEventTouchUpInside];
    segCtrl.selectedSegmentIndex = 0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *today = [formatter stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:today forKey:@"chartDate"];
    [self setLabel];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weekOrMonth:) name:@"weekOrMonth" object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}
- (void)weekOrMonth:(NSNotification *)noti{
    _weekOrMonth = noti.userInfo[@"type"];
    
}
- (void)createThreeView{
    
    _threeKindView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 56)];
    NSArray *colorArray = @[RGBPeeColor, RGBShitColor, RGBBothColor];
    NSArray *textArray = @[@"嘘嘘", @"便便", @"都有"];
    for (int i = 0; i < 3; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * 60 + 50, 30, 20, 20)];
        imageView.backgroundColor = colorArray[i];
        [_threeKindView addSubview:imageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * 60 + 70, 30, 30, 20)];
        label.text = textArray[i];
        label.font = [UIFont systemFontOfSize:12];
        [_threeKindView addSubview:label];
        label.textColor = [UIColor lightGrayColor];
    }
    [self.view addSubview:_threeKindView];
}
- (void)createFirstView{
    chartView = [[ChartView alloc]initWithFrame:CGRectMake(0, 120, kScreenWidth, kScreenHeight - 220)];
    [self.view addSubview:chartView];
    chartView.number = _weekOrMonth;
    chartView.backgroundColor = [UIColor whiteColor];
//    barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
//    [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
//    [barChart setYValues:@[@1, @10, @2, @6, @3]];
//    [barChart strokeChart];
//    [self.view addSubview:barChart];
}
- (void)createSecondView{
    _view  = [[UIView alloc]initWithFrame:CGRectMake(15, 130, kScreenWidth - 30, kScreenWidth - 30)];
    _view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_view];
    _view.hidden = YES;
    float width = _view.frame.size.width;
    UIColor *kafeiColor = [UIColor colorWithRed:184 / 255.0 green:94 / 255.0 blue:0 alpha:1];
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, (width - 10) / 3)];
    firstView .backgroundColor = RGBOrangeColor;
    [_view addSubview:firstView];
    UILabel *first1Label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 40, 30)];
    first1Label.text = @"共计";
    [firstView addSubview:first1Label];
    _first2Label = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 200, 20)];
    _first2Label.textColor = [UIColor whiteColor];
    _first2Label.font = font13;
    
    [firstView addSubview:_first2Label];
    _first3Label = [[UILabel alloc]initWithFrame:CGRectMake(width - 50, 0, 40, firstView.frame.size.height)];
    [firstView addSubview:_first3Label];
    _first3Label.textAlignment = NSTextAlignmentRight;
    _first3Label.text = @"1";
    UIView *secondView = [[UIView alloc]initWithFrame:CGRectMake(0, (width - 10) / 3 + 5, (width - 10) / 3, (width - 10) / 3)];
    secondView.backgroundColor = RGBOrangeColor;
    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, secondView.frame.size.width, 30)];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.text = @"嘘嘘";
    _second2Label = [[UILabel alloc]initWithFrame:CGRectMake(0, (secondView.frame.size.width - 40) / 2, secondView.frame.size.width, 40)];
    _second2Label.text = @"0";
    _second2Label.textAlignment = NSTextAlignmentCenter;
    [secondView addSubview:secondLabel];
    [secondView addSubview:_second2Label];
    [_view addSubview:secondView];
    UIView *thirdView = [[UIView alloc]initWithFrame:CGRectMake((width - 10) / 3 + 5, (width - 10) / 3 + 5, (width - 10) / 3, (width - 10) / 3)];
    thirdView.backgroundColor = RGBOrangeColor;
    UILabel *thridLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, secondView.frame.size.width, 30)];
    thridLabel.textAlignment = NSTextAlignmentCenter;
    thridLabel.text = @"便便";
    [thirdView addSubview:thridLabel];
    _third2Label = [[UILabel alloc]initWithFrame:CGRectMake(0, (secondView.frame.size.width - 40) / 2, secondView.frame.size.width, 40)];
    _third2Label.textAlignment = NSTextAlignmentCenter;
    _third2Label.text = @"0";
    [thirdView addSubview:_third2Label];
    [_view addSubview:thirdView];
    UIView *forthView = [[UIView alloc]initWithFrame:CGRectMake(((width - 10) / 3 + 5) * 2, (width - 10) / 3 + 5, (width - 10) / 3, (width - 10) / 3)];
    forthView.backgroundColor = RGBOrangeColor;
    UILabel *forthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, secondView.frame.size.width, 30)];
    forthLabel.textAlignment = NSTextAlignmentCenter;
    forthLabel.text = @"都有";
    _forth2Label = [[UILabel alloc]initWithFrame:CGRectMake(0, (secondView.frame.size.width - 40) / 2, secondView.frame.size.width, 40)];
    _forth2Label.textAlignment = NSTextAlignmentCenter;
    [forthLabel addSubview:_forth2Label];
    [forthView addSubview:forthLabel];
    [forthView addSubview:_forth2Label];
    _forth2Label.text = @"0";

    [_view addSubview:forthView];
    UIView *fifthView = [[UIView alloc]initWithFrame:CGRectMake(0, ((width - 10) / 3 + 5) * 2, width, (width - 10) / 3)];
    fifthView.backgroundColor = RGBOrangeColor;
    UILabel *fifthLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50,  fifthView.frame.size.height)];
    fifthLabel.textAlignment = NSTextAlignmentLeft;
    fifthLabel.text = @"总次数";
    [fifthView addSubview:fifthLabel];
    _fifth2Label = [[UILabel alloc]initWithFrame:CGRectMake(fifthView.frame.size.width - 110, 0, 100, fifthView.frame.size.height)];
    [fifthView addSubview:_fifth2Label];
    _fifth2Label.textAlignment = NSTextAlignmentRight;
    _fifth2Label.text = @"1234";
    [_view addSubview:fifthView];
    NSArray *labelArray1 = @[first1Label, secondLabel, thridLabel, forthLabel, fifthLabel];
    for (UILabel *label in labelArray1) {
        label.textColor = kafeiColor;
        label.font = font16;
    }
    NSArray *labelArray2 = @[_first3Label, _second2Label, _third2Label, _forth2Label, _fifth2Label];
    for (UILabel *label in labelArray2) {
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:28];
    }


    
}
- (void)pushView{
    if (segCtrl.selectedSegmentIndex == 0) {
        WeekOrMonthTableViewController *view = [[WeekOrMonthTableViewController alloc]init];
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];

    }else{
        
    
    SelectedDateController *ctrl = [[SelectedDateController alloc]init];
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    }
}
- (void)setLabel{
    int sum = 0;
    NSString *dateString = [[NSUserDefaults standardUserDefaults] objectForKey:@"chartDate"];
    
    NSArray *selectedDayArray = [NSArray array];
    NSDictionary *userDic = [NSDictionary dictionary];
    for (NSDictionary *dic in _fetchResult) {
        NSLog(@"%@",dic[@"yearDate"]);
        if ([dic[@"yearDate"] isEqualToString:dateString]) {
            userDic = dic;
           selectedDayArray = dic[@"data"];
            NSLog(@"%@",selectedDayArray);
        }
        NSArray *array = dic[@"data"];
        sum += array.count;
    }
    _fifth2Label.text = [NSString stringWithFormat:@"%d",sum];
    sum = 0;
//    Defecate *defecate = selectedDayArray.firstObject;
//    if ([defecate.timeInterval floatValue] > app.toghtInterval) {
        _first3Label.text = [NSString stringWithFormat:@"%d",selectedDayArray.count];
        _first2Label.text = [NSString stringWithFormat:@"每日更换平均数:%d",selectedDayArray.count];
        _second2Label.text = [NSString stringWithFormat:@"%d",[userDic[@"pee"] intValue]];
        _third2Label.text = [NSString stringWithFormat:@"%d",[userDic[@"shit"] intValue]];
        _forth2Label.text = [NSString stringWithFormat:@"%d",[userDic[@"both"] intValue]];

//
//    }else{
//        _first2Label.text = [NSString stringWithFormat:@"每日更换平均数:0"];
//        _first3Label.text = @"0";
//        _second2Label.text = @"0";
//        _third2Label.text = @"0";
//        _forth2Label.text = @"0";
//
//    }
}
- (void)segmentEvent:(UISegmentedControl *)seg{
    if (seg.selectedSegmentIndex == 1) {
        [chartView removeFromSuperview];
        [_threeKindView removeFromSuperview];

        [self.view addSubview:_view];
        _view.hidden = NO;
    }else{
        [self createFirstView];
        [self.view addSubview:_threeKindView];

        [_view removeFromSuperview];
    }
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
