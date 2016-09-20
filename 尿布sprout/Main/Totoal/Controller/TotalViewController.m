//
//  TotalViewController.m
//  尿布sprout
//
//  Created by Macbook on 16/8/26.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import "TotalViewController.h"
#import "DefecateTableViewCell.h"
#import "SectionHeaderView.h"
#import "ChangeRemark.h"
@interface TotalViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSString *_currentName;
    NSArray *colorArray;
    NSMutableArray *_fetchResult;
    int indexpathCount;
    Child *_child;
}
@end

@implementation TotalViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    indexpathCount = 0;
    [self setColor];
    [self createTopView];
    [self createTableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    //_currentName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentName"];
    _fetchResult = [NSMutableArray array];
   _fetchResult = [app fetchChild];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Child"];
    NSString *currentName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentName"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", currentName];
    request.predicate = predicate;
    NSError *error;
    NSArray *result = [app.managedObjectContext executeFetchRequest:request error:&error];
    
    // NSLog(@"%@",result);
    _child = result.firstObject;

    //NSLog(@"%@",_fetchResult);
    //[self analyzeResult];
    [_tableView reloadData];
    
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
- (void)createTopView{
    //创建最上面的视图
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor clearColor];
    NSArray *tbNameArray = @[@"时间",@"类型",@"详情"];
    
    for (int i = 0; i < 3; i ++) {
        
        UILabel *tbLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 3 * i, 0, kScreenWidth / 3, 40)];
        
        // wcLabel.backgroundColor = [UIColor redColor];
        [topView addSubview:tbLabel];
        tbLabel.text = tbNameArray[i];
        tbLabel.textAlignment = NSTextAlignmentCenter;
        tbLabel.textColor = [UIColor darkGrayColor];
        tbLabel.font = [UIFont systemFontOfSize:13];
    }

}
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, kScreenWidth,kScreenHeight - 104 - 49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
   // NSLog(@"%d",_analyzeResult.count);
    
    return _fetchResult.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = _fetchResult[section];
    
    NSArray *array = dic[@"data"];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DefecateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defecateCell"];

    if (cell == nil) {
      cell = [[DefecateTableViewCell alloc]init];
    }
    
    Defecate *defecate = _fetchResult[indexPath.section][@"data"][indexPath.row];
    //NSLog(@"%d",indexPath.row);
    cell.timeLabel.text = defecate.defecateDate;
    //NSLog(@"*****%@",defecate.defecateDate);
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
    indexpathCount ++;
    if (indexpathCount == _fetchResult.count - 1) {
        indexpathCount = 0;
    }
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    static NSString *ID = @"header";
//    // 先从缓存池中找header
//    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
//    
//    if (header == nil) { // 缓存池中有，自己创建
//        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:ID];
//    }
    UITableViewHeaderFooterView * header = [[UITableViewHeaderFooterView alloc]init];
    header.contentView.backgroundColor = [UIColor clearColor];
    NSDictionary *dic = _fetchResult[section];
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 20)];
    dateLabel.font = font13;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [header.contentView addSubview:dateLabel];
    dateLabel.text = dic[@"date"];
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, kScreenWidth - 70, 20)];
    countLabel.font = font13;
    countLabel.textAlignment = NSTextAlignmentRight;
    [header.contentView addSubview:countLabel];
    
    
    countLabel.text = [NSString stringWithFormat:@"共计:%d次（%d次嘘嘘,%d次便便,%d次都有）",[dic[@"total"] intValue], [dic[@"pee"] intValue], [dic[@"shit"] intValue], [dic[@"both"] intValue]];
    // 设置文字
  
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
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
        [self deleteDefecate:indexPath];
        [_fetchResult[indexPath.section][@"data"] removeObjectAtIndex:indexPath.row];
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
    changeView.defecate = _fetchResult[indexPath.section][@"data"][indexPath.row];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:changeView ];
    [self presentViewController:nav animated:YES completion:nil];

}
- (void)deleteDefecate:(NSIndexPath * )index{
    Defecate *defecate = _fetchResult[index.section][@"data"][index.row];
    // [_currentChild removeOwnDefecate:[NSSet setWithObject:defecate]];
    //如果用下面这种方法则会造成error1550
    [app.managedObjectContext deleteObject:defecate];
    [app saveContext];
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
