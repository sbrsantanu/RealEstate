//
//  OfferListViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "OfferListViewController.h"

#import "MenuViewController.h"
#import "DeclineReasonViewController.h"
#import "AppDelegate.h"
#import "ProfileEditViewController.h"
#import "MyNavigationController.h"
#import "AppointmentEditViewController.h"
#import "AppointmentViewController.h"
#import "OfferViewController.h"

#import "OfferCell.h"
#import "ReceivedOfferCell.h"
#import "MBProgressHUD.h"

#import "Offer.h"
#import "OfferTime.h"
#import "Property.h"
#import "Users.h"

#import "AFNetworking.h"

#import "NSString+SBJSON.h"

#import "Constant.h"

@interface OfferListViewController ()

@end

@implementation OfferListViewController

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
    option = 1;
    suboption = 0;
    [self.btnNew setBackgroundColor:[UIColor colorWithRed:156 / 255.0 green:204 / 255.0 blue:23 / 255.0 alpha:1.0]];
    [self.btnWaiting setBackgroundColor:[UIColor clearColor]];
    [self.btnDecline setBackgroundColor:[UIColor clearColor]];
    self.btnNew.layer.borderWidth = 0;
    self.btnWaiting.layer.borderWidth = 1;
    self.btnWaiting.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnDecline.layer.borderWidth = 1;
    self.btnDecline.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [self.subView setFrame:CGRectMake(0, 44, bounds.size.width, 43)];
        [tblList setFrame:CGRectMake(0,87,bounds.size.width,bounds.size.height - 107)];
        self.noLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 87, bounds.size.width, bounds.size.height - 107)];
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [self.subView setFrame:CGRectMake(0, 64, bounds.size.width, 43)];
        [tblList setFrame:CGRectMake(0,107,bounds.size.width,bounds.size.height - 107)];
        self.noLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 107, bounds.size.width, bounds.size.height - 107)];
    }
    self.noLabel.backgroundColor = [UIColor whiteColor];
    self.noLabel.textAlignment = NSTextAlignmentCenter;
    self.noLabel.font = [UIFont systemFontOfSize:20.0f];
    self.noLabel.textColor = [UIColor grayColor];
    self.noLabel.text = @"You do not have any pending offers.";
    [self.noLabel setHidden:YES];
    [self.view addSubview:self.noLabel];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    tblList.contentInset = contentInsets;
    tblList.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    CGPoint tPoint = activeField.frame.origin;
    tPoint.y += tblList.frame.origin.y + activeField.superview.frame.origin.y;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, tPoint)) {
        [tblList setContentOffset:CGPointMake(0.0, tblList.contentOffset.y + tPoint.y - aRect.size.height) animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    tblList.contentInset = contentInsets;
    tblList.scrollIndicatorInsets = contentInsets;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeField = textField;
    return YES;
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
    [self dismissView];
}

- (void)viewDidAppear:(BOOL)animated
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.userid == nil || [delegate.userid isEqualToString:@""] || [delegate.userid isEqualToString:@"0"]) {
        if ([self.prevViewController isKindOfClass:[MenuViewController class]]) {
            ProfileEditViewController *profileEditViewController = [[ProfileEditViewController alloc] init];
            profileEditViewController.prevViewController = self;
            [self.navigationController pushViewController:profileEditViewController animated:YES];
        }else {
            [self.revealSideViewController popViewControllerAnimated:YES];
        }
    }else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        if (![self.btnNew.backgroundColor isEqual:[UIColor clearColor]]) {
            [self getNewListInfo];
        }else if (![self.btnWaiting.backgroundColor isEqual:[UIColor clearColor]]) {
            [self getWaitingListInfo];
        }else if (![self.btnDecline.backgroundColor isEqual:[UIColor clearColor]]) {
            [self getDeclineListInfo];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setEnable:(BOOL)enable
{
    [self.view setUserInteractionEnabled:enable];
}

- (IBAction)onBackBtnPressed:(id)sender {
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    menuViewController.prevViewController = self;
    MyNavigationController *n = [[MyNavigationController alloc] initWithRootViewController:menuViewController];
    n.navigationBarHidden = YES;
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionLeft withOffset:0 animated:TRUE];
}

