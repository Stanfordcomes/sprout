//
//  AddMoreTableViewController.m
//  尿布sprout
//
//  Created by Macbook on 16/8/30.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import "AddMoreTableViewController.h"
#import "BrithdayViewController.h"
#import "SexViewController.h"
@class BrithdayViewController;
@interface AddMoreTableViewController ()
{
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *sexCell;
@property (weak, nonatomic) IBOutlet UILabel *brithday;
@end

@implementation AddMoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.title = @"添加孩童";
   
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    //NSLog(@"dateString:%@",dateString);
    _brithday.text = dateString;

    //利用通知传值千万不要写到viewWillAppear上，不然会造成内存泄漏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dateChange:) name:@"dateChange" object:nil];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sexChange:) name:@"sexChange" object:nil];
    [self createSaveButton];
}
- (void)createSaveButton{
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addChild)];
    saveButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = saveButton;
    //这个地方改了好久才改对
   [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

//这个方法可以用来传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"sexSegue"]) {
        id theSegue = segue.destinationViewController;
        
        [theSegue returnSexBlock:^(NSString *sex) {
            _sexLabel.text = sex;
        }];
        [theSegue setValue:_sexLabel.text forKey:@"sex"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dateChange:(NSNotification *)noti{
    _brithday.text = noti.userInfo[@"dateInfo"];
    NSLog(@"%@",noti.userInfo[@"dateInfo"]);
}
- (void)sexChange:(NSNotification *)noti{
    _sexLabel.text = noti.userInfo[@"sexInfo"];
    NSLog(@"%@",noti.userInfo[@"sexInfo"]);

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
   // [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

#pragma mark - CoreData
- (void)addChild {
    if ([_nameTextField.text isEqualToString:@"输入姓名"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入姓名" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAction];
        return;
    }
    Child *Child = [NSEntityDescription insertNewObjectForEntityForName:@"Child" inManagedObjectContext:app.managedObjectContext];
    Child.name = _nameTextField.text;
    Child.sex = _sexLabel.text;
        Child.birthday = _brithday.text;
    [app saveContext];
    [self.navigationController popViewControllerAnimated:YES];
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddChildCell" forIndexPath:indexPath];
//    
//    if (indexPath.row == 3) {
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sexTap)];
//        [cell addGestureRecognizer:tap];
//    }
//    return cell;
//}



// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}


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
