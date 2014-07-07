//
//  PostSuccessViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/13/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "PostSuccessViewController.h"
#import "PostViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <AddressBook/AddressBook.h>
#import "AFNetworking.h"

#import "Constant.h"

#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"

@interface PostSuccessViewController ()

@end

@implementation PostSuccessViewController

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
    CALayer *imageLayer = self.imgGroupPhoto.layer;
    [imageLayer setBorderColor:[[UIColor clearColor] CGColor]];
    [imageLayer setCornerRadius:25];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDoneBtnPressed:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([delegate.postViewController isKindOfClass:[PostViewController class]]) {
        PostViewController *postViewController = (PostViewController *)[delegate postViewController];
        [self.navigationController popToViewController:postViewController animated:YES];
    }else if ([delegate.postViewController isKindOfClass:[HomeViewController class]]) {
        HomeViewController *postViewController = (HomeViewController *)[delegate postViewController];
        [self.navigationController popToViewController:postViewController animated:YES];
    }
}

- (IBAction)onBackBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onFacebookBtnPressed:(id)sender {
    // Check if the Facebook app is installed and we can present the share dialog
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
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        /*[FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:params.caption
                                  description:params.description
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];*/
    } else {
        // Present the feed dialog
        // Put together the dialog parameters
        /*NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"RealEstate", @"name",
                                       @"Love Your Home And Garden.", @"caption",
                                       [NSString stringWithFormat:@"%@ thinks SAYWA mobile app for property rental is wonderful. You can download it at dl.saywa.my",username], @"description",
                                       @"https://developers.facebook.com/docs/ios/share/", @"link",
                                       @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];*/
    }
    
    // Put together the dialog parameters
    /*NSString *username = @"Anonymous Person";
    if (delegate.username != nil && ![delegate.username isEqualToString:@""]) {
        username = delegate.username;
    }
    NSString *description = [NSString stringWithFormat:@"%@ thinks SAYWA mobile app for property rental is wonderful. You can download it at dl.saywa.my",username];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"RealEstate", @"name",
                                   @"Love Your Home And Garden", @"caption",
                                   description, @"description",
                                   @"https://developers.facebook.com/docs/ios/share/", @"link",
                                   @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                   nil];
    
    // Make the request
    [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Link posted successfully to Facebook
                                  NSLog(@"result: %@", result);
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                                  NSLog(@"%@", error.description);
                              }
                          }];*/
}

- (IBAction)onTwitterBtnPressed:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:SHARE_MESSAGE];
        [self presentViewController:tweetSheet animated:YES completion:nil];
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
        });
    }
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        
        for(int i = 0; i < numberOfPeople; i++) {
            
            ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
            
            // NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            // NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
            // NSLog(@"Name:%@ %@", firstName, lastName);
            
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            ABMutableMultiValueRef eMails  = ABRecordCopyValue(person, kABPersonEmailProperty);
            [[UIDevice currentDevice] name];
            
            //NSLog(@"\n%@\n", [[UIDevice currentDevice] name]);
            
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
    /*if ([MFMailComposeViewController canSendMail]) {
        // Show the composer
        MFMailComposeViewController* emailController = [[MFMailComposeViewController alloc] init];
        emailController.mailComposeDelegate = self;
        [emailController setSubject:@"RealEstate"];
        [emailController setMessageBody:SHARE_MESSAGE isHTML:NO];
        [emailController setToRecipients:emails];
        if (emailController) {
            [self presentViewController:emailController animated:YES completion:nil];
        }
    }else {
        // Handle the error
        NSLog(@"Unable to Send Email");
    }*/
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

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
@end