- (IBAction)onNewBtnPressed:(id)sender {
    option = 1;
    [self.btnNew setBackgroundColor:[UIColor colorWithRed:156 / 255.0 green:204 / 255.0 blue:23 / 255.0 alpha:1.0]];
    [self.btnWaiting setBackgroundColor:[UIColor clearColor]];
    [self.btnDecline setBackgroundColor:[UIColor clearColor]];
    self.btnNew.layer.borderWidth = 0;
    self.btnWaiting.layer.borderWidth = 1;
    self.btnWaiting.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnDecline.layer.borderWidth = 1;
    self.btnDecline.layer.borderColor = [[UIColor whiteColor] CGColor];
    if ([self.badgeNewBtn isHidden] == YES) {
        [self getNewListInfo];
    }
    [self.badgeNewBtn setHidden:YES];
    
}

- (IBAction)onWaitingBtnPressed:(id)sender {
    option = 2;
    [self.badgeNewBtn setHidden:YES];
    [self.btnWaiting setBackgroundColor:[UIColor colorWithRed:156 / 255.0 green:204 / 255.0 blue:23 / 255.0 alpha:1.0]];
    [self.btnNew setBackgroundColor:[UIColor clearColor]];
    [self.btnDecline setBackgroundColor:[UIColor clearColor]];
    self.btnWaiting.layer.borderWidth = 0;
    self.btnNew.layer.borderWidth = 1;
    self.btnNew.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnDecline.layer.borderWidth = 1;
    self.btnDecline.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self getWaitingListInfo];
}

- (IBAction)onDeclineBtnPressed:(id)sender {
    option = 3;
    [self.btnDecline setBackgroundColor:[UIColor colorWithRed:156 / 255.0 green:204 / 255.0 blue:23 / 255.0 alpha:1.0]];
    [self.btnNew setBackgroundColor:[UIColor clearColor]];
    [self.btnWaiting setBackgroundColor:[UIColor clearColor]];
    self.btnDecline.layer.borderWidth = 0;
    self.btnNew.layer.borderWidth = 1;
    self.btnNew.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnWaiting.layer.borderWidth = 1;
    self.btnWaiting.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.badgeDeclineBtn setHidden:YES];
    [self getDeclineListInfo];
}

