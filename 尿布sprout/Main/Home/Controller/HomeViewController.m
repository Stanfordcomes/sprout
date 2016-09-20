//
//  HomeViewController.m
//  尿布sprout
//
//  Created by Macbook on 16/8/26.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import "HomeViewController.h"
#import "AddChildViewController.h"
#define kCornerRadius 5
#import "WBPopOverView.h"
#define kColorImageViewHeight 20
#define kColorImageViewWidth 40
#define kColorImageViewSpaceWidth 15
#import "DefecateTableViewCell.h"
#import "ChangeRemark.h"
@class AddChildViewController;
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    UIImageView *_addImageView;
    UILabel *changeQualityLabel;
    UILabel *qualityLabel;
    WBPopOverView *view;
    UIView *colorView;
    Child *_currentChild;
    NSString *_currentName;
    NSInteger _selectedColorIndex;
    NSString *_currentType;
    NSMutableArray *_defecateResult;
    NSArray *colorArray;
    NSInteger _peeCount;
    NSInteger _shitCount;
    NSInteger _bothCount;
    __weak IBOutlet UILabel *_peeLabel;
    __weak IBOutlet UILabel *_shitLabel;
    __weak IBOutlet UILabel *_bothLabel;
    __weak IBOutlet UILabel *_totoalCountLabel;
    __weak IBOutlet UILabel *_reloadLabel;
    double _reloadInterval;
}
//淡色的那个框
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@end
@implementation HomeViewController
-(void)viewDidLoad{
    [self setColor];
    

    _currentName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentName"];
    self.title = _currentName;
    [self fetchChild];
    [self createRightBarItem];
    [self createAddView];
   // NSLog(@"%@",_currentChild.namer);
    [self createTableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setCurrentType:) name:@"selectedChild" object:nil];
   NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(reloadLabelChange) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
}
- (void)viewWillAppear:(BOOL)animated{
    _reloadLabel.text = @"无记录";
    _bothCount = 0;
    _peeCount = 0;
    _shitCount = 0;
    [self fetchChild];
   // [self fetchDefecate];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
- (void)setCurrentType:(NSNotification *)noti{
    _currentName = noti.userInfo[@"selectedChild"];
    [[NSUserDefaults standardUserDefaults] setObject:_currentName forKey:@"currentName"];
   // NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"currentName"]);
    self.title = _currentName;
}
- (void)createRightBarItem{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 68, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"childInNav"] forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [button addTarget:self action:@selector(addChildAciton) forControlEvents:UIControlEventTouchUpInside];
}
- (void)createAddView{
    _addImageView = [[UIImageView alloc]init];
    _addImageView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight / 2 - 80);
    _addImageView.backgroundColor = [UIColor colorWithRed:116.0 / 255 green:177.0 / 255 blue:165.0 / 255 alpha:0.85];
    [self.view insertSubview:_addImageView atIndex:0];
    _detailImageView.layer.cornerRadius = 10;
    _detailImageView.layer.masksToBounds = YES;
    NSArray *nameArray = @[@"嘘嘘",@"便便",@"都有"];
    for (int i = 0; i < 3; i ++) {
        
        UILabel *wcLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 3 * i, CGRectGetMaxY(_detailImageView.frame) + 5 , kScreenWidth / 3, 21)];
       // wcLabel.backgroundColor = [UIColor redColor];
        [self.view addSubview:wcLabel];
        wcLabel.text = nameArray[i];
        wcLabel.textAlignment = NSTextAlignmentCenter;
        wcLabel.textColor = [UIColor darkGrayColor];
        wcLabel.font = [UIFont systemFontOfSize:15];
        
    }
    //创建增加按钮
    CGRect frame1 = CGRectMake(10, CGRectGetMaxY(_detailImageView.frame) + 30, (kScreenWidth - 40)/ 3 , 20);
    CGRect frame2 = CGRectMake(20 + (kScreenWidth - 40) / 3, CGRectGetMaxY(_detailImageView.frame) + 30, (kScreenWidth - 40)/ 3 * 2 / 3 , 20);
    CGRect frame3 = CGRectMake(20 + (kScreenWidth - 40) / 3 * 5 / 3, CGRectGetMaxY(_detailImageView.frame) + 30, (kScreenWidth - 40)/ 3 / 3 , 20);
    CGRect frame4 = CGRectMake(30 + (kScreenWidth - 40) / 3 * 2, CGRectGetMaxY(_detailImageView.frame) + 30, (kScreenWidth - 40)/ 3 * 2 / 3 , 20);
    CGRect frame5 = CGRectMake(30 + (kScreenWidth - 40) / 3 * 8 / 3, CGRectGetMaxY(_detailImageView.frame) + 30, (kScreenWidth - 40)/ 3 / 3 , 20);
    NSArray *frameArray = @[[NSValue valueWithCGRect:frame1],[NSValue valueWithCGRect:frame2],[NSValue valueWithCGRect:frame3],[NSValue valueWithCGRect:frame4],[NSValue valueWithCGRect:frame5]];
    for (int i = 0; i < 5; i ++) {
        
        UIButton *xuxuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        xuxuButton.frame = [frameArray[i] CGRectValue];
        if (i % 2 == 0) {
            
            [xuxuButton setImage:[UIImage imageNamed:@"detail_button_comment"] forState:UIControlStateNormal];
        }else{
            [xuxuButton setTitle:@"详情" forState:UIControlStateNormal];
            xuxuButton.titleLabel.font = [UIFont systemFontOfSize:13];
        }
        [self.view addSubview:xuxuButton];
        xuxuButton.layer.cornerRadius = kCornerRadius;
        xuxuButton.layer.masksToBounds = YES;
        xuxuButton.backgroundColor = RGBOrangeColor;
        xuxuButton.contentMode = UIViewContentModeCenter;
        xuxuButton.tag = 50 + i;
       if (i == 1 || i == 3) {
            [xuxuButton addTarget:self action:@selector(addButton2Action:) forControlEvents:UIControlEventTouchUpInside];
           
       }else{
           [xuxuButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];

       }
        
    }
