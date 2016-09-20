//
//  ChildTableViewCell.h
//  尿布sprout
//
//  Created by Macbook on 16/8/27.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addChildLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkMark;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *birthLabel;
@end
