//
//  LoginViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/12/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "VerifyViewController.h"
#import "HomeViewController.h"
#import "MenuViewController.h"
#import "Constant.h"
#import "NSString+SBJSON.h"
#import "MBProgressHUD.h"
#import "MyNavigationController.h"
#import "PostViewController.h"
#import "PostNewViewController.h"
#import "ProfileEditViewController.h"
#import "AppointmentViewController.h"
#import "FavoritesViewController.h"
#import "OfferListViewController.h"
#import "OfferViewController.h"
#import "DetailPropertyViewController.h"

#import "Reachability.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.prevViewController != nil) {
        if ([self.prevViewController isKindOfClass:[PostNewViewController class]]) {
            [self.imgBack setHidden:YES];
            [self.imgMask setHidden:YES];
            self.lblError.text = @"Ops, you have not registered or sign in to post this property. Signing in is quick, just enter your mobile number";
            [self.lblView setHidden:NO];
            [self.txtPrefix setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.txtSpace setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.txtPhone setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.btnSkip setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }else if ([self.prevViewController isKindOfClass:[PostViewController class]]) {
            [self.imgBack setHidden:YES];
            [self.imgMask setHidden:YES];
            self.lblError.text = @"Ops, you have not registered or sign in to see your properties. Signing in is quick, just enter your mobile number";
            [self.lblView setHidden:NO];
            [self.txtPrefix setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.txtSpace setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.txtPhone setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.btnSkip setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }else if ([self.prevViewController isKindOfClass:[OfferViewController class]]) {
            [self.imgBack setHidden:YES];
            [self.imgMask setHidden:YES];
            self.lblError.text = @"Ops, you have not registered or sign in to make an offer for this property. Signing in is quick, just enter your mobile number";
            [self.lblView setHidden:NO];
            [self.txtPrefix setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.txtSpace setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.txtPhone setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.btnSkip setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }else if ([self.prevViewController isKindOfClass:[HomeViewController class]]) {
            [self.imgBack setHidden:YES];
            [self.imgMask setHidden:YES];
            self.lblError.text = @"Ops, you have not registered or sign in to favorite this property. Signing in is quick, just enter your mobile number";
            [self.lblError setTextColor:[UIColor lightGrayColor]];
            [self.lblView setHidden:NO];
            [self.txtPrefix setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.txtSpace setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.txtPhone setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.btnSkip setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }else if ([self.prevViewController isKindOfClass:[DetailPropertyViewController class]] && [delegate.forQA isEqualToString:@"1"]) {
            [self.imgBack setHidden:YES];
            [self.imgMask setHidden:YES];
            self.lblError.text = @"Ops, you have not registered or sign in to ask a question about this property. Signing in is quick, just enter your mobile number";
            [self.lblView setHidden:NO];
            [self.txtPrefix setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.txtSpace setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.txtPhone setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.btnSkip setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }else if ([self.prevViewController isKindOfClass:[DetailPropertyViewController class]] && [delegate.forFavorite isEqualToString:@"1"]) {
            [self.imgBack setHidden:YES];
            [self.imgMask setHidden:YES];
            self.lblError.text = @"Ops, you have not registered or sign in to favorite this property. Signing in is quick, just enter your mobile number";
            [self.lblView setHidden:NO];
            [self.txtPrefix setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.txtSpace setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.txtPhone setBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0]];
            [self.btnSkip setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }else {
            [self.imgMask setHidden:NO];
            [self.txtPrefix setBackgroundColor:[UIColor whiteColor]];
            [self.txtSpace setBackgroundColor:[UIColor whiteColor]];
            [self.txtPhone setBackgroundColor:[UIColor whiteColor]];
            [self.lblView setHidden:YES];
            [self.btnSkip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }else {
        [self.imgMask setHidden:NO];
        [self.txtPrefix setBackgroundColor:[UIColor whiteColor]];
        [self.txtSpace setBackgroundColor:[UIColor whiteColor]];
        [self.txtPhone setBackgroundColor:[UIColor whiteColor]];
        [self.lblView setHidden:YES];
        [self.btnSkip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    self.txtPhone.delegate = self;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"Enter your phone number"];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 23)];
    //[self.txtPhone setAttributedPlaceholder:attrStr];
    self.txtPhone.placeholder = @"123322288";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [viewStatusBar setHidden:YES];
    }else {
        [viewStatusBar setHidden:NO];
    }
    if ([self.lblView isHidden]) {
        [self.btnSkip setTitle:@"Skip" forState:UIControlStateNormal];
    }else {
        if (self.prevViewController != nil) {
            if ([self.prevViewController isKindOfClass:[PostNewViewController class]]) {
                [self.btnSkip setTitle:@"Post Later" forState:UIControlStateNormal];
            }else if ([self.prevViewController isKindOfClass:[OfferViewController class]]) {
                [self.btnSkip setTitle:@"Offer Later" forState:UIControlStateNormal];
            }else if ([self.prevViewController isKindOfClass:[HomeViewController class]] || [self.prevViewController isKindOfClass:[DetailPropertyViewController class]]) {
                if ([delegate.forFavorite isEqualToString:@"1"]) {
                    [self.btnSkip setTitle:@"Like Later" forState:UIControlStateNormal];
                }else if ([delegate.forQA isEqualToString:@"1"]) {
                    [self.btnSkip setTitle:@"Ask Later" forState:UIControlStateNormal];
                }
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
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

-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField
{
    activeField = textField;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 50)];
    keyboardToolBar.barStyle = UIBarStyleDefault;
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Go" style:UIBarButtonItemStyleDone target:self action:@selector(onJoinBtnPressed:)],
                                nil]];
    textField.inputAccessoryView = keyboardToolBar;
    return YES;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

-(void)textFieldDidBeginEditing: (UITextField *)textField
{
    activeField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onJoinBtnPressed:(id)sender {
    Reachability *hostReachability = [Reachability reachabilityWithHostName:serverUrl];
    NetworkStatus hostStatus = [hostReachability currentReachabilityStatus];
    if (hostStatus == NotReachable) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Your phone is not connected to Internet" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    [self.view endEditing:YES];
    if ([self.txtPhone.text isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Please Enter Your Phone Number" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.phone = [NSString stringWithFormat:@"60%@",self.txtPhone.text];
        NSString *reqString = [NSString stringWithFormat:@"%@?phoneNumber=%@", requestSMSUrl,delegate.phone];
        reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
        NSURL *url = [NSURL URLWithString:reqString];
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
        [self performSelectorOnMainThread:@selector(doneRequestSMS:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (IBAction)onSkipBtnPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    int i = 0;
    MyNavigationController *navController = (MyNavigationController *)self.navigationController;
    NSString *nextControllerName = delegate.afterControllerName;
    if (nextControllerName == nil || [nextControllerName isEqualToString:@""] || ![self.lblView isHidden]) {
        nextControllerName = @"HomeViewController";
    }
    for (i = 0; i < navController.viewControllers.count; i++) {
        if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:NSClassFromString(nextControllerName)]) {
            if ([nextControllerName isEqualToString:@"HomeViewController"]) {
                HomeViewController *homeViewController = (HomeViewController *)[navController.viewControllers objectAtIndex:i];
                homeViewController.prevViewController = self;
            }else if ([nextControllerName isEqualToString:@"PostNewViewController"]) {
                PostNewViewController *postNewViewController = (PostNewViewController *)[navController.viewControllers objectAtIndex:i];
                postNewViewController.prevViewController = self;
            }else if ([nextControllerName isEqualToString:@"OfferViewController"]) {
                OfferViewController *offerViewController = (OfferViewController *)[navController.viewControllers objectAtIndex:i];
                offerViewController.prevViewController = self;
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
        }/*else if ([nextControllerName isEqualToString:@"ProfileEditViewController"]) {
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
        }*/else if ([nextControllerName isEqualToString:@"PostNewViewController"]) {
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
        }else {
            MenuViewController *menuViewController = [[MenuViewController alloc] init];
            menuViewController.prevViewController = self;
            MyNavigationController *n = [[MyNavigationController alloc] initWithRootViewController:menuViewController];
            n.navigationBarHidden = YES;
            [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionLeft withOffset:0 animated:TRUE];
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"0"]) {
        if (range.location == 0) {
            return NO;
        }
    }
    return YES;
}

- (void) doneRequestSMS :(NSString*)data
{
    [self.view endEditing:YES];
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    /*if([[dataDict objectForKey:@"status"] isEqualToString:@"1"])
    {*/
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.need_register = [dataDict objectForKey:@"need_register"];
        VerifyViewController *verifyViewController = [[VerifyViewController alloc] init];
        [self.navigationController pushViewController:verifyViewController animated:YES];
    /*}else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Login" message:@"We are experiencing high load, and will rectify this as soon as possible. We are aware of this issue." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }*/
}

@end