//创建tableView上的label
    NSArray *tbNameArray = @[@"时间",@"类型",@"详情"];

    for (int i = 0; i < 3; i ++) {
        
        UILabel *tbLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 3 * i, CGRectGetMaxY(_addImageView.frame) -16, kScreenWidth / 3, 16)];

        // wcLabel.backgroundColor = [UIColor redColor];
        [self.view addSubview:tbLabel];
        tbLabel.text = tbNameArray[i];
        tbLabel.textAlignment = NSTextAlignmentCenter;
        tbLabel.textColor = [UIColor whiteColor];
        tbLabel.font = [UIFont systemFontOfSize:13];
    }

}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_addImageView.frame), kScreenWidth, kScreenHeight - 64 - _addImageView.frame.size.height - 49) style:UITableViewStylePlain];
   // _tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}
- (void)addChildAciton{
    AddChildViewController *addChildView = [[AddChildViewController alloc]init];
    BaseNavigationController *addChildNavi = [[BaseNavigationController alloc]initWithRootViewController:addChildView];
    [self presentViewController:addChildNavi animated:YES completion:nil];
}
#pragma mark addButtonAction
- (void)backView:(CGPoint)point{
   view=[[WBPopOverView alloc]initWithOrigin:point Width:kScreenWidth - 10 Height:250 Direction:WBArrowDirectionUp2];//初始化弹出视图的箭头顶点位置point，展示视图的宽度Width，高度Height，Direction以及展示的方向
    //view.backView.backgroundColor = [UIColor colorWithRed:247.0 / 255 green:247.0 / 255  blue:247.0 / 255  alpha:0.95];
    view.backView.backgroundColor = [UIColor whiteColor];
    view.backView.alpha = 0.95;
    view.backView.layer.cornerRadius = 5;
    view.backView.layer.masksToBounds = YES;
    view.backView.frame = CGRectMake(5, view.backView.frame.origin.y, kScreenWidth - 10, 200);
    [view popView];
    qualityLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 40, 21)];
    qualityLabel.text = @"质地";
    qualityLabel.textColor = RGBColor;
    qualityLabel.font = [UIFont systemFontOfSize:14];
    [view.backView addSubview:qualityLabel];
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    saveButton.backgroundColor = [UIColor orangeColor];
    saveButton.frame = CGRectMake(view.backView.frame.size.width - 50 - 15, 5, 50, 21 );
    [view.backView  addSubview:saveButton];
    [saveButton setTitle:@"储存" forState:UIControlStateNormal];
    saveButton.backgroundColor = RGBOrangeColor;
    saveButton.contentMode = UIViewContentModeCenter;
    saveButton.layer.cornerRadius = kCornerRadius;
    saveButton.layer.masksToBounds = YES;
    saveButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    //设置质地标签
    changeQualityLabel = [[UILabel alloc]initWithFrame:CGRectMake(view.backView.frame.size.width / 2 - 10, 30, 20, 15)];
    changeQualityLabel.textColor = [UIColor lightGrayColor];
    changeQualityLabel.font = font13;
    changeQualityLabel.text = @"水";
    [view.backView addSubview:changeQualityLabel];
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(15, 60, kScreenWidth - 30, 10)];
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [view.backView addSubview:slider];
    //slider下面的label
    UILabel *sliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 80, 20, 15)];
    sliderLabel.text = @"水";
    sliderLabel.textColor = [UIColor lightGrayColor];
    sliderLabel.font = [UIFont systemFontOfSize:12];
    sliderLabel.textAlignment = NSTextAlignmentLeft;
    [view.backView addSubview:sliderLabel];
    UILabel *sliderLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(view.backView.frame.size.width  - 20, 80, 20, 15)];
    sliderLabel2.text = @"硬";
    sliderLabel2.textColor = [UIColor lightGrayColor];
    sliderLabel2.font = [UIFont systemFontOfSize:12];
    sliderLabel.textAlignment = NSTextAlignmentRight;
    
    [view.backView addSubview:sliderLabel2];
    UILabel *colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 110, 40, 21)];
    colorLabel.textColor = RGBColor;
    colorLabel.text = @"颜色";
    colorLabel.font = font14;
    [view.backView addSubview:colorLabel];
    colorView = [[UIView alloc]init];
    colorView.tag = 100;
    //colorView.userInteractionEnabled = YES;
    colorView.frame = CGRectMake(0, 140, view.backView.frame.size.width, 90);
    colorView.backgroundColor = [UIColor whiteColor];
    [view.backView addSubview:colorView];
    float space = (colorView.frame.size.width - 30 - kColorImageViewWidth * 4) / 3;
    float heightSpace = (colorView.frame.size.height - kColorImageViewHeight * 2) / 3;
    for (int i = 0; i < 4; i ++) {
        for (int j = 0; j < 2; j ++) {
            UIImageView *colorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15 + kColorImageViewWidth * i + space * i, heightSpace * (j + 1)   + kColorImageViewHeight * j, kColorImageViewWidth, kColorImageViewHeight)];
            colorImageView.backgroundColor = colorArray[i + j * 4];
            colorImageView.layer.cornerRadius = kCornerRadius;
            colorImageView.layer.masksToBounds = YES;
            colorImageView.userInteractionEnabled = YES;
            
            colorImageView.tag = 100 + i + j * 4;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [colorImageView addGestureRecognizer:tap];
            
            [colorView addSubview:colorImageView];
        }
    }

}

