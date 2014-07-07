//
//  AppDelegate.m
//  RealEstate
//
//  Created by XueSongLu on 3/6/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "MenuViewController.h"
#import "MyNavigationController.h"
#import "Constant.h"
#import "DataModel.h"
#import "Message.h"
#import "AskOwnerViewController.h"
#import "NSString+SBJSON.h"
#import "OfferViewController.h"
#import "OfferListViewController.h"
#import "AppointmentViewController.h"
#import "AppointmentLikeViewController.h"
#import "RateViewController.h"

#import "Notification.h"

#import "MetaProperty.h"
#import "MetaPropertyFacility.h"
#import "Property.h"
#import "Postcode.h"

#import "Nationality.h"
#import "Race.h"
#import "Furnish.h"
#import "Facility.h"
#import "Offer.h"

#import "NSString+SBJSON.h"

#import <GoogleMaps/GoogleMaps.h>
#import <FacebookSDK/FacebookSDK.h>

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"installed"] == nil || [[defaults valueForKey:@"installed"] isEqualToString:@""]) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"Postcode" ofType:@"csv"];
        NSError *error;
        NSString *csvData = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error];
        NSArray *rawData = [csvData componentsSeparatedByString:@",\r"];
        for (int i = 0; i < rawData.count; i++)
        {
            Postcode *postCode = [NSEntityDescription insertNewObjectForEntityForName:@"Postcode" inManagedObjectContext:context];
            NSString *rawString = [NSString stringWithFormat:@"%@", [rawData objectAtIndex:i]];
            rawString = [rawString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSArray *postStr = [rawString componentsSeparatedByString:@";"];
            postCode.postcode = postStr[0];
            postCode.area = postStr[1];
            postCode.post_office = postStr[2];
            postCode.state_code = postStr[3];
        }
        [self saveContext];
    }
    [defaults setValue:@"1" forKey:@"installed"];
    if ([defaults objectForKey:@"phone"] == nil) {
        self.phone = @"";
    }else {
        self.phone = [defaults objectForKey:@"phone"];
    }
    if ([defaults objectForKey:@"verify_code"] == nil) {
        self.verify_code = @"";
    }else {
        self.verify_code = [defaults objectForKey:@"verify_code"];
    }
    if ([defaults objectForKey:@"userid"] == nil) {
        self.userid = @"";
    }else {
        self.userid = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"userid"]];
    }
    _dataModel = [[DataModel alloc] init];
    _client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:PushServerApiUrl]];
    [_dataModel loadMessages];
    if (![self.phone isEqualToString:@""] && ![self.verify_code isEqualToString:@""]) {
        HomeViewController *homeViewController = [[HomeViewController alloc] init];
        _navController = [[MyNavigationController alloc] initWithRootViewController:homeViewController];
    }else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        _navController = [[MyNavigationController alloc] initWithRootViewController:loginViewController];
    }
    _revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:_navController];
    
    _revealSideViewController.delegate = self;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [_navController.view.layer addAnimation:transition forKey:nil];
    _navController.navigationBarHidden = YES;
    
    self.window.rootViewController = _revealSideViewController;
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [GMSServices provideAPIKey:google_maps_api_key];
    
    NSDictionary *params = @{@"task":@"getcommonlist"};
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverActionUrl]];
    
    [client
     postPath:@"index.php"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSLog(@"Failed");
         } else {
             NSDictionary *dataDict = (NSDictionary*)[operation.responseString JSONValue];
             if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                 NSError *error;
                 
                 //Add Meta Properties
                 NSArray *metaProperties = (NSArray *)[dataDict objectForKey:@"meta_properties"];
                 for (int i = 0; i < metaProperties.count; i++) {
                     [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"propertyid='%@'",[[metaProperties objectAtIndex:i] objectForKey:@"id"]]]];
                     NSEntityDescription *metaEntity = [NSEntityDescription entityForName:@"MetaProperty" inManagedObjectContext:context];
                     [fetchRequest setEntity:metaEntity];
                     NSArray *metaObjects = [context executeFetchRequest:fetchRequest error:&error];
                     MetaProperty *metaProperty;
                     if (metaObjects.count == 0) {
                         metaProperty = [NSEntityDescription insertNewObjectForEntityForName:@"MetaProperty" inManagedObjectContext:context];
                     }else {
                         metaProperty = (MetaProperty *)[metaObjects objectAtIndex:0];
                     }
                     metaProperty.propertyid = [NSNumber numberWithInt:[[[metaProperties objectAtIndex:i] objectForKey:@"id"] intValue]];
                     metaProperty.name = [[metaProperties objectAtIndex:i] objectForKey:@"name"];
                     metaProperty.type = [NSNumber numberWithInt:[[[metaProperties objectAtIndex:i] objectForKey:@"type"] intValue]];
                     metaProperty.land_area = [NSNumber numberWithInt:[[[metaProperties objectAtIndex:i] objectForKey:@"land_area"] intValue]];
                     metaProperty.built_up = [NSNumber numberWithInt:[[[metaProperties objectAtIndex:i] objectForKey:@"built_up"] intValue]];
                     metaProperty.bedrooms = [NSNumber numberWithInt:[[[metaProperties objectAtIndex:i] objectForKey:@"bedrooms"] intValue]];
                     metaProperty.bathrooms = [NSNumber numberWithInt:[[[metaProperties objectAtIndex:i] objectForKey:@"bathrooms"] intValue]];
                     metaProperty.address1 = [[metaProperties objectAtIndex:i] objectForKey:@"address1"];
                     metaProperty.address2 = [[metaProperties objectAtIndex:i] objectForKey:@"address2"];
                     metaProperty.zipcode = [[metaProperties objectAtIndex:i] objectForKey:@"zipcode"];
                     metaProperty.unit = [[metaProperties objectAtIndex:i] objectForKey:@"unit"];
                     if (metaProperty.facilityInfo != nil && metaProperty.facilityInfo.count > 0) {
                         [metaProperty removeFacilityInfo:metaProperty.facilityInfo];
                     }
                     NSArray *facilities = (NSArray *)[[metaProperties objectAtIndex:i] objectForKey:@"facilities"];
                     for (int j = 0; j < facilities.count; j++) {
                         MetaPropertyFacility *metaPropertyFacility = [NSEntityDescription insertNewObjectForEntityForName:@"MetaPropertyFacility" inManagedObjectContext:context];
                         metaPropertyFacility.propertyid = metaProperty.propertyid;
                         metaPropertyFacility.name = [facilities objectAtIndex:j];
                         metaPropertyFacility.propertyInfo = metaProperty;
                     }
                 }
                 
                 //Add Nationality
                 NSArray *nations = (NSArray *)[dataDict objectForKey:@"nations"];
                 for (int i = 0; i < nations.count; i++) {
                     [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name like \"%@\"",[nations objectAtIndex:i]]]];
                     NSEntityDescription *nationEntity = [NSEntityDescription entityForName:@"Nationality" inManagedObjectContext:context];
                     [fetchRequest setEntity:nationEntity];
                     NSArray *nationObjects = [context executeFetchRequest:fetchRequest error:&error];
                     if (nationObjects.count == 0) {
                         Nationality *nationality = [NSEntityDescription insertNewObjectForEntityForName:@"Nationality" inManagedObjectContext:context];
                         nationality.name = [nations objectAtIndex:i];
                     }
                 }
                 
                 //Add Race
                 NSArray *races = (NSArray *)[dataDict objectForKey:@"races"];
                 for (int i = 0; i < races.count; i++) {
                     [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name like \"%@\"",[races objectAtIndex:i]]]];
                     NSEntityDescription *raceEntity = [NSEntityDescription entityForName:@"Race" inManagedObjectContext:context];
                     [fetchRequest setEntity:raceEntity];
                     NSArray *raceObjects = [context executeFetchRequest:fetchRequest error:&error];
                     if (raceObjects.count == 0) {
                         Race *race = [NSEntityDescription insertNewObjectForEntityForName:@"Race" inManagedObjectContext:context];
                         race.name = [races objectAtIndex:i];
                     }
                 }
                 
                 //Add Furnish
                 NSArray *furnishes = (NSArray *)[dataDict objectForKey:@"furnishes"];
                 for (int i = 0; i < furnishes.count; i++) {
                     [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name like \"%@\"",[furnishes objectAtIndex:i]]]];
                     NSEntityDescription *furnishEntity = [NSEntityDescription entityForName:@"Furnish" inManagedObjectContext:context];
                     [fetchRequest setEntity:furnishEntity];
                     NSArray *furnishObjects = [context executeFetchRequest:fetchRequest error:&error];
                     if (furnishObjects.count == 0) {
                         Furnish *furnish = [NSEntityDescription insertNewObjectForEntityForName:@"Furnish" inManagedObjectContext:context];
                         furnish.name = [furnishes objectAtIndex:i];
                     }
                 }
                 NSArray *facilities = (NSArray *)[dataDict objectForKey:@"facilities"];
                 for (int i = 0; i < facilities.count; i++) {
                     [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name like \"%@\"",[facilities objectAtIndex:i]]]];
                     NSEntityDescription *facilityEntity = [NSEntityDescription entityForName:@"Facility" inManagedObjectContext:context];
                     [fetchRequest setEntity:facilityEntity];
                     NSArray *facilityObjects = [context executeFetchRequest:fetchRequest error:&error];
                     if (facilityObjects.count == 0) {
                         Facility *facility = [NSEntityDescription insertNewObjectForEntityForName:@"Facility" inManagedObjectContext:context];
                         facility.name = [facilities objectAtIndex:i];
                     }
                 }
                 [self saveContext];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failed");
     }];
    appointid = 0;
    return YES;
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
	NSLog(@"Received notification: %@", userInfo);
	[self addMessageFromRemoteNotification:userInfo updateUI:YES];
}

