//
//  SexViewController.m
//  尿布sprout
//
//  Created by Macbook on 16/8/30.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import "SexViewController.h"

@interface SexViewController ()

@property (nonatomic, strong)NSString *sex;
@property (weak, nonatomic) IBOutlet UILabel *boy;
@property (weak, nonatomic) IBOutlet UILabel *girl;
@property (weak, nonatomic) IBOutlet UIImageView *boyCheck;
@property (weak, nonatomic) IBOutlet UIImageView *girlCheck;
@end

@implementation SexViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    

    _boy.userInteractionEnabled = YES;
    _girl.userInteractionEnabled = YES;
    if ([_sex isEqualToString:@"男孩"]) {
        _girlCheck.hidden = YES;
        
    }else{
        _boyCheck.hidden = YES;
    }
    UITapGestureRecognizer *boyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkMark1)];
    [_boy addGestureRecognizer:boyTap];
    UITapGestureRecognizer *girlTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkMark2)];
    [_girl addGestureRecognizer:girlTap];

    // Do any additional setup after loading the view.
}
- (void)postNoti{
    
    NSNotification *noti = [[NSNotification alloc]initWithName:@"sexChange" object:nil userInfo:@{@"sexInfo":_sex}];
    
    [[NSNotificationCenter defaultCenter] postNotification:noti];

}
- (void)checkMark1{
        _boyCheck.hidden = NO;
        _girlCheck.hidden = YES;
    _sex = @"男孩";
    [self postNoti];
    [self sexBlockSet];
}
- (void)checkMark2{
    _boyCheck.hidden = YES;
    _girlCheck.hidden = NO;
    _sex = @"女孩";
    [self postNoti];
    [self sexBlockSet];

}
- (void)sexBlockSet{
    if (self.sexBlock != nil) {
        if (_boyCheck.hidden == YES) {
            self.sexBlock(@"女孩");
        }else{
            self.sexBlock(@"男孩");

        }
    }
}
-(void)returnSexBlock:(ReturnSexBlock)block{
    _sexBlock = [block copy];
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
