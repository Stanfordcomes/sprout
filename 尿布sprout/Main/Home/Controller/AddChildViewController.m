//
//  AddChildViewController.m
//  尿布sprout
//
//  Created by Macbook on 16/8/27.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import "AddChildViewController.h"
#import "ChildTableViewCell.h"
#import "AddMoreTableViewController.h"
static NSInteger selectedIndexpath;
@interface AddChildViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *fetchResult;
    UITableView *_tableView;
    NSString *_selectedChild;
}
@end

@implementation AddChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedChild = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentName"];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.title = @"更改孩童";
    [self createCancelButton];
    [self createTableView];
   [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:116.0 / 255 green:177.0 / 255 blue:165.0 / 255 alpha:1]];
    self.navigationController.navigationBar.translucent = YES;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [self fetchUser];
    [_tableView reloadData];
}
- (void)createCancelButton{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 41, 26);
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    leftButton.titleLabel.tintColor = [UIColor whiteColor];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
 
}
- (void)cancelAction{
    if ([_selectedChild isEqualToString:@"没有选中"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择或添加一个孩童" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAction];
        return;

    }else{
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"ChildTableViewCell" bundle:[NSBundle mainBundle]];
    [_tableView registerNib:nib forCellReuseIdentifier:@"childCell"];
    
}
#pragma mark- UITableViewDelegate dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return fetchResult.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChildTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"childCell"];
    cell.checkMark.hidden = YES;
    if (cell == nil) {
        cell = [[ChildTableViewCell alloc]init];
        
    }
   // NSLog(@"%d",indexPath.row);
    if (indexPath.row < fetchResult.count) {
        
        Child *child = fetchResult[indexPath.row];
        
        if ([child.name isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentName"]]) {
            cell.checkMark.hidden = NO;
        }
    }
    if (indexPath.row == fetchResult.count ) {
        cell.addChildLabel.hidden = NO;
        cell.birthLabel.hidden = YES;
        cell.nameLabel.hidden = YES;
            }else{
        cell.addChildLabel.hidden = YES;
        cell.birthLabel.hidden = NO;
        cell.nameLabel.hidden = NO;
        Child *child = fetchResult[indexPath.row];
        cell.birthLabel.text = child.birthday;
              //  NSLog(@"!!!!%@",child.name);
        cell.nameLabel.text = child.name;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == fetchResult.count) {
        [self addChildAction];
    }else{
        ChildTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.checkMark.hidden = NO;
        selectedIndexpath = indexPath.row;
       // NSLog(@"%@",cell.nameLabel.text);
        _selectedChild = [cell.nameLabel.text copy];
        NSNotification *noti = [[NSNotification alloc]initWithName:@"selectedChild" object:nil userInfo:@{@"selectedChild":_selectedChild}];
        
        [[NSNotificationCenter defaultCenter]postNotification:noti];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"%d",fetchResult.count);
    if (indexPath.row == fetchResult.count ) {
        return NO;
    }else{
        
       return  YES;
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == fetchResult.count ) {
        return UITableViewCellEditingStyleNone;
    }else{
        
        return UITableViewCellEditingStyleDelete;
    }

}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[dataArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        Child *selectedchild = fetchResult[indexPath.row];
       // NSLog(@"%@",selectedchild.name);
        
        if ([selectedchild.name isEqualToString:_selectedChild]) {
            _selectedChild = @"没有选中";
            // [_tableView selectRowAtIndexPath:[NSIndexPath indexPathWithIndex:row] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        [self deleteChild:indexPath.row];
       // NSLog(@"%@",fetchResult);
        [fetchResult removeObjectAtIndex:indexPath.row];
        selectedIndexpath --;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)deleteChild:(NSInteger)row{
    Child *child = fetchResult[row];

    for (Defecate *defecate in child.ownDefecate) {
        [app.managedObjectContext deleteObject:defecate];
    }
    [app.managedObjectContext deleteObject:child];
    [app saveContext];
}

- (void)viewWillDisappear:(BOOL)animated{
}
- (void)addChildAction{
  //  UITableViewController *moreViewCtrl = [[UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AddMore"];
    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AddMore"] animated:YES];
}
#pragma mark coreData
- (void)fetchUser{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Child"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"birthday CONTAINS '年'"];
    request.predicate = predicate;
    NSError *error;
   fetchResult =[[app.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
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