- (void)addMessageFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
    NSString *alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    NSString *msgData = [userInfo valueForKey:@"details"];
    
    NSMutableArray* parts = [NSMutableArray arrayWithArray:[msgData componentsSeparatedByString:@": "]];
    NSString *messageType = @"";
    if (parts.count > 1 && [parts objectAtIndex:1] != nil) {
        messageType = [parts objectAtIndex:1];
    }
    NSManagedObjectContext *context = [self managedObjectContext];
    Notification *notification = [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:context];
    notification.notifyString = alertValue;
    notification.datecreated = [NSDate date];
    notification.type = messageType;
    [self saveContext];
    if ([messageType isEqualToString:@"Chat"]) {
        AskOwnerViewController *askOwnerViewController = nil;
        for (int i = 0; i < _navController.viewControllers.count; i++) {
            if ([[_navController.viewControllers objectAtIndex:i] isKindOfClass:[AskOwnerViewController class]]) {
                askOwnerViewController = (AskOwnerViewController*)[_navController.viewControllers objectAtIndex:i];
                break;
            }
        }
        if (askOwnerViewController != nil) {
            DataModel *dataModel = askOwnerViewController.dataModel;
            
            Message* message = [[Message alloc] init];
            message.date = [NSDate date];
            
            message.senderName = [parts objectAtIndex:0];
            if (parts.count > 2 && [parts objectAtIndex:2] != nil) {
                message.text = [NSString stringWithFormat:@"%@",[parts objectAtIndex:2]];
            }else {
                message.text = @"";
            }
            if (parts.count > 3 && [parts objectAtIndex:3] != nil) {
                message.userType = [NSString stringWithFormat:@"%d",[[parts objectAtIndex:3] intValue]];
            }else {
                message.userType = @"0";
            }
            if (parts.count > 4 && [parts objectAtIndex:4] != nil) {
                message.senderPhoto = [NSString stringWithFormat:@"%@",[parts objectAtIndex:4]];
            }else {
                message.senderPhoto = @"";
            }
            message.urlPhotoType = @"1";
            [dataModel addMessage:message];
            [askOwnerViewController getCurrentMessages];
            long index = askOwnerViewController.currentMessages.count - 1;
            if (updateUI) {
                [askOwnerViewController didSaveMessage:message atIndex:index];
            }
        }else {
            Message* message = [[Message alloc] init];
            message.date = [NSDate date];
            
            message.senderName = [parts objectAtIndex:0];
            if (parts.count > 2 && [parts objectAtIndex:2] != nil) {
                message.text = [parts objectAtIndex:2];
            }else {
                message.text = @"";
            }
            if (parts.count > 3 && [parts objectAtIndex:3] != nil) {
                message.userType = [parts objectAtIndex:3];
            }else {
                message.userType = 0;
            }
            if (parts.count > 4 && [parts objectAtIndex:4] != nil) {
                message.senderPhoto = [parts objectAtIndex:4];
            }else {
                message.senderPhoto = @"";
            }
            message.urlPhotoType = @"1";
            [self.dataModel addMessage:message];
        }
    }else if ([messageType isEqualToString:@"NewPost"]) {
        
    }else if ([messageType isEqualToString:@"NewOffer"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RealEstate" message:alertValue delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"View", nil];
        alertView.tag = 1;
        [alertView show];
        return;
    }else if ([messageType isEqualToString:@"DeclineOffer"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RealEstate" message:alertValue delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"View", nil];
        alertView.tag = 6;
        [alertView show];
        return;
    }else if ([messageType isEqualToString:@"OfferAccept"]) {
        /*NSString *offerStr = @"";
        if (parts.count > 2 && [parts objectAtIndex:2] != nil) {
            offerStr = [parts objectAtIndex:2];
        }*/
        NSString *offerId = @"";
        if (parts.count > 0 && [parts objectAtIndex:0] != nil) {
            offerId = [parts objectAtIndex:0];
        }
        NSManagedObjectContext *context = self.managedObjectContext;
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        //Get Favorite Data
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"offerid='%@'",offerId]]];
        NSEntityDescription *offerEntity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
        [fetchRequest setEntity:offerEntity];
        NSArray *offerObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (offerObjects.count > 0) {
            Offer *offerObject = (Offer *)[offerObjects objectAtIndex:0];
            offerObject.status = [NSNumber numberWithInt:3];
            [self saveContext];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RealEstate" message:alertValue delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Read", nil];
        alertView.tag = 2;
        [alertView show];
        return;
    }else if ([messageType isEqualToString:@"AppointView1"]) {
        NSString *appointStr = @"";
        if (parts.count > 2 && [parts objectAtIndex:2] != nil) {
            appointStr = [parts objectAtIndex:2];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RealEstate" message:[NSString stringWithFormat:@"We just wanted to tag up with your last appointment, and hoped that you had a wonderful experience using SAYWA.\n%@",alertValue] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alertView.tag = 3;
        [alertView show];
        return;
    }else if ([messageType isEqualToString:@"AppointView2"]) {
        NSString *appointStr = @"";
        if (parts.count > 2 && [parts objectAtIndex:2] != nil) {
            appointStr = [parts objectAtIndex:2];
        }
        if (parts.count > 3 && [parts objectAtIndex:3] != nil) {
            appointid = [[parts objectAtIndex:3] intValue];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RealEstate" message:@"We just wanted to tag up with you on the status of your property, and hoped that you had a wonderful experience using SAYWA. Did you rent out your property successfully?" delegate:self cancelButtonTitle:@"NOT YET" otherButtonTitles:@"YES", nil];
        alertView.tag = 4;
        [alertView show];
        return;
    }else if ([messageType isEqualToString:@"Appoint"]) {
        NSString *appointStr = @"";
        if (parts.count > 2 && [parts objectAtIndex:2] != nil) {
            appointStr = [parts objectAtIndex:2];
        }
        if (parts.count > 3 && [parts objectAtIndex:3] != nil) {
            appointid = [[parts objectAtIndex:3] intValue];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RealEstate" message:alertValue delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alertView.tag = 5;
        [alertView show];
        return;
    }else if ([messageType isEqualToString:@"ChangeMeeting"]) {
        NSString *appointStr = @"";
        if (parts.count > 2 && [parts objectAtIndex:2] != nil) {
            appointStr = [parts objectAtIndex:2];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RealEstate" message:alertValue delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alertView.tag = 7;
        [alertView show];
        return;
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    AskOwnerViewController *askOwnerViewController = nil;
	for (int i = 0; i < _navController.viewControllers.count; i++) {
        if ([[_navController.viewControllers objectAtIndex:i] isKindOfClass:[AskOwnerViewController class]]) {
            askOwnerViewController = (AskOwnerViewController*)[_navController.viewControllers objectAtIndex:i];
            break;
        }
    }
    NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
	NSLog(@"My token is: %@", newToken);
    self.deviceToken = newToken;
    if (askOwnerViewController != nil) {
        DataModel *dataModel = askOwnerViewController.dataModel;
        NSString* oldToken = [dataModel deviceToken];
        [dataModel setDeviceToken:newToken];
    
        if (![newToken isEqualToString:oldToken])
        {
            [self postUpdateRequest];
        }
    }
}

- (void)postUpdateRequest
{
    AskOwnerViewController *askOwnerViewController = nil;
	for (int i = 0; i < _navController.viewControllers.count; i++) {
        if ([[_navController.viewControllers objectAtIndex:i] isKindOfClass:[AskOwnerViewController class]]) {
            askOwnerViewController = (AskOwnerViewController*)[_navController.viewControllers objectAtIndex:i];
            break;
        }
    }
    if (askOwnerViewController != nil) {
        DataModel *dataModel = askOwnerViewController.dataModel;
    
        NSDictionary *params = @{@"cmd":@"update",
                             @"user_id":[dataModel userId],
                             @"token":[dataModel deviceToken]};
    
        AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:PushServerApiUrl]];
        [client postPath:@"/api.php" parameters:params success:nil failure:nil];
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *context = self.managedObjectContext;
    if (context != nil) {
        if ([context hasChanges] && ![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RealEstate" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RealEstate.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (long)getYear:(NSDate*)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    [components setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
    long year = [components year];
    
    return year;
}

- (long)getMonth:(NSDate*)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    [components setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
    
    long month = [components month];
    
    return month;
}

- (long)getDay:(NSDate*)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    [components setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
    
    long day = [components day];
    
    return day;
}

- (long)getHour:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit fromDate:date];
    
    [components setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
    
    long hour = [components hour];
    
    return hour;
}

- (long)getWeekDay:(NSDate*)date
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];
    [dateComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
    
    long weekday = ([dateComponents weekday] + 5) % 7;
    return weekday;
}

- (int)getMaxDate:(long)year month:(long)month
{
    if (month == 2) {
        if (year % 400 == 0 || (year % 4 == 0 && year % 100 > 0)) {
            return 29;
        }else {
            return 28;
        }
    }else if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
        return 31;
    }else {
        return 30;
    }
    return 0;
}

-(NSDictionary *)getGeolocation:(NSString *)address
{
    NSString *strLocData = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false",address]] encoding:NSUTF8StringEncoding error:nil];
    if (strLocData != nil && ![strLocData isEqualToString:@""]) {
        NSDictionary *locData = [strLocData JSONValue];
        NSArray *results = [locData objectForKey:@"results"];
        if (results.count > 0) {
            NSDictionary *location = [[[results objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"];
            return location;
        }else {
            return nil;
        }
    }else {
        return nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0)
        {
            
        }else if (buttonIndex == 1)
        {
            OfferListViewController *offerListViewController = nil;
            for (int i = 0; i < _navController.viewControllers.count; i++) {
                if ([[_navController.viewControllers objectAtIndex:i] isKindOfClass:[OfferListViewController class]]) {
                    offerListViewController = (OfferListViewController*)[_navController.viewControllers objectAtIndex:i];
                    [self.navController popToViewController:offerListViewController animated:YES];
                    break;
                }
            }
            if (offerListViewController == nil) {
                offerListViewController = [[OfferListViewController alloc] init];
                [self.navController pushViewController:offerListViewController animated:YES];
            }
            [self.revealSideViewController popViewControllerAnimated:YES];
        }
    }else if (alertView.tag == 2) {
        if (buttonIndex == 0)
        {
            
        }else if (buttonIndex == 1)
        {
            AppointmentViewController *appointmentViewController = nil;
            for (int i = 0; i < _navController.viewControllers.count; i++) {
                if ([[_navController.viewControllers objectAtIndex:i] isKindOfClass:[AppointmentViewController class]]) {
                    appointmentViewController = (AppointmentViewController*)[_navController.viewControllers objectAtIndex:i];
                    [self.navController popToViewController:appointmentViewController animated:YES];
                    break;
                }
            }
            if (appointmentViewController == nil) {
                appointmentViewController = [[AppointmentViewController alloc] init];
                [self.navController pushViewController:appointmentViewController animated:YES];
            }
            [self.revealSideViewController popViewControllerAnimated:YES];
        }
    }else if (alertView.tag == 3) {
        if (buttonIndex == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"That's unfortunate, but pretty sure you will find one soon with SAYWA!\nRate our app" delegate:self cancelButtonTitle:@"Next Time" otherButtonTitles:@"YES", nil];
            alertView.tag = 5;
            [alertView show];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"GREAT NEWS!\nRate our app" delegate:self cancelButtonTitle:@"Next Time" otherButtonTitles:@"YES", nil];
            alertView.tag = 5;
            [alertView show];
        }
    }else if (alertView.tag == 4) {
        if (buttonIndex == 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"Sorry to hear that, we will keep your listing online. In the meantime, will you please rate our app? Rate our app" delegate:self cancelButtonTitle:@"Next Time" otherButtonTitles:@"YES", nil];
            alertView.tag = 5;
            [alertView show];
        }else if (buttonIndex == 1)
        {
            /*NSDictionary *params = @{@"task":@"removeappoint",
                                     @"id":[NSString stringWithFormat:@"%d",appointid]};
            AFHTTPClient *client1 = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:actionUrl]];
            
            [client1
             postPath:@"/json/index.php"
             parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if (operation.response.statusCode != 200) {
                     NSLog(@"Failed");
                 } else {
                     NSLog(@"Success");
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"Failed");
             }];*/
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"Rate our app" delegate:self cancelButtonTitle:@"Next Time" otherButtonTitles:@"YES", nil];
            alertView.tag = 5;
            [alertView show];
        }
    }else if (alertView.tag == 5) {
        if (buttonIndex == 0) {
            
        }else {
            NSString * appId = @"867860381";
            NSString * theUrl = [NSString  stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",appId];
            if ([[UIDevice currentDevice].systemVersion integerValue] == 7)
                theUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appId];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theUrl]];
        }
        HomeViewController *homeViewController = nil;
        for (int i = 0; i < _navController.viewControllers.count; i++) {
            if ([[_navController.viewControllers objectAtIndex:i] isKindOfClass:[HomeViewController class]]) {
                homeViewController = (HomeViewController*)[_navController.viewControllers objectAtIndex:i];
                self.postViewController = homeViewController;
                [self.navController popToViewController:homeViewController animated:YES];
                break;
            }
        }
        if (homeViewController == nil) {
            homeViewController = [[HomeViewController alloc] init];
            [self.navController pushViewController:homeViewController animated:YES];
        }
        [self.revealSideViewController popViewControllerAnimated:YES];
    }else if (alertView.tag == 6) {
        if (buttonIndex == 0)
        {
        }else if (buttonIndex == 1)
        {
            OfferListViewController *offerListViewController = nil;
            for (int i = 0; i < _navController.viewControllers.count; i++) {
                if ([[_navController.viewControllers objectAtIndex:i] isKindOfClass:[OfferListViewController class]]) {
                    offerListViewController = (OfferListViewController*)[_navController.viewControllers objectAtIndex:i];
                    [self.navController popToViewController:offerListViewController animated:YES];
                    break;
                }
            }
            if (offerListViewController == nil) {
                offerListViewController = [[OfferListViewController alloc] init];
                [self.navController pushViewController:offerListViewController animated:YES];
            }
            [offerListViewController onDeclineBtnPressed:nil];
            [self.revealSideViewController popViewControllerAnimated:YES];
        }
    }
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    /*float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    //indent in case of width or height difference
    float offset = (width - height) / 2;
    if (offset > 0) {
        rect.origin.y = offset;
    }
    else {
        rect.origin.x = -offset;
    }*/
    rect.origin.x = 0;
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}

- (UIImage *)cropImage:(UIImage *)oldImage {
    //CGSize imageSize = oldImage.size;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContextWithOptions( CGSizeMake( bounds.size.width, 180), NO, 0);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [oldImage drawAtPoint:CGPointMake(0, -149) blendMode:kCGBlendModeCopy alpha:1];
    }else {
        [oldImage drawAtPoint:CGPointMake(0, -113) blendMode:kCGBlendModeCopy alpha:1];
    }
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

-(BOOL) emailValidation:(NSString *)emailTxt
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailTxt];
    
}

-(BOOL) validateAlpha: (NSString *) string
{
    NSString *regex = @"[A-Za-z]+";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",  regex];
    BOOL isValid = [test evaluateWithObject:string];
    return isValid;
}

-(BOOL)isValidPinCode:(NSString*)pincode
{
    NSString *pinRegex = @"^[0-9]{5}$";
    NSPredicate *pinTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pinRegex];
    
    BOOL pinValidates = [pinTest evaluateWithObject:pincode];
    return pinValidates;
}

@end
