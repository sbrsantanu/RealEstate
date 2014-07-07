//
//  DeclineReasonViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/16/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "DeclineReasonViewController.h"

#import "AppDelegate.h"

#import "Constant.h"
#import "MBProgressHUD.h"

#import "AFNetworking.h"
#import "Offer.h"
#import "Property.h"

#import "NSString+SBJSON.h"

@interface DeclineReasonViewController ()

@end

@implementation DeclineReasonViewController

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
    
    self.txtAnswer.delegate = self;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [self.scrollView setFrame:CGRectMake(0,44,bounds.size.width,bounds.size.height - 64)];
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [self.scrollView setFrame:CGRectMake(0,64,bounds.size.width,bounds.size.height - 64)];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [self getOfferInfo];
}

-(void)viewWillAppear:(BOOL)animated
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getOfferInfo
{
    /*[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        NSString *reqString = [NSString stringWithFormat:@"%@?task=offerinfo&id=%@", actionUrl,delegate.offerid];
        reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:reqString];
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
        [self performSelectorOnMainThread:@selector(doneGetOfferInfo:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });*/
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"offerid='%@'",delegate.offerid]]];
    NSEntityDescription *offerEntity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
    [fetchRequest setEntity:offerEntity];
    NSArray *offerObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (offerObjects.count > 0) {
        Offer *offerObject = (Offer *)[offerObjects objectAtIndex:0];
        self.lblPropertyName.text = offerObject.propertyInfo.name;
        self.lblQuestion.text = @"Why do you want to withdraw this offer?";
        [self.btnDecline setTitle:@"Withdraw" forState:UIControlStateNormal];
    }else {
        self.lblQuestion.text = @"Why do you want to decline this offer?";
        [self.btnDecline setTitle:@"Decline" forState:UIControlStateNormal];
    }
}

- (void) doneGetOfferInfo :(NSString*)data
{
    
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSDictionary *dic = [dataDict objectForKey:@"offerinfo"];
        self.lblPropertyName.text = [dic objectForKey:@"propertyname"];
        NSString *userid = [dic objectForKey:@"userid"];
        if ([userid isEqualToString:delegate.userid]) {
            
        }else {
            self.lblQuestion.text = @"Why do you want to decline this offer?";
            [self.btnDecline setTitle:@"Decline" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)onBackBtnPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDeclineBtnPressed:(id)sender {
    
    if (self.txtAnswer.text == nil || [[self.txtAnswer.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reason" message:@"Please enter the reason" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"offerid='%@' and userid='%@'",delegate.offerid,delegate.userid]]];
    NSEntityDescription *offerEntity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
    [fetchRequest setEntity:offerEntity];
    NSArray *offerObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (offerObjects.count > 0) {
        Offer *offerObject = (Offer *)[offerObjects objectAtIndex:0];
        offerObject.status = [NSNumber numberWithInt:2];
        offerObject.reason = self.txtAnswer.text;
        [delegate saveContext];
    }
    
    NSDictionary *params = @{@"task":@"offersave",
                             @"id":delegate.offerid,
                             @"userid":delegate.userid,
                             @"reason":self.txtAnswer.text,
                             @"status":@"2"
                             };
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:actionUrl]];
    
    [client
     postPath:@"/json/index.php"
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
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
    CGPoint tPoint = activeView.frame.origin;
    tPoint.y = tPoint.y - self.scrollView.contentOffset.y + self.scrollView.frame.origin.y + activeView.frame.size.height;
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

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    activeView = textView;
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    activeView = nil;
}

- (void) doneSaveOfferReason :(NSString*)data
{
    
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reason" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

@end
