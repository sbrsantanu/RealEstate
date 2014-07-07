//
//  VerifyViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/12/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "VerifyViewController.h"
#import "MenuViewController.h"
#import "ProfileEditViewController.h"
#import "HomeViewController.h"
#import "PostViewController.h"
#import "OfferListViewController.h"
#import "PostNewViewController.h"
#import "OfferViewController.h"
#import "FavoritesViewController.h"
#import "AppointmentViewController.h"
#import "DetailPropertyViewController.h"
#import "AskOwnerViewController.h"
#import "DataModel.h"
#import "AFNetworking.h"
#import "NotificationViewController.h"

#import "Users.h"
#import "Favorites.h"
#import "Property.h"
#import "PropertyImage.h"
#import "PropertyFurnish.h"
#import "PropertyFacility.h"
#import "Offer.h"
#import "OfferTime.h"

#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "NSString+SBJSON.h"
#import "MyNavigationController.h"
#import "NSData+Base64.h"

#import <CoreText/CoreText.h>

#import "Reachability.h"

@interface VerifyViewController ()

@end

@implementation VerifyViewController

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    //[self.txtVerifyCode setFont:[UIFont fontWithName:@"Gotham HTF Book" size:10.0f]];
    
    self.txtVerifyCode.delegate = self;
    self.txtName.delegate = self;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.need_register == nil || [delegate.need_register isEqualToString:@"1"]) {
        [self.lblTitle setText:@"REGISTER"];
        [self.lblDescription setText:@"You will receive a registration pin via SMS within 3 minutes."];
        [self.txtVerifyCode setPlaceholder:@"Enter registration pin"];
        [self.txtName setHidden:NO];
        CGRect frame = self.txtName.frame;
        frame.origin.y = self.btnNext.frame.origin.y - frame.size.height - 30;
        [self.txtName setFrame:frame];
        frame = self.txtName.frame;
        frame.origin.y = self.txtName.frame.origin.y - frame.size.height - 11;
        [self.txtVerifyCode setFrame:frame];
    }else {
        [self.lblTitle setText:@"Verifying your ID"];
        [self.lblDescription setText:@"You will receive a verification pin via SMS within 3 minutes."];
        [self.txtName setHidden:YES];
        [self.txtVerifyCode setPlaceholder:@"Enter verification pin"];
        CGRect frame = self.txtVerifyCode.frame;
        frame.origin.y = self.btnNext.frame.origin.y - frame.size.height - 30;
        [self.txtVerifyCode setFrame:frame];
    }
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0,0,bounds.size.width,44)];
        [self.scrollView setFrame:CGRectMake(0,44,bounds.size.width,bounds.size.height - 64)];
    }else {
        [self.navView setFrame:CGRectMake(0,0,bounds.size.width,64)];
        [self.scrollView setFrame:CGRectMake(0,64,bounds.size.width,bounds.size.height - 64)];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    CGPoint tPoint = activeField.frame.origin;
    tPoint.y = tPoint.y - self.scrollView.contentOffset.y + self.scrollView.frame.origin.y + activeField.frame.size.height;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, tPoint)) {
        [self.scrollView setContentOffset:CGPointMake(0.0, self.scrollView.contentOffset.y + tPoint.y - aRect.size.height) animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField
{
    activeField = textField;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([delegate.need_register isEqualToString:@"2"] || [textField isEqual:self.txtName]) {
        [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                    [[UIBarButtonItem alloc]initWithTitle:@"Go" style:UIBarButtonItemStyleDone target:self action:@selector(onNextBtnPressed:)],
                                    nil]];
    }else {
        [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(onKeyboardNextBtnPressed:)],
                                [[UIBarButtonItem alloc]initWithTitle:@"Go" style:UIBarButtonItemStyleDone target:self action:@selector(onNextBtnPressed:)],
                                nil]];
    }
    textField.inputAccessoryView = keyboardToolBar;
    return YES;
}

// Called when the UIKeyboardDidShowNotification is sent.

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

