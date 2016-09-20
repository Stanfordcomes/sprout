//
//  SelectedDateController.m
//  尿布sprout
//
//  Created by Macbook on 16/9/9.
//  Copyright © 2016年 Macbook. All rights reserved.
//
#import "SelectedDateController.h"

@interface SelectedDateController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSIndexPath *selectedIndexpath;
    UITableView *_tbView;
    UIDatePicker *_datePicker;
    NSString *_yearDateString;
}
@end

@implementation SelectedDateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2) style:UITableViewStylePlain];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    [self.view addSubview:_tbView];
    [self createDatePicker];
    [self createSaveButton];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillDisappear:(BOOL)animated{
    selectedIndexpath = nil;
}
- (void)createSaveButton{
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(saveDate)];
    saveButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = saveButton;
    //这个地方改了好久才改对
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
- (void)createDatePicker{
    
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.frame = CGRectMake(0, CGRectGetMaxX(_tbView.frame), kScreenWidth, 200);
    _datePicker.hidden = YES;
    _datePicker.backgroundColor = [UIColor whiteColor];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    _datePicker.locale = locale;
    _datePicker.datePickerMode  = UIDatePickerModeDateAndTime;
    [self.view addSubview:_datePicker ];
    [_datePicker addTarget:self action:@selector(labelChange) forControlEvents:UIControlEventValueChanged];
}
- (void)labelChange{
    NSDate * date = _datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    _yearDateString = [dateFormatter stringFromDate:date];

}
- (void)saveDate{
    if (selectedIndexpath) {
        [[NSUserDefaults standardUserDefaults] setObject:_yearDateString forKey:@"chartDate"];
        [self.navigationController popViewControllerAnimated:YES];
        }
}
- (void)viewWillAppear:(BOOL)animated{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"今天";
            break;
        case 1:
        
            cell.textLabel.text = @"选择日期";
       
            break;
        default:
            break;
    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView cellForRowAtIndexPath:selectedIndexpath].accessoryType = UITableViewCellAccessoryNone;
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;

    
    selectedIndexpath = indexPath;
    if (indexPath.row == 1) {
        _datePicker.hidden = NO;
        
    }else{
        _datePicker.hidden = YES;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
