//
//  Defecate+CoreDataProperties.h
//  尿布sprout
//
//  Created by Macbook on 16/9/14.
//  Copyright © 2016年 Macbook. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Defecate.h"

NS_ASSUME_NONNULL_BEGIN

@interface Defecate (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *defecateDate;
@property (nullable, nonatomic, retain) NSNumber *shitColor;
@property (nullable, nonatomic, retain) NSString *shitQuality;
@property (nullable, nonatomic, retain) NSNumber *timeInterval;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *remark;

@end

NS_ASSUME_NONNULL_END
