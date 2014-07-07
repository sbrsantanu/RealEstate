//
//  AppDelegate.h
//  RealEstate
//
//  Created by XueSongLu on 3/6/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "PPRevealSideViewController.h"
#import "Users.h"

@class MyNavigationController, DataModel, AFHTTPClient;

@interface AppDelegate : UIResponder <UIApplicationDelegate, PPRevealSideViewControllerDelegate, UIAlertViewDelegate> {
    int appointid;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;
@property (strong, nonatomic) MyNavigationController *navController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, strong) DataModel* dataModel;

@property (nonatomic, strong) AFHTTPClient *client;

@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *userType;
@property (strong, nonatomic) NSString *photo;
@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *otheruserid;
@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) NSString *pname;
@property (strong, nonatomic) NSString *term;
@property (strong, nonatomic) NSString *offerPrice;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *verify_code;
@property (strong, nonatomic) NSString *offerid;
@property (strong, nonatomic) NSString *quality;
@property (strong, nonatomic) NSString *need_register;
@property (strong, nonatomic) NSString *afterControllerName;
@property (strong, nonatomic) NSString *forFavorite;
@property (strong, nonatomic) NSString *forQA;
@property (strong, nonatomic) Users *userObject;

@property (assign, nonatomic) int beforePoint;
@property (assign, nonatomic) int afterPoint;

@property (strong, nonatomic) id postViewController;

- (long)getYear:(NSDate*)date;
- (long)getMonth:(NSDate*)date;
- (long)getDay:(NSDate*)date;
- (long)getHour:(NSDate*)date;
- (int)getMaxDate:(long)year month:(long)month;
- (long)getWeekDay:(NSDate*)date;

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;
- (UIImage *)cropImage:(UIImage *)oldImage;

-(NSDictionary *)getGeolocation:(NSString *)address;

-(BOOL) emailValidation:(NSString *)emailTxt;

-(BOOL) validateAlpha: (NSString *) string;

-(BOOL)isValidPinCode:(NSString*)pincode;

@end
