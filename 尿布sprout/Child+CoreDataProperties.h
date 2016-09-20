//
//  Child+CoreDataProperties.h
//  尿布sprout
//
//  Created by Macbook on 16/9/14.
//  Copyright © 2016年 Macbook. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Child.h"

NS_ASSUME_NONNULL_BEGIN

@interface Child (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *birthday;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *sex;
@property (nullable, nonatomic, retain) NSSet<Defecate *> *ownDefecate;

@end

@interface Child (CoreDataGeneratedAccessors)

- (void)addOwnDefecateObject:(Defecate *)value;
- (void)removeOwnDefecateObject:(Defecate *)value;
- (void)addOwnDefecate:(NSSet<Defecate *> *)values;
- (void)removeOwnDefecate:(NSSet<Defecate *> *)values;

@end

NS_ASSUME_NONNULL_END
