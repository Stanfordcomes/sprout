//
//  ChangeRemark.m
//  尿布sprout
//
//  Created by Macbook on 16/9/18.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import "ChangeRemark.h"

@interface ChangeRemark (){
    Child *_currentChild;
    NSString *_currentName;
    //light表示选中状态
    BOOL dateButtonLight;
    BOOL typeButtonLight;
    BOOL detailButtonLight;
    UIButton *dateButton;
    UIButton *typeButton;
    UIButton *detailButton;
    UILabel *remarkLabelText;
    UIDatePicker *_datePicker;
    UIView *typeView;
    UIView *detailView;
    NSString *_dateString;
    //detailView
    UILabel *changeQualityLabel;
    UIView *colorView;
    NSArray *colorArray;
    
    NSInteger _selectedColorIndex;
    //
    NSArray *nomalImage;
    //需要保存的内容
    NSString *remarkText;
    NSString *_yearDateString;
    NSString *_type;
    NSDate *_date;
}

@end

@implementation ChangeRemark

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改纪录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setColor];
    _type = _defecate.type;
    _selectedColorIndex = [_defecate.shitColor intValue];
    remarkText = _defecate.remark;
    [self createSubview];
    [self createRightBarButton];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setText:) name:@"remarkNoti" object:nil];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    _currentName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentName"];
    [self fetchChild];
    typeButtonLight = NO;
    detailButtonLight = NO;
    dateButtonLight = NO;
    if (remarkText) {
        
        remarkLabelText.text = remarkText;
    }

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)fetchChild{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Child"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", _currentName];
    request.predicate = predicate;
    NSError *error;
    NSArray *result = [app.managedObjectContext executeFetchRequest:request error:&error];
    
    // NSLog(@"%@",result);
    _currentChild = result.firstObject;
}
- (void)createRightBarButton{
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    saveButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = saveButton;
    //这个地方改了好久才改对
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];}
- (void)createSubview{
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 80, 30, 20)];
    dateLabel.textColor = [UIColor lightGrayColor];
    dateLabel.text = @"日期";
    dateLabel.font = font14;
    [self.view addSubview:dateLabel];
    dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    dateButton.frame = CGRectMake(10, CGRectGetMaxY(dateLabel.frame) + 10, kScreenWidth - 20, 30);
    dateButton.layer.borderWidth = 1.0f;
    dateButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:dateButton];
    dateButton.layer.cornerRadius = 7;
    dateButton.layer.masksToBounds = YES;
    _date = [NSDate dateWithTimeIntervalSince1970:[_defecate.timeInterval floatValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日 HH:mm"];
    _dateString = [dateFormatter stringFromDate:_date];
    [dateButton setTitle:[NSString stringWithFormat:@"%@",_dateString] forState:UIControlStateNormal];
    [dateButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    dateButton.titleLabel.font = font16;
    [dateButton addTarget:self action:@selector(dateButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(dateButton.frame) + 20, kScreenWidth / 2, 20)];
    typeLabel.textColor = [UIColor lightGrayColor];
    typeLabel.text = @"类型";
    typeLabel.font = font14;
    [self.view addSubview:typeLabel];
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2, CGRectGetMaxY(dateButton.frame) + 20, kScreenWidth / 2, 20)];
    detailLabel.textColor = [UIColor lightGrayColor];
    detailLabel.text = @"详情";
    detailLabel.font = font14;
    [self.view addSubview:detailLabel];
    typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [typeButton setTitle:_type forState:UIControlStateNormal];
    [typeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    typeButton.titleLabel.font = font16;
    
    typeButton.frame = CGRectMake(10, CGRectGetMaxY(detailLabel.frame) + 10, kScreenWidth / 2 - 20, 30);
    typeButton.layer.borderWidth = 1.0f;
    typeButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:typeButton];
    typeButton.layer.cornerRadius = 7;
    typeButton.layer.masksToBounds = YES;
    [typeButton addTarget:self action:@selector(typeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([_defecate.type isEqualToString:@"嘘嘘"]) {
        [detailButton setTitle:@"--" forState:UIControlStateNormal];

    }else{
    [detailButton setTitle:_defecate.shitQuality forState:UIControlStateNormal];
    }
    [detailButton  setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    detailButton.titleLabel.font = font16;
    
    detailButton.frame = CGRectMake(kScreenWidth / 2 + 10, CGRectGetMaxY(detailLabel.frame) + 10, kScreenWidth / 2 - 20, 30);
    detailButton.layer.borderWidth = 1.0f;
    detailButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:detailButton];
    detailButton.layer.cornerRadius = 7;
    detailButton.layer.masksToBounds = YES;
    [detailButton addTarget:self action:@selector(detailButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UILabel *remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(typeButton.frame) + 20, kScreenWidth / 2, 20)];
    remarkLabel.textColor = [UIColor lightGrayColor];
    remarkLabel.text = @"备注";
    remarkLabel.font = font14;
    
    [self.view addSubview:remarkLabel];
    UIImageView *remarkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(remarkLabel.frame), kScreenWidth - 10, 200)];
    [remarkImageView setImage:[UIImage imageNamed:@"remarkBG"]];
    [self.view addSubview:remarkImageView];
    remarkImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [remarkImageView addGestureRecognizer:tap];
    remarkLabelText = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, remarkImageView.frame.size.width - 30, 160)];
    remarkLabelText.numberOfLines = 0;
    remarkLabelText.font = font13;
    remarkLabelText.text = _defecate.remark;
    [remarkImageView addSubview:remarkLabelText];
    //remarkLabelText.backgroundColor = [UIColor redColor];
    remarkLabelText.textAlignment = NSTextAlignmentLeft;
    [self createDatePicker];
    [self createTypeView];
    [self createDetailView];
}
- (void)createDatePicker{
    
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.date = _date;
    _datePicker.frame = CGRectMake(0, kScreenHeight - 249 , kScreenWidth, 200);
    _datePicker.hidden = YES;
    _datePicker.backgroundColor = [UIColor whiteColor];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    _datePicker.locale = locale;
    _datePicker.datePickerMode  = UIDatePickerModeDateAndTime;
    [self.view addSubview:_datePicker ];
    [_datePicker addTarget:self action:@selector(labelChange) forControlEvents:UIControlEventValueChanged];
}
- (void)labelChange{
    _date= _datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日 HH:mm"];
    _yearDateString = [dateFormatter stringFromDate:_date];
    [dateButton setTitle:_yearDateString forState:UIControlStateNormal];
}
- (void)createTypeView{
    typeView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 249 , kScreenWidth, 200)];
    typeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:typeView];
    typeView.hidden = YES;
    nomalImage = @[@"tools-changing-button-edit-wet-selected-phone", @"tools-changing-button-edit-poopy-selected-phone", @"tools-changing-button-edit-mixed-selected-phone"];
    for (int i = 0; i < 3; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kScreenWidth / 3 * i + 2, 50, kScreenWidth / 3 - 4, 100);
        [button setImage:[UIImage imageNamed:nomalImage[i]] forState:UIControlStateNormal];
        
        button.tag = 100 + i;
        [typeView addSubview:button];
        [button addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)createDetailView{
    detailView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 249 , kScreenWidth, 200)];
    detailView.backgroundColor = [UIColor whiteColor];
    detailView.hidden = YES;
    [self.view addSubview:detailView];
    UILabel *qualityLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 40, 21)];
    qualityLabel.text = @"质地";
    qualityLabel.textColor = RGBColor;
    qualityLabel.font = [UIFont systemFontOfSize:14];
    [detailView addSubview:qualityLabel];
    
    //设置质地标签
    changeQualityLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailView.frame.size.width / 2 - 10, 20, 20, 15)];
    changeQualityLabel.textColor = [UIColor lightGrayColor];
    changeQualityLabel.font = font13;
    changeQualityLabel.text = @"水";
    [detailView addSubview:changeQualityLabel];
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(15, 50, kScreenWidth - 30, 10)];
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [detailView addSubview:slider];
    //slider下面的label
    UILabel *sliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 70, 20, 15)];
    sliderLabel.text = @"水";
    sliderLabel.textColor = [UIColor lightGrayColor];
    sliderLabel.font = [UIFont systemFontOfSize:12];
    sliderLabel.textAlignment = NSTextAlignmentLeft;
    [detailView addSubview:sliderLabel];
    UILabel *sliderLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(detailView.frame.size.width  - 20, 70, 20, 15)];
    sliderLabel2.text = @"硬";
    sliderLabel2.textColor = [UIColor lightGrayColor];
    sliderLabel2.font = [UIFont systemFontOfSize:12];
    sliderLabel.textAlignment = NSTextAlignmentRight;
    
    [detailView addSubview:sliderLabel2];
    UILabel *colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 90, 40, 21)];
    colorLabel.textColor = RGBColor;
    colorLabel.text = @"颜色";
    colorLabel.font = font14;
    [detailView addSubview:colorLabel];
    colorView = [[UIView alloc]init];
    colorView.tag = 100;
    //colorView.userInteractionEnabled = YES;
    colorView.frame = CGRectMake(0, 110, detailView.frame.size.width, 90);
    colorView.backgroundColor = [UIColor whiteColor];
    [detailView addSubview:colorView];
    float space = (colorView.frame.size.width - 30 - kColorImageViewWidth * 4) / 3;
    float heightSpace = (colorView.frame.size.height - kColorImageViewHeight * 2) / 3;
    for (int i = 0; i < 4; i ++) {
        for (int j = 0; j < 2; j ++) {
            UIImageView *colorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15 + kColorImageViewWidth * i + space * i, heightSpace * (j + 1)   + kColorImageViewHeight * j, kColorImageViewWidth, kColorImageViewHeight)];
            colorImageView.backgroundColor = colorArray[i + j * 4];
            colorImageView.layer.cornerRadius = 5;
            colorImageView.layer.masksToBounds = YES;
            colorImageView.userInteractionEnabled = YES;
            
            colorImageView.tag = 100 + i + j * 4;
        
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [colorImageView addGestureRecognizer:tap];
            
            [colorView addSubview:colorImageView];
        }
    }
    
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    UIImageView * imageView = (UIImageView *)tap.view;
    _selectedColorIndex = imageView.tag - 100;
    for (UIImageView *subView in colorView.subviews) {
        subView.image = nil;
    }
    imageView.contentMode = UIViewContentModeCenter;
    [imageView setImage:[UIImage imageNamed:@"button_icon_ok"]];
    
    
}
- (void)sliderAction:(UISlider *)slider{
    if (slider.value < 0.17) {
        changeQualityLabel.text = @"水";
        
    }else if(slider.value < 0.34){
        changeQualityLabel.text = @"稀";
    }else if(slider.value < 0.51){
        changeQualityLabel.text = @"粗";
    }else if(slider.value < 0.68){
        changeQualityLabel.text = @"粘";
    }else if(slider.value < 0.85){
        changeQualityLabel.text = @"实";
    }else{
        changeQualityLabel.text = @"硬";
    }
    [detailButton setTitle:changeQualityLabel.text forState:UIControlStateNormal];
}
- (void)setColor{
    UIColor *color1 = [UIColor colorWithRed:26.0 / 255 green:26.0 / 255 blue:26.0 / 255 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:73.0 / 255 green:100.0 / 255 blue:0 / 255 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:93.0 / 255 green:26.0 / 255 blue:0 / 255 alpha:1];
    UIColor *color4 = [UIColor colorWithRed:170.0 / 255 green:135.0 / 255 blue:12.0 / 255 alpha:1];
    UIColor *color5 = [UIColor colorWithRed:215.0 / 255 green:183.0 / 255 blue:80.0 / 255 alpha:1];
    UIColor *color6 = [UIColor colorWithRed:214.0 / 255 green:143.0 / 255 blue:66.0 / 255 alpha:1];
    UIColor *color7 = [UIColor colorWithRed:137.0 / 255 green:75.0 / 255 blue:0 / 255 alpha:1];
    UIColor *color8 = [UIColor colorWithRed:95.0 / 255 green:42.0 / 255 blue:0 / 255 alpha:1];
    colorArray = @[color1,color2,color3,color4,color5,color6,color7,color8];
    
}

