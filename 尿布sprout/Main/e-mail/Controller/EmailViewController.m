//
//  EmailViewController.m
//  尿布sprout
//
//  Created by Macbook on 16/8/26.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import "EmailViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "MainTabBarController.h"
@interface EmailViewController ()<MFMailComposeViewControllerDelegate>
{
    MFMailComposeViewController *picker;
}
@end

@implementation EmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    
    [self displayComposerSheet];
}
- (NSString *)returnString{
    
    NSMutableArray *defecateResult = [app fetchChild];
    NSMutableString *bodyString = [NSMutableString string];
    for (NSMutableDictionary *dic in defecateResult) {
        NSString *string = [NSString stringWithFormat:@"\n%@－共计:%d次(%d次嘘嘘，%d次便便，%d次都有)\n",dic[@"yearDate"], [dic[@"total"] intValue], [dic[@"pee"] intValue],[dic[@"shit"] intValue],[dic[@"both"] intValue]];
       bodyString =  [[bodyString stringByAppendingString:string] copy];
        for (Defecate *defecate in dic[@"data"]) {
            NSString *eachString = [NSString stringWithFormat:@"-%@-%@\n",defecate.defecateDate, defecate.type];
            bodyString =  [[bodyString stringByAppendingString:eachString] copy];

        }
        
    }
   // NSLog(@"oiui%@",bodyString);
    return bodyString;
}
-(void)displayComposerSheet
{
    picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    //设置主题
    NSString *nameString = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentName"];
    [picker setSubject:[NSString stringWithFormat:@"%@ 的尿片更换记录 ", nameString]];
    
    //设置收件人
    NSArray *toRecipients = [NSArray arrayWithObjects:@"m1025897149@163.com",
                             nil];
    
    [picker setToRecipients:toRecipients];
    NSString *emailBody =[self returnString];
    [picker setMessageBody:emailBody isHTML:NO];
    
    //邮件发送的模态窗口
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    [self dismissViewControllerAnimated:YES completion:nil];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.tabBarController.selectedIndex = 0;
        ((MainTabBarController *)self.tabBarController).shawImageView.frame = CGRectMake(0, 0, kScreenWidth / 5, 49);
    }];
   // NSLog(@"发送结果：%@", msg);
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
