//
//  AppointmentSuccessViewController.m
//  RealEstate
//
//  Created by Sol.S on 4/11/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "AppointmentSuccessViewController.h"
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Constant.h"
#import <AddressBook/AddressBook.h>
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"

#import "AFNetworking.h"

#import "HomeViewController.h"
#import "MyNavigationController.h"
#import "AppDelegate.h"

@interface AppointmentSuccessViewController ()

@end

@implementation AppointmentSuccessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btnSearchMore.layer.cornerRadius = self.btnSearchMore.frame.size.height / 2;
    self.btnDone.layer.cornerRadius = self.btnDone.frame.size.height / 2;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [self.scrollView setFrame:CGRectMake(0,44,bounds.size.width,bounds.size.height - 64)];
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [self.scrollView setFrame:CGRectMake(0,64,bounds.size.width,bounds.size.height - 64)];
    }
    [self.scrollView setContentSize:CGSizeMake(bounds.size.width,504)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onFacebookBtnPressed:(id)sender {
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    params.name = @"RealEstate";
    params.caption = @"Love Your Home And Garden.";
    params.picture = [NSURL URLWithString:@"http://i.imgur.com/g3Qc1HN.png"];
    params.description = SHARE_MESSAGE;
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:params.description];
        [self presentViewController:controller animated:YES completion:Nil];
    }else {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        {
            SLComposeViewController *facebookSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeFacebook];
            [facebookSheet setInitialText:SHARE_MESSAGE];
            
            [self presentViewController:facebookSheet animated:YES completion:nil];
            
            //inform the user that no account is configured with alarm view.
        }
    }
}

- (IBAction)onTwitterBtnPressed:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:SHARE_MESSAGE];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }else {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:SHARE_MESSAGE];
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
            
            //inform the user that no account is configured with alarm view.
        }
    }
}

- (IBAction)onPhoneBtnPressed:(id)sender {
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    NSMutableArray *emails = [[NSMutableArray alloc] init];
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,error);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            //ABAddressBookRef addressBook = ABAddressBookCreate( );
            if (error) {
                return;
            }
            [self onPhoneBtnPressed:nil];
        });
    }
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        
        for(int i = 0; i < numberOfPeople; i++) {
            
            ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
            
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            ABMutableMultiValueRef eMails  = ABRecordCopyValue(person, kABPersonEmailProperty);
            [[UIDevice currentDevice] name];
            
            for (CFIndex j = 0; j < ABMultiValueGetCount(phoneNumbers); j++) {
                NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, j);
                
                [numbers addObject:phoneNumber];
            }
            for (CFIndex j = 0; j < ABMultiValueGetCount(eMails); j++) {
                NSString *email = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(eMails, j);
                
                [emails addObject:email];
            }
        }
    }else {
        // Send an alert telling user to change privacy setting in settings app
        NSLog(@"Unable to Get Phone Contact");
    }
    NSDictionary *params = @{@"phoneNumbers":[numbers JSONRepresentation],
                             @"message":SHARE_MESSAGE
                             };
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:sendSMSUrl]];
    
    [client
     postPath:@"/sendSMS.php"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (operation.response.statusCode != 200) {
             NSLog(@"Failed");
         } else {
             NSLog(@"Success");
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if ([self isViewLoaded]) {
             NSLog(@"Failed");
         }
     }];
}

- (void) doneSendSMS :(NSString*)data
{
    [self.view endEditing:YES];
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithBool:true]])
    {
        NSMutableArray *nonSent = (NSMutableArray *)[dataDict objectForKey:@"nonSent"];
        for (int i = 0; i < nonSent.count; i++) {
            //NSLog(@"%@",[nonSent objectAtIndex:i]);
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"We are experiencing high load, and will rectify this as soon as possible. We are aware of this issue." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}


- (IBAction)onDoneBtnPressed:(id)sender {
}

- (IBAction)onSearchMoreBtnPressed:(id)sender {
    MyNavigationController *navController = (MyNavigationController *)self.navigationController;
    int i = 0;
    for (; i < navController.viewControllers.count; i++) {
        if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[HomeViewController class]]) {
            [self.navigationController pushViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
            return;
        }
    }
    if (i == navController.viewControllers.count) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        HomeViewController *homeViewController = [[HomeViewController alloc] init];
        delegate.postViewController = homeViewController;
        homeViewController.prevViewController = self;
        [self.navigationController pushViewController:homeViewController animated:YES];
    }
}
@end
