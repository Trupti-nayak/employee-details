//
//  AppDelegate.h
//  EmployeeDetailsApp
//
//  Created by prabhudev avarasang on 21/01/17.
//  Copyright © 2017 Trupti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (readonly, strong) NSManagedObjectContext *managedObjectContext;

@property (readonly, strong) NSManagedObject *managedObject;
@property (readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong) NSManagedObjectModel *managedObjectModel;



- (void)saveContext;


@end

