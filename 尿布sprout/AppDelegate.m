//
//  AppDelegate.m
//  尿布sprout
//
//  Created by Macbook on 16/8/19.
//  Copyright © 2016年 Macbook. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "Child.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[MainTabBarController alloc]init];
   // [self initCoreData];
    [self managedObjectContext];
    [self addFirstChild];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    //获取今天早上零点的时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSArray *timeArray = [dateString componentsSeparatedByString:@":"];
    
    float tonight =([timeArray[0] intValue] - 8) * 3600 + [timeArray[1] intValue] * 60 + [timeArray[2] intValue];
    NSTimeInterval tonightInterval = tonight;
    //NSLog(@"%d ?????%d",[timeArray[0] intValue],[timeArray[1] intValue]);
    
    NSDate *tonightDate = [NSDate dateWithTimeIntervalSinceNow: -tonightInterval];
    
    //NSLog(@"%@}}}}}%@",tonightDate,[NSDate date]);
    _toghtInterval = [tonightDate timeIntervalSince1970] - 8 * 3600;

    return YES;
}

//设置一个单例类也可以实现和appDelegate一样的效果
- (void)addFirstChild {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isCreate"] intValue] == 1) {
        return;
    }
    Child *firstChild = [NSEntityDescription insertNewObjectForEntityForName:@"Child" inManagedObjectContext:_managedObjectContext];
    firstChild.name = @"宝贝";
    firstChild.sex = @"男孩";
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    //NSLog(@"dateString:%@",dateString);
    firstChild.birthday = dateString;
    [self saveContext];
    int x = 1;
    NSNumber *isCreated = [NSNumber numberWithInt:x];
    [[NSUserDefaults standardUserDefaults] setObject:isCreated forKey:@"isCreate"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentName"]) {
        return;
    }
    NSString *currentName = @"宝贝";
    [[NSUserDefaults standardUserDefaults] setObject:currentName forKey:@"currentName"];
}
-(NSMutableArray *)fetchChild{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Child"];
    NSString *currentName = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentName"];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", currentName];
    request.predicate = predicate;
    NSError *error;
    NSArray *result = [_managedObjectContext executeFetchRequest:request error:&error];
    
    // NSLog(@"%@",result);
    Child *currentChild = result.firstObject;
    // NSLog(@"???????%d",_currentChild.ownDefecate.count);
    NSMutableArray * defecateResult = [NSMutableArray array];
    NSArray *array = [NSArray array];
    array =[currentChild.ownDefecate allObjects];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"timeInterval" ascending:NO];
    defecateResult = [[array sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        //获取今天早上零点的时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        NSArray *timeArray = [dateString componentsSeparatedByString:@":"];
        
        float tonight =([timeArray[0] intValue] - 8) * 3600 + [timeArray[1] intValue] * 60 + [timeArray[2] intValue];
        NSTimeInterval tonightInterval = tonight;
        //NSLog(@"%d ?????%d",[timeArray[0] intValue],[timeArray[1] intValue]);
        
        NSDate *tonightDate = [NSDate dateWithTimeIntervalSinceNow: -tonightInterval];
        NSMutableArray *analyzeResult = [NSMutableArray array];
        NSMutableArray *oneDayArray = [NSMutableArray array];
      //  NSLog(@"%@",defecateResult);
        float clock0Interval = [tonightDate timeIntervalSince1970] - 8 * 3600;
        int loopTimes = 0;
        for (int i = 0; i < defecateResult.count; i ++) {
            Defecate *defecate = defecateResult[i];
            while ([defecate.timeInterval floatValue] < clock0Interval) {
                if (loopTimes == 0 && i != 0) {
                    NSDictionary *dic = [[NSDictionary alloc]init];
                    Defecate *iDefecate = oneDayArray.firstObject;
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[iDefecate.timeInterval floatValue]];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MM月dd日"];
                    NSString *dateString = [dateFormatter stringFromDate:date];
                    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
                    NSString *yearDateString = [dateFormatter stringFromDate:date];

                    int peeCount = 0;
                    int shitCount = 0;
                    int bothCount = 0;
                    int total = 0;
                    for (Defecate *inDefecate in oneDayArray) {
                        
                        if ([inDefecate.type isEqualToString: @"嘘嘘"]) {
                            peeCount ++;
                            
                        }else if ([inDefecate.type isEqualToString: @"便便"]) {
                            shitCount ++;
                            
                        }else if ([inDefecate.type isEqualToString: @"都有"]) {
                            bothCount ++;
                            
                        }
                    }
                    
                    total = peeCount + shitCount + bothCount;
                   // NSString *totalString = [NSString stringWithFormat:@"%@-共计:%d次（%d次嘘嘘,%d次便便,%d次都有）", dateString, total, peeCount, shitCount, bothCount];
                    dic = @{@"date":dateString,@"yearDate":yearDateString, @"data":oneDayArray,@"pee":[NSNumber numberWithInt:peeCount],@"total":[NSNumber numberWithInt:total],@"shit":[NSNumber numberWithInt:shitCount],@"both":[NSNumber numberWithInt:bothCount]};                    [analyzeResult addObject:dic];
                    oneDayArray = [[NSMutableArray alloc]init];
                    
                }
                
                clock0Interval -= 24 * 3600;
                loopTimes ++;
            }
            loopTimes =0;
            [oneDayArray addObject:defecate];
            if (i == defecateResult.count - 1) {
                NSDictionary *dic = [[NSDictionary alloc]init];
                Defecate *iDefecate = oneDayArray.firstObject;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[iDefecate.timeInterval floatValue]];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM月dd日"];
                NSString *dateString = [dateFormatter stringFromDate:date];
                
                [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
                NSString *yearDateString = [dateFormatter stringFromDate:date];
                
                int peeCount = 0;
                int shitCount = 0;
                int bothCount = 0;
                int total = 0;
                for (Defecate *inDefecate in oneDayArray) {
                    
                    if ([inDefecate.type isEqualToString: @"嘘嘘"]) {
                        peeCount ++;
                        
                    }else if ([inDefecate.type isEqualToString: @"便便"]) {
                        shitCount ++;
                        
                    }else if ([inDefecate.type isEqualToString: @"都有"]) {
                        bothCount ++;
                        
                    }
                }
                
                total = peeCount + shitCount + bothCount;
                
                dic = @{@"date":dateString, @"data":oneDayArray,@"yearDate":yearDateString,@"pee":[NSNumber numberWithInt:peeCount],@"total":[NSNumber numberWithInt:total],@"shit":[NSNumber numberWithInt:shitCount],@"both":[NSNumber numberWithInt:bothCount]};
                [analyzeResult addObject:dic];

            }
        }
        // NSLog(@"%@",_analyzeResult);
    
    return analyzeResult;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//获取当前程序沙盒文件夹下的Documents文件夹路径
- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.wxhl._2_CoreData______" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



//创建对象模型
- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"childCoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


//创建数据持久化协调器
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"_2_CoreData______.sqlite"];
    NSError *error = nil;
    NSLog(@"%@",storeURL);
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

//context
- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
           // abort();在调用时造成了错误
        }
    }
}

@end