#pragma mark Ation
- (void)addButtonAction:(UIButton *)sender{
    if (sender.tag == 50) {
        _currentType = @"嘘嘘";
        
    }
    if (sender.tag == 52) {
        _currentType = @"便便";
    }
    if (sender.tag == 54) {
        _currentType = @"都有";
    }
    Defecate *defecate = [NSEntityDescription insertNewObjectForEntityForName:@"Defecate" inManagedObjectContext:app.managedObjectContext];
    defecate.shitColor = nil;
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    defecate.defecateDate = [dateString copy];
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970];
    double timerInterval = a;
    defecate.timeInterval = [NSNumber numberWithDouble:timerInterval];

    defecate.type = _currentType;
    [_currentChild addOwnDefecateObject:defecate];
    [app saveContext];
    [self fetchChild];
    //上面两行代码顺序不能出错，不然会出现线程错误
}
- (void)addButton2Action:(UIButton *)sender{
    CGPoint point=CGPointMake(sender.center.x, CGRectGetMaxY(sender.frame) + 10);//箭头点的位置
    [self backView:point];
    if (sender.tag == 51) {
        
        _currentType = @"便便";
    }else{
        _currentType = @"都有";

    }
    
}
//给colorView添加对号
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

}
- (void)saveAction{
    
   // NSString *timeString = [NSString stringWithFormat:@"%f", a];
    Defecate *defecate = [NSEntityDescription insertNewObjectForEntityForName:@"Defecate" inManagedObjectContext:app.managedObjectContext];
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970];
    double timerInterval = a;
    defecate.timeInterval = [NSNumber numberWithDouble:timerInterval];
    defecate.shitQuality = changeQualityLabel.text;
    defecate.shitColor = [NSNumber numberWithInteger:_selectedColorIndex];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
   // NSLog(@"%@",currentDate);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    defecate.defecateDate = [dateString copy];
    defecate.type = _currentType;
    NSLog(@"%@",_currentChild.name);
    [_currentChild addOwnDefecateObject:defecate];
    _selectedColorIndex = 8;
    [app saveContext];
    [self fetchChild];
    [view dismiss];
    
    
}
#pragma mark tableView datasource delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _defecateResult.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DefecateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defecateCell"];
    if (cell == nil) {
        cell = [[DefecateTableViewCell alloc]init];
        
    }
    Defecate *defecate = _defecateResult[indexPath.row];
    cell.timeLabel.text = defecate.defecateDate;
    cell.defecateLabel.text = defecate.type;
       if (defecate.shitColor) {
        
        cell.shitLabel.text = defecate.shitQuality;
        if ([defecate.shitColor integerValue] != 8) {
            cell.shitLabel.textColor = [UIColor whiteColor];
            cell.shitLabel.backgroundColor = colorArray[[defecate.shitColor integerValue]];
            //NSLog(@"%d",[defecate.shitColor integerValue]);
            
        }
        
    }
    if (defecate.remark && ![defecate.remark isEqualToString:@""]) {
        cell.remarkImageView.hidden = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //DefecateTableViewCell *cell = [[DefecateTableViewCell alloc]init];
 
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
   return  YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[dataArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [self deleteDefecate:indexPath.row];
        [_defecateResult removeObjectAtIndex:indexPath.row];
        [self labelChange];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChangeRemark *changeView = [[ChangeRemark alloc]init];
    changeView.defecate = _defecateResult[indexPath.row];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:changeView ];
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark CoreData
- (void)fetchChild{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Child"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", _currentName];
    request.predicate = predicate;
    NSError *error;
    NSArray *result = [app.managedObjectContext executeFetchRequest:request error:&error];
    
  // NSLog(@"%@",result);
    _currentChild = result.firstObject;
   // NSLog(@"???????%d",_currentChild.ownDefecate.count);
    _defecateResult = [NSMutableArray array];
    NSArray *array = [NSArray array];
    array =[_currentChild.ownDefecate allObjects];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"timeInterval" ascending:NO];
    _defecateResult = [[array sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    //获取今天早上零点的时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSArray *timeArray = [dateString componentsSeparatedByString:@":"];
    
    float tonight =([timeArray[0] intValue] - 8) * 3600 + [timeArray[1] intValue] * 60 + [timeArray[2] intValue];
    NSTimeInterval tonightInterval = tonight;
    //NSLog(@"%d ?????%d",[timeArray[0] intValue],[timeArray[1] intValue]);
    
    NSDate *tonightDate = [NSDate dateWithTimeIntervalSinceNow: -tonightInterval];
    
    //NSLog(@"%@}}}}}%@",tonightDate,[NSDate date]);
    NSTimeInterval toghtInterval = [tonightDate timeIntervalSince1970] - 8 * 3600;
    int breakNumber = 0;
    //截取今天的排便记录
    for (int i = 0; i < _defecateResult.count; i++) {
        Defecate *defecate = _defecateResult[i];
        if ([defecate.timeInterval floatValue] < toghtInterval && i != _defecateResult.count - 1) {
            breakNumber = i;
            break;
        }
        if (i == _defecateResult.count - 1) {
            breakNumber = i;
        }
    }
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc]init];
    for (int i = breakNumber; i < _defecateResult.count; i++) {
        
            
            [set addIndex:i];
       
    }
    if (breakNumber != _defecateResult.count - 1) {
        
        [_defecateResult removeObjectsAtIndexes:set];
    }
    //NSLog(@"%@",_defecateResult);
    [_tableView reloadData];
    [self labelChange];
}
//当滑动表视图时候删除数据库数据
- (void)deleteDefecate:(NSInteger )row{
    Defecate *defecate = _defecateResult[row];
   // [_currentChild removeOwnDefecate:[NSSet setWithObject:defecate]];
    //如果用下面这种方法则会造成error1550
    [app.managedObjectContext deleteObject:defecate];
    [app saveContext];
}
#pragma mark labelchange
- (void)labelChange{
   // NSLog(@"%f",toghtInterval);
    
    //NSLog(@"!!!!%f",[defecate.timeInterval floatValue]);
    for (Defecate *defecate in _defecateResult) {
    
        if ([defecate.type isEqualToString: @"嘘嘘"]) {
            _peeCount ++;
            
        }else if ([defecate.type isEqualToString: @"便便"]) {
            _shitCount ++;
            
        }else if ([defecate.type isEqualToString: @"都有"]) {
            _bothCount ++;
            
        }
    
    }
    
    _peeLabel.text = [NSString stringWithFormat:@"%li次嘘嘘",(long)_peeCount];
    _shitLabel.text = [NSString stringWithFormat:@"%ld次便便",(long)_shitCount];
    _bothLabel.text = [NSString stringWithFormat:@"%ld次都有",(long)_bothCount];
    _totoalCountLabel.text = [NSString stringWithFormat:@"%d",_peeCount + _shitCount + _bothCount];
    _bothCount = 0;
    _peeCount = 0;
    _shitCount = 0;
    

    
    
}
- (void)reloadLabelChange{
    Defecate *firstDefecate =((NSArray *) ([app fetchChild].firstObject[@"data"])).firstObject;
    if (!firstDefecate) {
        
        _reloadLabel.text = @"无记录";
        return;
    }
    _reloadInterval = [firstDefecate.timeInterval floatValue];
    double currentInterval = [[NSDate date] timeIntervalSince1970];
    NSString *labelText;
  //  NSLog(@"%f??????%f",_reloadInterval, currentInterval);
    float compareInterval = (currentInterval - _reloadInterval)  / 60;
    if (compareInterval < 1 ) {
        labelText = [NSString stringWithFormat:@"上次更新不到一分钟之前"];
    }else if (compareInterval < 60 ) {
        labelText = [NSString stringWithFormat:@"上次更新%d分钟之前",(int)compareInterval];
    }else if ((int)compareInterval % 60 == 0 && compareInterval < (24 * 60)) {
        labelText = [NSString stringWithFormat:@"上次更新%d小时之前",(int)compareInterval / 60];
    }else if (compareInterval < (60 * 24) ) {
        labelText = [NSString stringWithFormat:@"上次更新%d小时%d分钟之前",(int)compareInterval / 60, (int)compareInterval % 60];
    }else if (compareInterval <=  (60 * 24 * 7) && (int)compareInterval % (60 * 24)== 0 ) {
        labelText = [NSString stringWithFormat:@"上次更新%d天之前",(int)compareInterval / (60 * 24)];
    }else if (compareInterval <=  (60 * 24 * 7) ) {
        labelText = [NSString stringWithFormat:@"上次更新%d天%d小时之前",(int)compareInterval / (60 * 24), (int) compareInterval % (60 * 24) / 60];
    }

    ;
    _reloadLabel.text = labelText;
   // _reloadLabel.text = [NSString stringWithFormat:@"上次更换％d分钟之前"]
}
@end