-(void)textFieldDidBeginEditing: (UITextField *)textField
{
    activeField = textField;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)onKeyboardNextBtnPressed:(id)sender {
    if ([activeField isEqual:self.txtVerifyCode]) {
        [self.txtName becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackBtnPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.phone = @"";
    delegate.verify_code = @"";
    delegate.userid = @"";
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNextBtnPressed:(id)sender {
    Reachability *hostReachability = [Reachability reachabilityWithHostName:serverUrl];
    NetworkStatus hostStatus = [hostReachability currentReachabilityStatus];
    if (hostStatus == NotReachable) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Your phone is not connected to Internet" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    [self.view endEditing:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.txtVerifyCode.text == nil || [self.txtVerifyCode.text isEqualToString:@""]) {
        if ([delegate.need_register isEqualToString:@"1"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Verify" message:@"Please Enter Registration Pin" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Verify" message:@"Please Enter Verification Pin" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
        return;
    }else if ([delegate.need_register isEqualToString:@"1"] && (self.txtName.text == nil || [self.txtName.text isEqualToString:@""])) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Verify" message:@"Please Enter Your Name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        NSString *username = self.txtName.text;
        if (username == nil) {
            username = @"";
        }
        NSString *deviceToken = @"";
        if (delegate.deviceToken != nil) {
            deviceToken = delegate.deviceToken;
        }
        NSString *reqString = [NSString stringWithFormat:@"%@?phoneNumber=%@&verifyCode=%@&name=%@&deviceToken=%@&userid=%@", verifyUrl,delegate.phone,self.txtVerifyCode.text,username,deviceToken, [delegate.dataModel userId]];
        reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:reqString];
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
        [self performSelectorOnMainThread:@selector(doneVerify:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void) doneVerify :(NSString*)data
{
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"status"] isEqualToString:@"1"])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        int userid = [[dataDict objectForKey:@"userid"] intValue];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        delegate.userid = [NSString stringWithFormat:@"%d",userid];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:delegate.phone forKey:@"phone"];
        [defaults setObject:self.txtVerifyCode.text forKey:@"verify_code"];
        [defaults setObject:delegate.userid forKey:@"userid"];
        
        NSManagedObjectContext *context = delegate.managedObjectContext;
        
        if ([[dataDict objectForKey:@"user_status"] isEqualToString:@"1"]) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYY-MM-dd"];
            NSDictionary *user = (NSDictionary *)[dataDict objectForKey:@"user"];
            if (user.count > 0) {
                delegate.userObject = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
                delegate.userObject.user_id = [NSNumber numberWithInt:[[user objectForKey:@"user_id"] intValue]];
                delegate.userObject.phone = [user objectForKey:@"phone"];
                delegate.userObject.email = [user objectForKey:@"email"];
                delegate.userObject.name = [user objectForKey:@"name"];
                delegate.userObject.birthday = [dateFormat dateFromString:[user objectForKey:@"birthday"]];
                delegate.userObject.nationality = [user objectForKey:@"nationality"];
                delegate.userObject.race = [user objectForKey:@"race"];
                delegate.userObject.occupation = [user objectForKey:@"occupation"];
                if ([user objectForKey:@"data"] != nil && ![[user objectForKey:@"data"] isEqualToString:@""]) {
                    delegate.userObject.photo = [NSData dataFromBase64String:[user objectForKey:@"data"]];
                }
                delegate.userObject.quality = [NSNumber numberWithInt:[[user objectForKey:@"quality"] intValue]];
                delegate.userObject.datecreated = [dateFormat dateFromString:[user objectForKey:@"datecreated"]];
                delegate.userObject.dateupdated = [dateFormat dateFromString:[user objectForKey:@"dateupdated"]];
                delegate.userObject.status = [NSNumber numberWithInt:[[user objectForKey:@"status"] intValue]];
                delegate.userObject.location = [user objectForKey:@"location"];
                delegate.userObject.privacy = [NSNumber numberWithInt:[[user objectForKey:@"privacy"] intValue]];
            }
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:@"1" forKey:@"logintimes1"];
            [defaults setValue:@"1" forKey:@"logintimes2"];
            [defaults setValue:@"1" forKey:@"logintimes3"];
        }else if ([[dataDict objectForKey:@"user_status"] isEqualToString:@"2"]) {
            
            //delegate.dataModel = [[DataModel alloc] init];
            //delegate.client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:PushServerApiUrl]];
            //[delegate.dataModel loadMessages];
            delegate.username = self.txtName.text;
            
            NSManagedObjectContext *context = delegate.managedObjectContext;
            NSError *error;
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            
            //Get Property Data
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"user_id='%@'",delegate.userid]]];
            NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
            [fetchRequest setEntity:userEntity];
            NSArray *userObjects = [context executeFetchRequest:fetchRequest error:&error];
            if (userObjects.count == 0) {
                Users *userObject = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
                userObject.user_id = [NSNumber numberWithInt:[delegate.userid intValue]];
                userObject.phone = delegate.phone;
                userObject.name = delegate.username;
            }else {
                Users *userObject = (Users *)[userObjects objectAtIndex:0];
                userObject.user_id = [NSNumber numberWithInt:[delegate.userid intValue]];
                userObject.phone = delegate.phone;
                userObject.name = delegate.username;
            }
        }
        [delegate saveContext];
        MyNavigationController *navController = (MyNavigationController *)self.navigationController;
        int i = 0;
        NSString *nextControllerName = delegate.afterControllerName;
        if (nextControllerName == nil || [nextControllerName isEqualToString:@""]) {
            nextControllerName = @"HomeViewController";
        }
        for (i = 0; i < navController.viewControllers.count; i++) {
            if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:NSClassFromString(nextControllerName)]) {
                if ([nextControllerName isEqualToString:@"PostNewViewController"]) {
                    PostNewViewController *postNewViewController = (PostNewViewController *)[navController.viewControllers objectAtIndex:i];
                    postNewViewController.prevViewController = self;
                }else if ([nextControllerName isEqualToString:@"OfferViewController"]) {
                    OfferViewController *offerViewController = (OfferViewController *)[navController.viewControllers objectAtIndex:i];
                    offerViewController.prevViewController = self;
                }else if ([nextControllerName isEqualToString:@"HomeViewController"]) {
                    HomeViewController *homeViewController = (HomeViewController *)[navController.viewControllers objectAtIndex:i];
                    homeViewController.prevViewController = self;
                }else if ([nextControllerName isEqualToString:@"DetailPropertyViewController"]) {
                    DetailPropertyViewController *detailPropertyViewController = (DetailPropertyViewController *)[navController.viewControllers objectAtIndex:i];
                    detailPropertyViewController.prevViewController = self;
                }
                [self.navigationController popToViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
                break;
            }
        }
        if (i == navController.viewControllers.count) {
            if ([nextControllerName isEqualToString:@"HomeViewController"]) {
                HomeViewController *homeViewController = [[HomeViewController alloc] init];
                delegate.postViewController = homeViewController;
                homeViewController.prevViewController = self;
                [self.navigationController pushViewController:homeViewController animated:YES];
            }else if ([nextControllerName isEqualToString:@"ProfileEditViewController"]) {
                ProfileEditViewController *profileEditViewController = [[ProfileEditViewController alloc] init];
                profileEditViewController.prevViewController = self;
                [self.navigationController pushViewController:profileEditViewController animated:YES];
            }else if ([nextControllerName isEqualToString:@"PostViewController"]) {
                PostViewController *postViewController = [[PostViewController alloc] init];
                postViewController.prevViewController = self;
                [self.navigationController pushViewController:postViewController animated:YES];
            }else if ([nextControllerName isEqualToString:@"OfferListViewController"]) {
                OfferListViewController *offerListViewController = [[OfferListViewController alloc] init];
                offerListViewController.prevViewController = self;
                [self.navigationController pushViewController:offerListViewController animated:YES];
            }else if ([nextControllerName isEqualToString:@"AppointmentViewController"]) {
                AppointmentViewController *appointmentViewController = [[AppointmentViewController alloc] init];
                appointmentViewController.prevViewController = self;
                [self.navigationController pushViewController:appointmentViewController animated:YES];
            }else if ([nextControllerName isEqualToString:@"FavoritesViewController"]) {
                FavoritesViewController *favoritesViewController = [[FavoritesViewController alloc] init];
                favoritesViewController.prevViewController = self;
                [self.navigationController pushViewController:favoritesViewController animated:YES];
            }else if ([nextControllerName isEqualToString:@"PostNewViewController"]) {
                PostNewViewController *postNewViewController = [[PostNewViewController alloc] init];
                [self.navigationController pushViewController:postNewViewController animated:YES];
            }else if ([nextControllerName isEqualToString:@"OfferViewController"]) {
                OfferViewController *offerViewController = [[OfferViewController alloc] init];
                offerViewController.prevViewController = self;
                [self.navigationController pushViewController:offerViewController animated:YES];
            }else if ([nextControllerName isEqualToString:@"DetailPropertyViewController"]) {
                DetailPropertyViewController *detailPropertyViewController = [[DetailPropertyViewController alloc] init];
                detailPropertyViewController.prevViewController = self;
                [self.navigationController pushViewController:detailPropertyViewController animated:YES];
            }else if ([nextControllerName isEqualToString:@"AskOwnerViewController"]) {
                AskOwnerViewController *askOwnerViewController = [[AskOwnerViewController alloc] init];
                askOwnerViewController.prevViewController = self;
                [self.navigationController pushViewController:askOwnerViewController animated:YES];
            }else if ([nextControllerName isEqualToString:@"NotificationViewController"]) {
                NotificationViewController *notificationViewController = [[NotificationViewController alloc] init];
                [self.navigationController pushViewController:notificationViewController animated:YES];
            }
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Verify" message:@"Incorrect Verification Code" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (CTFontRef)newCustomFontWithName:(NSString *)fontName
                            ofType:(NSString *)type
                        attributes:(NSDictionary *)attributes
{
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:fontName ofType:type];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:fontPath];
    CGDataProviderRef fontProvider = CGDataProviderCreateWithCFData((CFDataRef)data);
    
    CGFontRef cgFont = CGFontCreateWithDataProvider(fontProvider);
    CGDataProviderRelease(fontProvider);
    
    CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)attributes);
    CTFontRef font = CTFontCreateWithGraphicsFont(cgFont, 0, NULL, fontDescriptor);
    CFRelease(fontDescriptor);
    CGFontRelease(cgFont);
    return font;
}

@end
