//
//  AppDelegate.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/16/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "LastPostsController.h"
#import "NewPostController.h"
#import "FriendsController.h"
#import "MapController.h"
#import "ProfileController.h"
#import "LoginViewController.h"
#import "LoginWindowProtocol.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, LoginWindowProtocol, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) int userID;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, assign) BOOL showAllUsersOnMap;
@property (nonatomic, assign) BOOL loadImages;
@property (nonatomic, assign) int loadItemsPerRequest;

- (void) saveContext;
- (NSURL*) applicationDocumentsDirectory;

@end