- (void) getDeclineListInfo
{
    /*[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?task=offerlist&option=3&userid=%@", actionUrl,delegate.userid]];
    
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
        [self performSelectorOnMainThread:@selector(doneGetDeclineListInfo:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (odeclineOfferList.count > 0 || pdeclineOfferList.count > 0) {
                //[self.badgeDeclineBtn setHidden:NO];
                [self.badgeDeclineBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)odeclineOfferList.count + pdeclineOfferList.count] forState:UIControlStateNormal];
            }else {
                [self.badgeDeclineBtn setHidden:YES];
            }
            [tblList reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });*/
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Get Tenant Declined Data
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@' and status=2",delegate.userid]]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datecreated" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
    
    NSEntityDescription *offerEntity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
    [fetchRequest setEntity:offerEntity];
    NSArray *offerObjects = [context executeFetchRequest:fetchRequest error:&error];
    odeclineOfferList = [[NSMutableArray alloc] init];
    for (Offer *offerInfo in offerObjects) {
        Property *propInfo = offerInfo.propertyInfo;
        Users *userInfo = offerInfo.userInfo;
        NSMutableDictionary *offerData = [[NSMutableDictionary alloc] init];
        [offerData setValue:offerInfo.offerid forKey:@"id"];
        [offerData setValue:offerInfo.propertyid forKey:@"propertyid"];
        if ([propInfo.type isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [offerData setValue:propInfo.address1 forKey:@"propertyname"];
        }else {
            [offerData setValue:propInfo.name forKey:@"propertyname"];
        }
        [offerData setValue:offerInfo.term forKey:@"term"];
        [offerData setValue:offerInfo.price forKey:@"price"];
        [offerData setValue:userInfo.name forKey:@"username"];
        [offerData setValue:userInfo.photo forKey:@"photo"];
        [offerData setValue:offerInfo.datecreated forKey:@"datecreated"];
        [offerData setValue:@"2" forKey:@"type"];
        [offerData setValue:offerInfo.reason forKey:@"reason"];
        [odeclineOfferList addObject:offerData];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?task=offerlist&option=3&userid=%@", actionUrl,delegate.userid]];
        
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        [self performSelectorOnMainThread:@selector(doneGetDeclineListInfo:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            /*if (odeclineOfferList.count > 0 || pdeclineOfferList.count > 0) {
                [self.badgeDeclineBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)odeclineOfferList.count + pdeclineOfferList.count] forState:UIControlStateNormal];
            }else {
                [self.badgeDeclineBtn setHidden:YES];
            }*/
            [tblList reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void) doneGetDeclineListInfo :(NSString*)data
{
    NSDictionary  *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        //odeclineOfferList = [NSMutableArray arrayWithArray:[dataDict objectForKey:@"offer_decline_list"]];
        pdeclineOfferList = [NSMutableArray arrayWithArray:[dataDict objectForKey:@"property_decline_list"]];
        /*for (int i = 0; i < pdeclineOfferList.count; i++) {
            NSMutableDictionary *offerData = [[NSMutableDictionary alloc] init];
            [offerData setValue:[pde] forKey:@"id"];
            [offerData setValue:offerInfo.propertyid forKey:@"propertyid"];
            [offerData setValue:propInfo.name forKey:@"propertyname"];
            [offerData setValue:offerInfo.term forKey:@"term"];
            [offerData setValue:offerInfo.price forKey:@"price"];
            [offerData setValue:userInfo.name forKey:@"username"];
            [offerData setValue:userInfo.photo forKey:@"photo"];
            [offerData setValue:offerInfo.datecreated forKey:@"datecreated"];
            [offerData setValue:@"1" forKey:@"type"];
            [offerData setValue:offerInfo.reason forKey:@"reason"];
            [declineOfferList addObject:offerData];
        }*/
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Offer" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (void) getWaitingListInfo
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Get Offer Data
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@' and status=1",delegate.userid]]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datecreated" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
    
    NSEntityDescription *offerEntity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
    [fetchRequest setEntity:offerEntity];
    NSArray *offerObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *logintimes = [defaults valueForKey:@"logintimes3"];
    if (logintimes != nil && [logintimes isEqualToString:@"1"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
        dispatch_async(myqueue, ^{
            NSString *reqString = [NSString stringWithFormat:@"%@?task=getofferdata&userid=%@", serverActionUrl,delegate.userid];
            reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:reqString];
            NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            
            [self performSelectorOnMainThread:@selector(doneGetWaitingListInfo:) withObject:strData waitUntilDone:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [defaults setValue:@"0" forKeyPath:@"logintimes3"];
                [tblList reloadData];
            });
        });
    }else {
        waitingOfferList = [[NSMutableArray alloc] init];
        for (Offer *offerInfo in offerObjects) {
            Property *propInfo = offerInfo.propertyInfo;
            Users *userInfo = offerInfo.userInfo;
            if (propInfo == nil) {
                [context deleteObject:offerInfo];
                continue;
            }
            NSMutableDictionary *offerData = [[NSMutableDictionary alloc] init];
            [offerData setObject:offerInfo.offerid forKey:@"id"];
            [offerData setObject:offerInfo.propertyid forKey:@"propertyid"];
            if ([propInfo.type isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [offerData setObject:propInfo.address1 forKey:@"propertyname"];
            }else {
                [offerData setObject:propInfo.name forKey:@"propertyname"];
            }
            [offerData setObject:offerInfo.term forKey:@"term"];
            [offerData setObject:offerInfo.price forKey:@"price"];
            [offerData setObject:userInfo.name forKey:@"username"];
            [offerData setObject:userInfo.photo forKey:@"photo"];
            [waitingOfferList addObject:offerData];
        }
        [tblList reloadData];
    }
}

- (void) doneGetWaitingListInfo :(NSString*)data
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSDictionary  *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        NSArray *tempOfferList = (NSArray *)[dataDict objectForKey:@"offers"];
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MM-dd"];
        waitingOfferList = [[NSMutableArray alloc] init];
        for (int i = 0; i < tempOfferList.count; i++) {
            Offer *offerObject = [NSEntityDescription insertNewObjectForEntityForName:@"Offer" inManagedObjectContext:context];
            offerObject.offerid = [NSNumber numberWithInt:[[[tempOfferList objectAtIndex:i] objectForKey:@"id"] intValue]];
            offerObject.userid = [NSNumber numberWithInt:[[[tempOfferList objectAtIndex:i] objectForKey:@"userid"] intValue]];
            offerObject.propertyid = [NSNumber numberWithInt:[[[tempOfferList objectAtIndex:i] objectForKey:@"propertyid"] intValue]];
            offerObject.term = [NSNumber numberWithInt:[[[tempOfferList objectAtIndex:i] objectForKey:@"term"] intValue]];
            offerObject.price = [[tempOfferList objectAtIndex:i] objectForKey:@"price"];
            offerObject.status = [NSNumber numberWithInt:[[[tempOfferList objectAtIndex:i] objectForKey:@"status"] intValue]];
            offerObject.datecreated = [dateFormat dateFromString:[[tempOfferList objectAtIndex:i] objectForKey:@"datecreated"]];
            offerObject.reason = [[tempOfferList objectAtIndex:i] objectForKey:@"reason"];
            NSArray *offer_times = (NSArray *)[[tempOfferList objectAtIndex:i] objectForKey:@"times"];
            for (int j = 0; j < offer_times.count; j++) {
                OfferTime *timeObject = [NSEntityDescription insertNewObjectForEntityForName:@"OfferTime" inManagedObjectContext:context];
                timeObject.offerid = [NSNumber numberWithInt:[[[offer_times objectAtIndex:j] objectForKey:@"offerid"] intValue]];
                timeObject.weekday = [NSNumber numberWithInt:[[[offer_times objectAtIndex:j] objectForKey:@"weekday"] intValue]];
                timeObject.time = [NSNumber numberWithInt:[[[offer_times objectAtIndex:j] objectForKey:@"time"] intValue]];
                timeObject.status = [NSNumber numberWithInt:[[[offer_times objectAtIndex:j] objectForKey:@"status"] intValue]];
                timeObject.offerInfo = offerObject;
            }
            offerObject.userInfo = delegate.userObject;
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid!='%@' and propertyid='%@'",@"",offerObject.propertyid]]];
            NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
            [fetchRequest setEntity:propEntity];
            NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
            if (propObjects.count > 0) {
                offerObject.propertyInfo = (Property *)[propObjects objectAtIndex:0];
            }
            if ([offerObject.status intValue] == 1) {
                [waitingOfferList addObject:[tempOfferList objectAtIndex:i]];
            }
        }
        [delegate saveContext];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Offer" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (void) getNewListInfo
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?task=offerlist&option=1&userid=%@", actionUrl,delegate.userid]];
    
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
        [self performSelectorOnMainThread:@selector(doneGetNewListInfo:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (newOfferList.count == 0) {
                [self.badgeNewBtn setHidden:YES];
            }else {
                [self.badgeNewBtn setHidden:NO];
                int newCount = 0;
                for (int i = 0; i < newOfferList.count; i++) {
                    NSArray *offers = [[newOfferList objectAtIndex:i] objectForKey:@"data"];
                    for (int j = 0; j < offers.count; j++) {
                        if ([[[offers objectAtIndex:j] objectForKey:@"status"] isEqualToString:@"0"]) {
                            newCount++;
                        }
                    }
                }
                if (newCount == 0) {
                    [self.badgeNewBtn setHidden:YES];
                }
                [self.badgeNewBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)newCount] forState:UIControlStateNormal];
            }
            [tblList reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void) doneGetNewListInfo :(NSString*)data
{
    
    NSDictionary  *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        newOfferList = [NSMutableArray arrayWithArray:[dataDict objectForKey:@"offers"]];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Offer" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (option == 1) {
        if (newOfferList != nil) {
            if (newOfferList.count == 0) {
                [self.noLabel setHidden:NO];
                return 0;
            }else {
                [self.noLabel setHidden:YES];
                return [newOfferList count];
            }
        }else {
            return 0;
        }
    }else if (option == 2) {
        if (waitingOfferList != nil) {
            if (waitingOfferList.count == 0) {
                [self.noLabel setHidden:NO];
                return 0;
            }else {
                [self.noLabel setHidden:YES];
                return [waitingOfferList count];
            }
        }else {
            return 0;
        }
    }else if (option == 3) {
        if (odeclineOfferList != nil && pdeclineOfferList != nil) {
            if (odeclineOfferList.count == 0 && pdeclineOfferList.count == 0) {
                [self.noLabel setHidden:NO];
                return 0;
            }else {
                [self.noLabel setHidden:YES];
                return [odeclineOfferList count] + [pdeclineOfferList count];
            }
        }else {
            return 0;
        }
    }else {
        return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = @"";
    
    if (option == 1) {
        title = [[newOfferList objectAtIndex:section] objectForKey:@"propertyname"];
    }else if (option == 2) {
        title = [[waitingOfferList objectAtIndex:section] objectForKey:@"propertyname"];
    }else if (option == 3) {
        long pcount = pdeclineOfferList.count;
        if (section >= pcount) {
            title = [[odeclineOfferList objectAtIndex:(section - pcount)] objectForKey:@"propertyname"];
        }else {
            title = [[pdeclineOfferList objectAtIndex:section] objectForKey:@"propertyname"];
        }
    }
    return title;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (option == 1) {
        return [[[newOfferList objectAtIndex:section] objectForKey:@"data"] count];
    }else if (option == 2) {
        return 1;
    }else if (option == 3) {
        long pcount = pdeclineOfferList.count;
        if (section >= pcount) {
            return 1;
        }else {
            long pcount = pdeclineOfferList.count;
            if (section >= pcount) {
                return 1;
            }else {
                return [[[pdeclineOfferList objectAtIndex:section] objectForKey:@"data"] count];
            }
        }
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 123.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long pcount = pdeclineOfferList.count;
    if (option == 1 || option == 2 || (option == 3 && indexPath.section < pcount)) {
        if (option == 1) {
            offerList = [[NSMutableArray alloc] initWithArray:newOfferList];
        }else if (option == 2) {
            offerList = [[NSMutableArray alloc] initWithArray:waitingOfferList];
        }else if (option == 3) {
            offerList = [[NSMutableArray alloc] initWithArray:pdeclineOfferList];
        }
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"OfferCell" owner:self options:nil];
        OfferCell *cell = [nibArray objectAtIndex:0];
        CALayer *imageLayer = cell.imgPhoto.layer;
        [imageLayer setCornerRadius:18];
        [imageLayer setBorderColor:[[UIColor clearColor] CGColor]];
        [imageLayer setBorderWidth:1];
        [imageLayer setMasksToBounds:YES];
    
        NSDictionary *segTitleAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor grayColor], NSForegroundColorAttributeName,
                                       nil];
        [cell.segStatus setTitleTextAttributes:segTitleAttribute forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic;
        if (option == 1 || option == 3) {
            dic = [[[offerList objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
        }else if (option == 2) {
            dic = [offerList objectAtIndex:indexPath.section];
        }
        if (option == 2) {
            cell.lblOfferText.text = [NSString stringWithFormat:@"You offered RM%@/month", [dic objectForKey:@"price"]];
        }else {
            cell.lblOfferText.text = [NSString stringWithFormat:@"%@ offer RM%@/month",[dic objectForKey:@"username"], [dic objectForKey:@"price"]];
        }
        if (option == 2) {
            if ([dic objectForKey:@"photo"] != nil) {
                [cell.imgPhoto setImage:[UIImage imageWithData:[dic objectForKey:@"photo"]]];
            }else {
                cell.imgPhoto.image = [UIImage imageNamed:@"default_user.png"];
            }
        }else {
            if (![[dic objectForKey:@"photo"] isEqualToString:@""]) {
                [cell.imgPhoto setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",profilePhotoUrl, [dic objectForKey:@"photo"]]]];
            }else {
                cell.imgPhoto.image = [UIImage imageNamed:@"default_user.png"];
            }
        }
        cell.segStatus.tag = [[[offerList objectAtIndex:indexPath.section] objectForKey:@"id"] intValue];
        if (option == 3) {
            cell.segStatus.selectedSegmentIndex = 1;
        }else if (option == 2) {
            cell.segStatus.selectedSegmentIndex = 0;
        }else {
            cell.segStatus.selectedSegmentIndex = -1;
        }
        if (option == 1 || option == 2) {
            [cell.btnInfo setHidden:YES];
            [cell.txtReason setHidden:YES];
        }else {
            [cell.btnInfo setHidden:NO];
            cell.txtReason.text = [dic objectForKey:@"reason"];
            cell.txtReason.layer.borderWidth = 1.0f;
            cell.txtReason.layer.borderColor = [[UIColor grayColor] CGColor];
            [cell.btnInfo addTarget:self action:@selector(onBtnReasonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell.segStatus addTarget:self action:@selector(statusChanged:) forControlEvents:UIControlEventValueChanged];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else if (option == 3) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"ReceivedOfferCell" owner:self options:nil];
        ReceivedOfferCell *cell = [nibArray objectAtIndex:0];
        CALayer *imageLayer = cell.imgPhoto.layer;
        [imageLayer setCornerRadius:18];
        [imageLayer setBorderColor:[[UIColor clearColor] CGColor]];
        [imageLayer setBorderWidth:1];
        [imageLayer setMasksToBounds:YES];
        
        NSDictionary *dic = [odeclineOfferList objectAtIndex:(indexPath.section - pcount)];
        cell.lblOfferText.text = [NSString stringWithFormat:@"You offered RM%@/month", [dic objectForKey:@"price"]];
        if ([dic objectForKey:@"photo"] != nil) {
            [cell.imgPhoto setImage:[UIImage imageWithData:[dic objectForKey:@"photo"]]];
        }else {
            cell.imgPhoto.image = [UIImage imageNamed:@"default_user.png"];
        }
        
        [cell.btnInfo addTarget:self action:@selector(onBtnReasonPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnNewOffer.tag = [[[odeclineOfferList objectAtIndex:(indexPath.section - pcount)] objectForKey:@"id"] intValue];
        [cell.btnNewOffer addTarget:self action:@selector(addOffer:) forControlEvents:UIControlEventTouchUpInside];
        cell.txtReason.text = [dic objectForKey:@"reason"];
        cell.txtReason.layer.borderWidth = 1.0f;
        cell.txtReason.layer.borderColor = [[UIColor grayColor] CGColor];
        cell.txtNewOfferText.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else {
        return nil;
    }
}

- (void)addOffer: (UIButton *)sender
{
    /*[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        UIView *parentView = [sender superview];
        UITextField *txtOfferPrice = (UITextField *)[parentView.subviews objectAtIndex:2];
        NSString *reqString = [NSString stringWithFormat:@"%@?task=newoffersave&id=%ld&price=%@", actionUrl,(long)sender.tag,txtOfferPrice.text];
        reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:reqString];
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
        [self performSelectorOnMainThread:@selector(doneSaveNewOffer:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });*/
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"offerid='%ld' and status=2 and userid='%@'",(long)sender.tag,delegate.userid]]];
    NSEntityDescription *offerEntity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
    [fetchRequest setEntity:offerEntity];
    NSArray *offerObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (offerObjects.count > 0) {
        Offer *offerObject = (Offer *)[offerObjects objectAtIndex:0];
        UIView *parentView = [sender superview];
        UITextField *txtOfferPrice = (UITextField *)[parentView.subviews objectAtIndex:2];
        if (txtOfferPrice.text == nil || [[txtOfferPrice.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Offer" message:@"Please enter the offer price" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        if ([txtOfferPrice.text intValue] == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Offer" message:@"Invalid Rental Value" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        if (txtOfferPrice.text.length > 15) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Offer" message:@"Invalid Rental Value" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        offerObject.price = txtOfferPrice.text;
        offerObject.reason = @"";
        offerObject.status = [NSNumber numberWithInt:1];
        [delegate saveContext];
        NSDictionary *params = @{@"task":@"offersave",
                                 @"id":[NSString stringWithFormat:@"%ld",(long)sender.tag],
                                 @"price":txtOfferPrice.text,
                                 @"status":@"1"};
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
        [self onWaitingBtnPressed:nil];
    }
}

- (void) doneSaveNewOffer :(NSString*)data
{
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        /*[self getWaitingListInfo];
        [self getDeclineListInfo];*/
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Offer" message:@"You've already reoffered this property" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}
- (void)statusChanged:(UISegmentedControl *)sender
{
    if (option == 1 || option == 2) {
        if (sender.selectedSegmentIndex == 1) {
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [self onDeclineBtnPressed:nil];
            delegate.offerid = [NSString stringWithFormat:@"%ld",(long)sender.tag];
            DeclineReasonViewController *declineReasonViewController = [[DeclineReasonViewController alloc] init];
            [self.navigationController pushViewController:declineReasonViewController animated:YES];
        }else if (option == 1) {
            
            /*[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
            dispatch_async(myqueue, ^{
                NSString *reqString = [NSString stringWithFormat:@"%@?task=offersave&id=%ld&status=3", actionUrl,(long)sender.tag];
                reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:reqString];
                NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            
                [self performSelectorOnMainThread:@selector(doneSaveOffer:) withObject:strData waitUntilDone:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            });*/
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSDictionary *params = @{@"task":@"offersave",
                                     @"status":@"3",
                                     @"id":[NSString stringWithFormat:@"%d",sender.tag]
                                     };
            AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverActionUrl]];
            
            [client
             postPath:@"index.php"
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
            delegate.offerid = [NSString stringWithFormat:@"%d",sender.tag];
            AppointmentEditViewController *appointmentEditViewController = [[AppointmentEditViewController alloc] init];
            appointmentEditViewController.prevViewController = self;
            [self.navigationController pushViewController:appointmentEditViewController animated:YES];
        }
    }else if (option == 3) {
        /*[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
        dispatch_async(myqueue, ^{
            NSString *reqString = [NSString stringWithFormat:@"%@?task=offersave&id=%ld&status=1", actionUrl,(long)sender.tag];
            reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:reqString];
            NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
            [self performSelectorOnMainThread:@selector(doneSaveOffer:) withObject:strData waitUntilDone:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });*/
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = delegate.managedObjectContext;
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"offerid='%ld' and userid='%@' and status=2",(long)sender.tag,delegate.userid]]];
        NSEntityDescription *offerEntity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
        [fetchRequest setEntity:offerEntity];
        NSArray *offerObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (offerObjects.count > 0) {
            Offer *offerObject = (Offer *)[offerObjects objectAtIndex:0];
            offerObject.status = [NSNumber numberWithInt:1];
            [delegate saveContext];
        }
        NSDictionary *params = @{@"task":@"offersave",
                                 @"id":[NSString stringWithFormat:@"%ld",(long)sender.tag],
                                 @"status":@"3"};
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
        if (offerObjects.count == 0) {
            delegate.offerid = [NSString stringWithFormat:@"%d",sender.tag];
            AppointmentEditViewController *appointmentEditViewController = [[AppointmentEditViewController alloc] init];
            appointmentEditViewController.prevViewController = self;
            [self.navigationController pushViewController:appointmentEditViewController animated:YES];
        }else {
            [self onWaitingBtnPressed:nil];
        }
    }
}

- (void) doneSaveOffer :(NSString*)data
{
    
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        /*[self getNewListInfo];
        [self getWaitingListInfo];
        [self getDeclineListInfo];*/
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Offer" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

#pragma ---- UITableView delegate ----------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*int index = indexPath.row;
     
     int groupId = [[[arrTableList objectAtIndex:index] objectForKey:@"id"] intValue];
     
     
     [UIView transitionWithView:self.view.window
     duration:0.5f
     options:UIViewAnimationOptionTransitionCurlUp
     animations:^{
     SentEventController * pController = [[SentEventController alloc] initWithGroupId:groupId];
     [self.navigationController pushViewController:pController animated:NO];
     }
     completion:NULL];*/
    if (option == 2) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSDictionary *dic = [waitingOfferList objectAtIndex:indexPath.section];
        delegate.offerid = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"id"] intValue]];
        OfferViewController *offerViewController = [[OfferViewController alloc] init];
        offerViewController.prevViewController = self;
        [self.navigationController pushViewController:offerViewController animated:YES];
    }
    
}

- (void)onBtnReasonPressed:(id)sender
{
    for (int i = 0; i < tblList.numberOfSections; i++) {
        for (int j = 0; j < [tblList numberOfRowsInSection:i]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            if ([[tblList cellForRowAtIndexPath:indexPath] isKindOfClass:[ReceivedOfferCell class]]) {
                ReceivedOfferCell *cell = (ReceivedOfferCell *)[tblList cellForRowAtIndexPath:indexPath];
                [cell.txtReason setHidden:YES];
            }else if ([[tblList cellForRowAtIndexPath:indexPath] isKindOfClass:[OfferCell class]]) {
                OfferCell *cell = (OfferCell *)[tblList cellForRowAtIndexPath:indexPath];
                [cell.txtReason setHidden:YES];
            }
        }
    }
    UIButton *reasonBtn = (UIButton *)sender;
    NSArray *subViews = reasonBtn.superview.subviews;
    UITextView *txtReason = (UITextView *)[subViews objectAtIndex:[subViews count] - 1];
    if ([txtReason isHidden]) {
        [txtReason setHidden:NO];
    }else {
        [txtReason setHidden:YES];
    }
}

-(void)dismissView {
    for (int i = 0; i < tblList.numberOfSections; i++) {
        for (int j = 0; j < [tblList numberOfRowsInSection:i]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            if ([[tblList cellForRowAtIndexPath:indexPath] isKindOfClass:[ReceivedOfferCell class]]) {
                ReceivedOfferCell *cell = (ReceivedOfferCell *)[tblList cellForRowAtIndexPath:indexPath];
                [cell.txtReason setHidden:YES];
            }else if ([[tblList cellForRowAtIndexPath:indexPath] isKindOfClass:[OfferCell class]]) {
                OfferCell *cell = (OfferCell *)[tblList cellForRowAtIndexPath:indexPath];
                [cell.txtReason setHidden:YES];
            }
        }
    }
}

@end
