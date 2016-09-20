//
//  RemarkViewController.m
//  尿布sprout
//
//  Created by Macbook on 16/9/12.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import "RemarkViewController.h"
@interface RemarkViewController()<UITextViewDelegate>
{
    UITextView *textView;
}
@end
@implementation RemarkViewController
-(void)viewDidLoad{
    self.title = @"添加备注";

    [self createCancelButton];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *remarkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 69, kScreenWidth - 10, 200)];
    [remarkImageView setImage:[UIImage imageNamed:@"remarkBG"]];
    [self.view addSubview:remarkImageView];
    textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 88, remarkImageView.frame.size.width - 30, 160)];
    [self.view addSubview:textView];
    if (![_text isEqualToString:@"添加备注..."]) {
        
        textView.text = _text;
    }else{
        textView.text = nil;
    }
    textView.editable = YES;
    textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    
    textView.font = [UIFont fontWithName:@"Arial" size:14.0];//设置字体名字和字体大小
    
    textView.delegate = self;//设置它的委托方法

    textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    // 自定义文本框placeholder
    textView.backgroundColor = [UIColor clearColor];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location < 100)
    {
        return  YES;
    } else {
        return NO;
        
    }
}

- (void)createCancelButton{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 41, 26);
    [leftButton setTitle:@"确认" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    leftButton.titleLabel.tintColor = [UIColor whiteColor];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}
- (void)cancelAction{
    NSNotification *textNoti = [NSNotification notificationWithName:@"remarkNoti" object:nil userInfo: @{@"text":textView.text}];
    [[NSNotificationCenter defaultCenter]postNotification:textNoti];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
@end