- (void)setText:(NSNotification *)noti{
    remarkText = noti.userInfo[@"text"];
}
//储存最后的数据
- (void)saveAction{
    NSTimeInterval a = [_date timeIntervalSince1970];
    double timerInterval = a;
    _defecate.timeInterval = [NSNumber numberWithDouble:timerInterval];
    if (![detailButton.titleLabel.text isEqualToString:@"--"]) {
        
        _defecate.shitQuality = detailButton.titleLabel.text;
    }else{
        _defecate.shitQuality = nil;
    }
    _defecate.shitColor = [NSNumber numberWithInteger:_selectedColorIndex];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:_date];
    _defecate.defecateDate = [dateString copy];
    _defecate.type = typeButton.titleLabel.text;
    _defecate.remark = remarkText;
    [app saveContext];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)typeButtonAction:(UIButton *)sender{
    
    [detailButton setTitle:@"--" forState:UIControlStateNormal];
    _selectedColorIndex = 8;
    changeQualityLabel.text = @"水";
    NSArray *selectedImage = @[@"tools-changing-button-edit-wet-off-phone", @"tools-changing-button-edit-poopy-off-phone", @"tools-changing-button-edit-mixed-off-phone"];
    for (UIButton *button in typeView.subviews) {
        [button setImage:[UIImage imageNamed:nomalImage[button.tag - 100]] forState:UIControlStateNormal];
    }
    [sender setImage:[UIImage imageNamed:selectedImage[sender.tag - 100]] forState:UIControlStateNormal];
    if (sender.tag == 100) {
        _type = @"pee";
        [typeButton setTitle:@"嘘嘘" forState:UIControlStateNormal];
    }
    if (sender.tag == 101) {
        _type = @"shit";
        [typeButton setTitle:@"便便" forState:UIControlStateNormal];
        
    }
    if (sender.tag == 102) {
        _type = @"both";
        [typeButton setTitle:@"都有" forState:UIControlStateNormal];
        
    }
    
}
//弹出编辑备注的模态视图
- (void)tapAction{
    RemarkViewController *remarkView = [[RemarkViewController alloc]init];
    remarkView.hidesBottomBarWhenPushed = YES;
    remarkView.text = remarkLabelText.text;
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:remarkView ];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)dateButtonAction{
    if (!dateButtonLight) {
        dateButtonLight = YES;
        typeButtonLight = NO;
        detailButtonLight = NO;
        detailView.hidden = YES;
        
        typeButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        detailButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        dateButton.layer.borderColor = [RGBOrangeColor CGColor];
        _datePicker.hidden = NO;
        typeView.hidden = YES;
    }else{
        
        _datePicker.hidden = YES;
        dateButtonLight = NO;
        dateButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    
}
- (void)typeButtonAction{
    if (!typeButtonLight) {
        dateButtonLight = NO;
        typeButtonLight = YES;
        detailButtonLight = NO;
        _datePicker.hidden = YES;
        detailView.hidden = YES;
        
        typeView.hidden = NO;
        dateButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        detailButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        typeButton.layer.borderColor = [RGBOrangeColor CGColor];
        
    }else{
        typeView.hidden = YES;
        typeButtonLight = NO;
        typeButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
}
- (void)detailButtonAction{
    if (!detailButtonLight && ![_type isEqualToString:@"嘘嘘"]) {
        detailView.hidden = NO;
        dateButtonLight = NO;
        typeButtonLight = NO;
        detailButtonLight = YES;
        _datePicker.hidden = YES;
        typeView.hidden = YES;
        
        typeButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        dateButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        detailButton.layer.borderColor = [RGBOrangeColor CGColor];
    }else{
        detailView.hidden = YES;
        detailButtonLight = NO;
        detailButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
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
