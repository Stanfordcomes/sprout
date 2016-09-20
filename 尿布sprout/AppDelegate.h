//
//  AppDelegate.h
//  尿布sprout
//
//  Created by Macbook on 16/8/19.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, assign) NSTimeInterval toghtInterval;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSMutableArray *)fetchChild;
@end

