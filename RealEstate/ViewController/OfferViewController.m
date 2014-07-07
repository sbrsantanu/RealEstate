//
//  OfferViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "OfferViewController.h"
#import "OfferConfirmViewController.h"
#import "PostViewController.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "ProfileEditViewController.h"
#import "MyNavigationController.h"
#import "VerifyViewController.h"

#import "OfferListViewController.h"

#import "Message.h"
#import "AFNetworking.h"

#import "Users.h"

#import "PropertyCell.h"
#import "MBProgressHUD.h"

#import "Offer.h"
#import "OfferTime.h"
#import "Property.h"

#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"

#import "AppDelegate.h"
#import "Constant.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <AddressBook/AddressBook.h>

@interface OfferViewController ()

@end

@implementation OfferViewController

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
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [mainView1 setFrame:CGRectMake(0,44,bounds.size.width,bounds.size.height - 64)];
        [mainView2 setFrame:CGRectMake(bounds.size.width,44,bounds.size.width,bounds.size.height - 64)];
        [mainView3 setFrame:CGRectMake(bounds.size.width * 2,44,bounds.size.width,bounds.size.height - 64)];
    }else {
        [navView setFrame:CGRectMake(0,0,bounds.size.width,64)];
        [mainView1 setFrame:CGRectMake(0,64,bounds.size.width,bounds.size.height - 64)];
        [mainView2 setFrame:CGRectMake(bounds.size.width,64,bounds.size.width,bounds.size.height - 64)];
        [mainView3 setFrame:CGRectMake(bounds.size.width * 2,64,bounds.size.width,bounds.size.height - 64)];
    }
    [mainView1 setContentSize:CGSizeMake(bounds.size.width,504)];
    [mainView2 setContentSize:CGSizeMake(bounds.size.width,504)];
    [mainView3 setContentSize:CGSizeMake(bounds.size.width,504)];
    [self.view addSubview:mainView1];
    [self.view addSubview:mainView2];
    [self.view addSubview:mainView3];
    CALayer *imageLayer = self.imgGroupPhoto.layer;
    [imageLayer setBorderColor:[[UIColor clearColor] CGColor]];
    [imageLayer setCornerRadius:25];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    // Do any additional setup after loading the view from its nib.
    
    NSDate *now = [NSDate date];
    //NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:now];
    weekdayStr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++) {
        //long weekday = i + 1;
        //long offsetDay = weekday - [dateComponents weekday] + 1;
        long offsetDay = i;
        NSDate *newDate = [ now dateByAddingTimeInterval:offsetDay * 24 * 60 * 60];
        NSDateComponents *newDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:newDate];
        [newDateComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
        NSString *dayStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents day]];
        if ([newDateComponents day] < 10) {
            dayStr = [NSString stringWithFormat:@"0%@",dayStr];
        }
        NSString *monthStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents month]];
        if ([newDateComponents month] < 10) {
            monthStr = [NSString stringWithFormat:@"0%@",monthStr];
        }
        [weekdayStr addObject:[NSString stringWithFormat:@"%@/%@",dayStr,monthStr]];
    }
    int realRow = 1;
    int newLeft = 0, newTop = 0;
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 8; j++) {
            if (i == 0 && j == 0) {
                newTop += 25;
                continue;
            }
            UIButton *btnNew = [[UIButton alloc] init];
            if (i > 0) {
                btnNew.frame = CGRectMake(newLeft, newTop, 50,22);
            }else {
                btnNew.frame = CGRectMake(newLeft, newTop, 41,22);
            }
            if (i == 0 && j > 0) {
                //long weekday = j;
                //long offsetDay = weekday - [dateComponents weekday] + 1;
                long offsetDay = j - 1;
                NSDate *newDate = [ now dateByAddingTimeInterval:offsetDay * 24 * 60 * 60];
                NSDateComponents *newDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:newDate];
                [newDateComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
                NSString *dayStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents day]];
                if ([newDateComponents day] < 10) {
                    dayStr = [NSString stringWithFormat:@"0%@",dayStr];
                }
                NSString *monthStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents month]];
                if ([newDateComponents month] < 10) {
                    monthStr = [NSString stringWithFormat:@"0%@",monthStr];
                }
                NSLog(@"%ld",[delegate getHour:[NSDate date]]);
                if ([delegate getMonth:[NSDate date]] == [monthStr intValue] && [delegate getDay:[NSDate date]] == [dayStr intValue] && [delegate getHour:[NSDate date]] > 20) {
                    [btnNew setHidden:YES];
                }else {
                    realRow++;
                    [btnNew setHidden:NO];
                    if (j == 7) {
                        newLeft = 40;
                        newTop = 0;
                    }else {
                        newTop += 27;
                    }
                }
                [btnNew.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
                [btnNew setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [btnNew setTitle:[NSString stringWithFormat:@"%@/%@",dayStr,monthStr] forState:UIControlStateNormal];
            }
            if (i > 0 && j == 0) {
                [btnNew.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
                [btnNew setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                if (i == 1) {
                    [btnNew setTitle:[NSString stringWithFormat:@"0%d-%d", 9 + (i - 1) * 3, 9 + i * 3] forState:UIControlStateNormal];
                }else {
                    [btnNew setTitle:[NSString stringWithFormat:@"%d-%d", 9 + (i - 1) * 3, 9 + i * 3] forState:UIControlStateNormal];
                }
                newTop += 25;
            }
            btnNew.userInteractionEnabled = YES;
            btnNew.backgroundColor = [UIColor whiteColor];
            if (i > 0 && j > 0) {
                //long weekday = j;
                //long offsetDay = weekday - [dateComponents weekday] + 1;
                long offsetDay = j - 1;
                NSDate *newDate = [ now dateByAddingTimeInterval:offsetDay * 24 * 60 * 60];
                NSDateComponents *newDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:newDate];
                [newDateComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
                NSString *dayStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents day]];
                if ([newDateComponents day] < 10) {
                    dayStr = [NSString stringWithFormat:@"0%@",dayStr];
                }
                NSString *monthStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents month]];
                if ([newDateComponents month] < 10) {
                    monthStr = [NSString stringWithFormat:@"0%@",monthStr];
                }
                if ([delegate getMonth:[NSDate date]] == [monthStr intValue] && [delegate getDay:[NSDate date]] == [dayStr intValue] && [delegate getHour:[NSDate date]] > 20) {
                    [btnNew setHidden:YES];
                }else {
                    if (j == 7) {
                        newLeft += 61;
                        newTop = 0;
                    }else {
                        newTop += 27;
                    }
                    if ([delegate getMonth:[NSDate date]] == [monthStr intValue] && [delegate getDay:[NSDate date]] == [dayStr intValue] && [delegate getHour:[NSDate date]] >= (i + 3) * 3) {
                        [btnNew setHidden:YES];
                    }else {
                        [btnNew setHidden:NO];
                    }
                }
                btnNew.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                btnNew.layer.borderWidth = 0.5f;
                btnNew.layer.cornerRadius = 11.0f;
                [btnNew addTarget:self action:@selector(checkButton:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.timeView addSubview:btnNew];
        }
    }
    
    CGRect frame = self.timeView.frame;
    frame.size.width = 40 + 4 * 61;
    frame.size.height = realRow * 27;
    [self.timeView setFrame:frame];
    frame = self.lblLandTime.frame;
    frame.origin.y = self.timeView.frame.origin.y + self.timeView.frame.size.height + 10;
    [self.lblLandTime setFrame:frame];
    
    self.imgLandTime.layer.cornerRadius = 7.0f;
    self.imgSelTime.layer.cornerRadius = 7.0f;
    frame = self.viewLandTime.frame;
    frame.origin.y = self.timeView.frame.origin.y + self.timeView.frame.size.height + 10;
    [self.viewLandTime setFrame:frame];
    
    frame = self.viewSelTime.frame;
    frame.origin.y = self.timeView.frame.origin.y + self.timeView.frame.size.height + 10;
    [self.viewSelTime setFrame:frame];
    
    self.txtOffer.delegate = self;
    
    selColor = [[UIColor alloc] initWithRed:242 / 255.0 green:70 / 255.0 blue:127 / 255.0 alpha:1.0];
    noSelColor = [[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    self.client = delegate.client;
    self.dataModel = delegate.dataModel;
    [self getPostInfo];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.prevViewController != nil && [self.prevViewController isKindOfClass:[LoginViewController class]]) {
    }else if (self.prevViewController != nil && [self.prevViewController isKindOfClass:[VerifyViewController class]]) {
        [self performSelector:@selector(onNextBtnPressed:) withObject:self];
    }
}

- (void)dismissKeyboard {
    [self.txtOffer resignFirstResponder];
}

- (void) getPostInfo {
    /*[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *reqString = [NSString stringWithFormat:@"%@?task=postinfo&id=%@", actionUrl,delegate.pid];
        reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:reqString];
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        [self performSelectorOnMainThread:@selector(doneGetPropertyInfo:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });*/
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Get Property Data
    if (self.prevViewController != nil && [self.prevViewController isKindOfClass:[OfferListViewController class]]) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"offerid='%@' and userid='%@'",delegate.offerid,delegate.userid]]];
        [fetchRequest setSortDescriptors:nil];
        
        NSEntityDescription *offerEntity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
        [fetchRequest setEntity:offerEntity];
        NSArray *offerObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (offerObjects.count > 0) {
            prefertimestart = [NSDate date];
            Offer *offerInfo = (Offer *)[offerObjects objectAtIndex:0];
            Property *propInfo = offerInfo.propertyInfo;
            delegate.pid = [NSString stringWithFormat:@"%d",[offerInfo.propertyid intValue]];
            NSSet *offerTimeInfo = offerInfo.timeInfo;
            self.lblPrice.text = [NSString stringWithFormat:@"RM%@/mo",propInfo.rental];
            if ([propInfo.type isEqualToNumber:[NSNumber numberWithInt:2]] && propInfo.name != nil && ![propInfo.name isEqualToString:@""]) {
                self.lblPropertyName.text = [NSString stringWithFormat:@"Offer(%@)",propInfo.name];
            }/*else if ([propInfo.type isEqualToNumber:[NSNumber numberWithInt:2]]) {
              self.lblPropertyName.text = [NSString stringWithFormat:@"Offer(%@)",propInfo.address1];
              }*/else {
                  self.lblPropertyName.text = @"Offer";
            }
            self.txtOffer.text = offerInfo.price;
            NSMutableArray *timeDict = [[NSMutableArray alloc] init];
            if (propInfo.time != nil && ![propInfo.time isEqualToString:@""]) {
                timeDict = (NSMutableArray *)[propInfo.time JSONValue];
            }
            BOOL isSet = FALSE;
            if (timeDict != nil && timeDict.count > 0) {
                for (int i = 0; i < 7; i++) {
                    NSArray *times = (NSArray *)[timeDict objectAtIndex:i];
                    for (int j = 0; j < 4; j++) {
                        if ([[times objectAtIndex:j] intValue] == 1) {
                            isSet = TRUE;
                        }
                    }
                }
            }
            if (!isSet) {
                for (int i = 0; i < 7; i++) {
                    NSMutableArray *times = [[NSMutableArray alloc] init];
                    for (int j = 0; j < 4; j++) {
                        [times addObject:[NSString stringWithFormat:@"%d",1]];
                    }
                    [timeDict addObject:times];
                }
            }
            if (timeDict != nil && timeDict.count > 0) {
                for (int i = 0; i < 7; i++) {
                    UIButton *lblTime = (UIButton *)[self.timeView.subviews objectAtIndex:i];
                    NSArray *times = (NSArray *)[timeDict objectAtIndex:i];
                    for (int j = 0; j < 4; j++) {
                        BOOL isExists = NO;
                        for (OfferTime *offerTime in offerTimeInfo) {
                            if ([offerTime.weekday isEqualToNumber:[NSNumber numberWithInt:i + 1]] && [offerTime.time intValue] >= (j + 3) * 3 && [offerTime.time intValue] <= (j + 4) * 3) {
                                isExists = YES;
                                break;
                            }
                        }
                        NSDateComponents *newDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:prefertimestart];
                        if (propInfo.prefertimestart != nil) {
                            NSDate *newDate = [propInfo.prefertimestart dateByAddingTimeInterval:i * 24 * 60 * 60];
                            newDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:newDate];
                            [newDateComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
                        }
                        NSString *dayStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents day]];
                        if ([newDateComponents day] < 10) {
                            dayStr = [NSString stringWithFormat:@"0%@",dayStr];
                        }
                        NSString *monthStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents month]];
                        if ([newDateComponents month] < 10) {
                            monthStr = [NSString stringWithFormat:@"0%@",monthStr];
                        }
                        UIButton *btnTime = (UIButton *)[self.timeView.subviews objectAtIndex:(j + 1) * 8 + i];
                        if ([[times objectAtIndex:j] intValue] == 1) {
                            if ([lblTime.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%@/%@",dayStr,monthStr]]) {
                                btnTime.backgroundColor = [UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                            }else {
                                btnTime.backgroundColor = [UIColor whiteColor];
                            }
                        }else {
                            btnTime.backgroundColor = [UIColor whiteColor];
                        }
                    }
                }
            }
        }
    }else {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"propertyid='%@' and userid!='%@'",delegate.pid,delegate.userid]]];
        [fetchRequest setSortDescriptors:nil];
        
        NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
        [fetchRequest setEntity:propEntity];
        NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (propObjects.count > 0) {
            Property *propInfo = (Property *)[propObjects objectAtIndex:0];
            self.lblPrice.text = [NSString stringWithFormat:@"RM%@/mo",propInfo.rental];
            if ([propInfo.type isEqualToNumber:[NSNumber numberWithInt:2]] && propInfo.name != nil && ![propInfo.name isEqualToString:@""]) {
                self.lblPropertyName.text = [NSString stringWithFormat:@"Offer(%@)",propInfo.name];
            }/*else if ([propInfo.type isEqualToNumber:[NSNumber numberWithInt:2]]) {
              self.lblPropertyName.text = [NSString stringWithFormat:@"Offer(%@)",propInfo.address1];
              }*/else {
                  self.lblPropertyName.text = @"Offer";
              }
            NSMutableArray *timeDict = [[NSMutableArray alloc] init];
            if (propInfo.time != nil && ![propInfo.time isEqualToString:@""]) {
                timeDict = (NSMutableArray *)[propInfo.time JSONValue];
            }
            BOOL isSet = FALSE;
            if (timeDict != nil && timeDict.count > 0) {
                for (int i = 0; i < 7; i++) {
                    NSArray *times = (NSArray *)[timeDict objectAtIndex:i];
                    for (int j = 0; j < 4; j++) {
                        if ([[times objectAtIndex:j] intValue] == 1) {
                            isSet = TRUE;
                        }
                    }
                }
            }
            if (!isSet) {
                for (int i = 0; i < 7; i++) {
                    NSMutableArray *times = [[NSMutableArray alloc] init];
                    for (int j = 0; j < 4; j++) {
                        [times addObject:[NSString stringWithFormat:@"%d",1]];
                    }
                    [timeDict addObject:times];
                }
            }
            prefertimestart = [NSDate date];
            if (timeDict != nil && timeDict.count > 0) {
                for (int i = 0; i < 7; i++) {
                    UIButton *lblTime = (UIButton *)[self.timeView.subviews objectAtIndex:i];
                    NSArray *times = (NSArray *)[timeDict objectAtIndex:i];
                    for (int j = 0; j < 4; j++) {
                        NSDateComponents *newDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:prefertimestart];
                        if (propInfo.prefertimestart != nil) {
                            NSDate *newDate = [propInfo.prefertimestart dateByAddingTimeInterval:i * 24 * 60 * 60];
                            newDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:newDate];
                            [newDateComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
                        }
                        NSString *dayStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents day]];
                        if ([newDateComponents day] < 10) {
                            dayStr = [NSString stringWithFormat:@"0%@",dayStr];
                        }
                        NSString *monthStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents month]];
                        if ([newDateComponents month] < 10) {
                            monthStr = [NSString stringWithFormat:@"0%@",monthStr];
                        }
                        UIButton *btnTime = (UIButton *)[self.timeView.subviews objectAtIndex:(j + 1) * 8 + i];
                        if ([[times objectAtIndex:j] intValue] == 1) {
                            if ([lblTime.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%@/%@",dayStr,monthStr]]) {
                                btnTime.backgroundColor = [UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                            }else {
                                btnTime.backgroundColor = [UIColor whiteColor];
                            }
                        }else {
                            btnTime.backgroundColor = [UIColor whiteColor];
                        }
                    }
                }
            }
        }
    }
}

- (void)postMessageRequest
{
    [self.view endEditing:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *params = @{@"cmd":@"message",
                             @"user_id":[_dataModel userId],
                             @"message_type":@"NewOffer",
                             @"user_photo":delegate.photo,
                             @"user_type":_dataModel.userType,
                             @"text":[NSString stringWithFormat:@"%@",delegate.pid]};
    Message* message = [[Message alloc] init];
    message.senderName = nil;
    message.senderPhoto = delegate.photo;
    message.userType = _dataModel.userType;
    message.messageType = @"NewOffer";
    message.date = [NSDate date];
    message.text = [NSString stringWithFormat:@"%@",delegate.pid];
    
    // Add the Message to the data model's list of messages
    //long index =
    [_dataModel addMessage:message];
    NSLog(@"%lu",(unsigned long)_dataModel.messages.count);
    
    // Add a row for the Message to ChatViewController's table view.
    // Of course, ComposeViewController doesn't really know that the
    // delegate is the ChatViewController.
    //[self didSaveMessage:message atIndex:index];
    
    [_client
     postPath:@"/api.php"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         //[MBProgressHUD hideHUDForView:self.view animated:YES];
         if (operation.response.statusCode != 200) {
             //ShowErrorAlert(NSLocalizedString(@"Could not send the message to the server", nil));
         } else {
             // Create a new Message object
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if ([self isViewLoaded]) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             //ShowErrorAlert([error localizedDescription]);
         }
     }];
}

- (void) doneGetPropertyInfo :(NSString*)data
{
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        NSDictionary *dic = (NSDictionary *)[dataDict objectForKey:@"postinfo"];
        self.lblPrice.text = [NSString stringWithFormat:@"%@/mo",[dic objectForKey:@"rental"]];
        self.lblPropertyName.text = [NSString stringWithFormat:@"Offer %@",[dic objectForKey:@"name"]];
        NSArray *timeDict = nil;
        if ([dic objectForKey:@"time"] != nil && ![[dic objectForKey:@"time"] isEqualToString:@""]) {
            timeDict = (NSArray *)[[dic objectForKey:@"time"] JSONValue];
        }
        if (timeDict != nil && timeDict.count > 0) {
            for (int i = 0; i < 7; i++) {
                NSArray *times = (NSArray *)[timeDict objectAtIndex:i];
                for (int j = 0; j < 4; j++) {
                    UIButton *btnTime = (UIButton *)[self.timeView.subviews objectAtIndex:(j + 1) * 8 + i];
                    if ([[times objectAtIndex:j] intValue] == 1) {
                        btnTime.backgroundColor = [UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                    }else {
                        btnTime.backgroundColor = [UIColor whiteColor];
                    }
                }
            }
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Make An Offer" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Go" style:UIBarButtonItemStyleDone target:self action:@selector(onNextBtnPressed:)],
                                nil]];
    textField.inputAccessoryView = keyboardToolBar;
    return YES;
}

- (void)checkButton: (UIButton *)sender
{
    if (sender.backgroundColor == [UIColor whiteColor]) {
        return;
    }
    
    if ([[sender backgroundColor] isEqual:selColor]) {
        [sender setBackgroundColor:noSelColor];
    }else {
        [sender setBackgroundColor:selColor];
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
    if (mainView3.frame.origin.x == 0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        mainView1.transform = CGAffineTransformMakeTranslation( -320, 0 );
        mainView2.transform = CGAffineTransformMakeTranslation( -320, 0 );
        mainView3.transform = CGAffineTransformMakeTranslation( -320, 0 );
        [UIView commitAnimations];
    }else if (mainView2.frame.origin.x == 0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        mainView1.transform = CGAffineTransformMakeTranslation( 0, 0 );
        mainView2.transform = CGAffineTransformMakeTranslation( 0, 0 );
        mainView3.transform = CGAffineTransformMakeTranslation( 0, 0 );
        [UIView commitAnimations];
    }else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)onTermBtn1Pressed:(id)sender {
    [self.btnTerm1 setImage:[UIImage imageNamed:@"check_btn1.png"] forState:UIControlStateNormal];
    [self.btnTerm2 setImage:[UIImage imageNamed:@"check_btn4.png"] forState:UIControlStateNormal];
}

- (IBAction)onTermBtn2Pressed:(id)sender {
    [self.btnTerm1 setImage:[UIImage imageNamed:@"check_btn2.png"] forState:UIControlStateNormal];
    [self.btnTerm2 setImage:[UIImage imageNamed:@"check_btn3.png"] forState:UIControlStateNormal];
}

- (IBAction)onSearchMoreBtnPressed:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    int point = [delegate.quality intValue];
    if (point < 13) {
        /*ProfileEditViewController *profileEditViewController = [[ProfileEditViewController alloc] init];
        [self.navigationController pushViewController:profileEditViewController animated:YES];*/
    }else {
        MyNavigationController *navController = (MyNavigationController *)self.navigationController;
        int i = 0;
        for (i = 0; i < navController.viewControllers.count; i++) {
            if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[HomeViewController class]]) {
                [self.navigationController popToViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
                break;
            }
        }
        if (i == navController.viewControllers.count) {
            HomeViewController *homeViewController = [[HomeViewController alloc] init];
            homeViewController.prevViewController = self;
            [self.navigationController pushViewController:homeViewController animated:YES];
        }
    }
}

- (IBAction)onNextBtnPressed:(id)sender {
    if (mainView1.frame.origin.x == 0) {
        [self.view endEditing:YES];
        if (self.txtOffer.text == nil || [[self.txtOffer.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqual:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Make An Offer" message:@"Please Enter Offer Price" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (_btnTerm1.imageView.image == [UIImage imageNamed:@"check_btn.png"]) {
            delegate.term = @"1";
        }else {
            delegate.term = @"2";
        }
        if ([self.txtOffer.text intValue] <= 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Make An Offer" message:@"Invalid Offer Price" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        
        if (self.txtOffer.text.length > 15) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Make An Offer" message:@"Invalid Offer Price" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        
        delegate.offerPrice = self.txtOffer.text;
        UIFont *font = [UIFont systemFontOfSize:9.0f];
        CGFloat newTop = 0.0f;
        int nRows = 0;
        NSArray *viewsToRemove = [self.timeView1 subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        //NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:now];
        for (int j = 0; j < 7; j++) {
            int prevIndex = -1;
            for (int i = 0; i < 4; i++) {
                UIButton *btnTime = (UIButton *)[self.timeView.subviews objectAtIndex:(i + 1) * 8 + j];
                if ([btnTime.backgroundColor isEqual:selColor]) {
                    UILabel *newWeek = [[UILabel alloc] initWithFrame:CGRectMake(0,newTop, 61, 26)];
                    [newWeek setTextColor:[UIColor grayColor]];
                    [newWeek setTextAlignment:NSTextAlignmentCenter];
                    newWeek.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                    newWeek.layer.borderWidth = 0.5f;
                    [newWeek setFont:font];
                    if (prevIndex != j) {
                        //long weekday = j + 1;
                        //long offsetDay = weekday - [dateComponents weekday] + 1;
                        long offsetDay = j;
                        NSDate *newDate = [ prefertimestart dateByAddingTimeInterval:offsetDay * 24 * 60 * 60];
                        NSDateComponents *newDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:newDate];
                        NSString *dayStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents day]];
                        if ([newDateComponents day] < 10) {
                            dayStr = [NSString stringWithFormat:@"0%@",dayStr];
                        }
                        NSString *monthStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents month]];
                        if ([newDateComponents month] < 10) {
                            monthStr = [NSString stringWithFormat:@"0%@",monthStr];
                        }
                        [newWeek setText:[NSString stringWithFormat:@"%@/%@",dayStr,monthStr]];
                    }
                    [self.timeView1 addSubview:newWeek];
                    for (int k = (i + 3) * 3; k < (i + 4) * 3; k++) {
                        UIButton *newView = [[UIButton alloc] initWithFrame:CGRectMake(60 + (k % 3) * 50, newTop, 51,26)];
                        [newView.titleLabel setFont:font];
                        [newView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        newView.backgroundColor = selColor;
                        newView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                        newView.layer.borderWidth = 0.5f;
                        //newView.layer.cornerRadius = 11.0f;
                        [newView setTitle:[NSString stringWithFormat:@"%d:00",k] forState:UIControlStateNormal];
                        [newView addTarget:self action:@selector(checkTimeButton:) forControlEvents:UIControlEventTouchUpInside];
                        [self.timeView1 addSubview:newView];
                    }
                    newTop += 25;
                    nRows++;
                    prevIndex = j;
                }
            }
        }
        if (nRows == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Make An Offer" message:@"Please Select At least One Time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        if (nRows > 0) {
            CGRect frame = self.timeView1.frame;
            frame.size.height = 26 * nRows;
            [self.timeView1 setFrame:frame];
        }
        CGRect frame = btnSelMark.frame;
        frame.origin.y = self.timeView1.frame.origin.y + newTop + 20;
        [btnSelMark setFrame:frame];
        CGRect bounds = [[UIScreen mainScreen] bounds];
        [mainView2 setContentSize:CGSizeMake(bounds.size.width, btnSelMark.frame.origin.y + btnSelMark.frame.size.height + 20)];
        //timeString = [NSString stringWithFormat:@"%@]",timeString];
        //delegate.time = timeString;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        self.lblList.text = [NSString stringWithFormat:@"List Price:%@",self.lblPrice.text];
        self.lblOffer.text = [NSString stringWithFormat:@"Your Offer: RM%@/mo",self.txtOffer.text];
        int offer_price = [self.txtOffer.text intValue];
        int from_price = offer_price - (offer_price / 10);
        self.lblDescription.text = [NSString stringWithFormat:@"You agree that the final offer to landlord after viewing is between RM%d-RM%d/mo",from_price,offer_price];
        mainView1.transform = CGAffineTransformMakeTranslation( -320, 0 );
        mainView2.transform = CGAffineTransformMakeTranslation( -320, 0 );
        mainView3.transform = CGAffineTransformMakeTranslation( -320, 0 );
        [UIView commitAnimations];
    }else if (mainView2.frame.origin.x == 0) {
        NSString *curName = @"";
        NSString *prevName = @"";
        NSArray *times = self.timeView1.subviews;
        NSMutableArray *timeArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < times.count; i++) {
            if (i % 4 == 0) {
                UILabel *weekLabel = (UILabel *)[times objectAtIndex:i];
                if (weekLabel.text != nil && ![weekLabel.text isEqualToString:@""]) {
                    curName = weekLabel.text;
                }
            }else {
                UIButton *timeBtn = (UIButton *)[times objectAtIndex:i];
                if ([timeBtn.backgroundColor isEqual:selColor]) {
                    int curWeek = -1;
                    for (int j = 0; j < weekdayStr.count; j++) {
                        if ([[weekdayStr objectAtIndex:j] isEqualToString:curName]) {
                            curWeek = j;
                            break;
                        }
                    }
                    NSString *timeStr = [timeBtn titleForState:UIControlStateNormal];
                    timeStr = [timeStr substringToIndex:[timeStr length] - 3];
                    NSDictionary *time = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",curWeek],@"weekday",timeStr,@"time", nil];
                    [timeArray addObject:time];
                }
            }
            prevName = curName;
        }
        NSString *offerTimeStr = @"[";
        for (int i = 0; i < timeArray.count; i++) {
            if (i > 0) {
                offerTimeStr = [NSString stringWithFormat:@"%@,",offerTimeStr];
            }
            NSDictionary *timeDict = (NSDictionary *)[timeArray objectAtIndex:i];
            offerTimeStr = [NSString stringWithFormat:@"%@[%@,%@]",offerTimeStr,[timeDict objectForKey:@"weekday"],[timeDict objectForKey:@"time"]];
        }
        offerTimeStr = [NSString stringWithFormat:@"%@]",offerTimeStr];
        if (timeArray.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Make An Offer" message:@"Please select at least one time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (delegate.phone == nil || [delegate.phone isEqualToString:@""]) {
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            loginViewController.prevViewController = self;
            loginViewController.lblError = [[UILabel alloc] initWithFrame:CGRectMake(22,23,251,96)];
            loginViewController.lblView = [[UILabel alloc] initWithFrame:CGRectMake(12,29,296,141)];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                loginViewController.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height - 20)];
                loginViewController.imgBack = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height - 20)];
            }else {
                loginViewController.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
                loginViewController.imgBack = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
            }
            CGRect bounds = [[UIScreen mainScreen] bounds];
            UIView *viewStatus = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 20)];
            viewStatus.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
            
            [loginViewController.imgBack setImage:[UIImage imageNamed:@"phone_bg1.png"]];
            [loginViewController.imgBack setHidden:YES];
            [loginViewController.view addSubview:loginViewController.imgBack];
            [loginViewController.lblView addSubview:loginViewController.lblError];
            [loginViewController.scrollView addSubview:loginViewController.lblView];
            [loginViewController.view addSubview:loginViewController.scrollView];
            [loginViewController.view addSubview:viewStatus];
            loginViewController.lblError.text = @"Ops, you have not registered or sign in to make an offer for this property. Signing in is quick, just enter your mobile number";
            [loginViewController.lblView setHidden:NO];
            delegate.afterControllerName = @"OfferViewController";
            [self.navigationController pushViewController:loginViewController animated:YES];
            return;
        }else {
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context = delegate.managedObjectContext;
            NSError *error;
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            Offer *offerObject;
            if (self.prevViewController != nil && [self.prevViewController isKindOfClass:[OfferListViewController class]]) {
                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"offerid='%@' and userid='%@'",delegate.offerid,delegate.userid]]];
                NSEntityDescription *offerEntity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
                [fetchRequest setEntity:offerEntity];
                [fetchRequest setSortDescriptors:nil];
                NSArray *offerObjects = [context executeFetchRequest:fetchRequest error:&error];
                if (offerObjects.count > 0) {
                    offerObject = (Offer *)[offerObjects objectAtIndex:0];
                }
            }else {
                offerObject = [NSEntityDescription insertNewObjectForEntityForName:@"Offer" inManagedObjectContext:context];
            }

            offerObject.propertyid = [NSNumber numberWithInt:[delegate.pid intValue]];
            offerObject.userid = [NSNumber numberWithInt:[delegate.userid intValue]];
            offerObject.term = [NSNumber numberWithInt:[delegate.term intValue]];
            offerObject.price = [NSString stringWithFormat:@"%@",delegate.offerPrice];
            offerObject.status = [NSNumber numberWithInt:1];
            NSEntityDescription *offerTimeEntity = [NSEntityDescription entityForName:@"OfferTime" inManagedObjectContext:context];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"offerid='%@'",offerObject.offerid]]];
            [fetchRequest setEntity:offerTimeEntity];
            [fetchRequest setSortDescriptors:nil];
            NSArray *offerTimeObjects = [context executeFetchRequest:fetchRequest error:&error];
            for (OfferTime *offerTimeInfo in offerTimeObjects) {
                [context deleteObject:offerTimeInfo];
            }
            NSArray *times = (NSArray *)[offerTimeStr JSONValue];
            for (int i = 0; i < times.count; i++) {
                OfferTime *offerTimeObject = [NSEntityDescription insertNewObjectForEntityForName:@"OfferTime" inManagedObjectContext:context];
                offerTimeObject.offerid = offerObject.offerid;
                offerTimeObject.weekday = [[times objectAtIndex:i] objectAtIndex:0];
                offerTimeObject.time = [[times objectAtIndex:i] objectAtIndex:1];
                offerTimeObject.offerInfo = offerObject;
            }
            NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid!='%@' and propertyid='%@'",delegate.userid, delegate.pid]]];
            [fetchRequest setEntity:propEntity];
            [fetchRequest setSortDescriptors:nil];
            NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
            if (propObjects.count > 0) {
                offerObject.propertyInfo = (Property *)[propObjects objectAtIndex:0];
            }
            NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"user_id='%@'",delegate.userid]]];
            [fetchRequest setEntity:userEntity];
            [fetchRequest setSortDescriptors:nil];
            BOOL isFilledUser = FALSE;
            NSArray *userObjects = [context executeFetchRequest:fetchRequest error:&error];
            if (userObjects.count > 0) {
                Users *uInfo = (Users *)[userObjects objectAtIndex:0];
                if (uInfo.birthday != nil || (uInfo.nationality != nil && ![uInfo.nationality isEqualToString:@""]) || (uInfo.race != nil && ![uInfo.race isEqualToString:@""]) || (uInfo.occupation != nil && ![uInfo.occupation isEqualToString:@""]) || (uInfo.location != nil && ![uInfo.location isEqualToString:@""]) || (uInfo.email != nil && [uInfo.email isEqualToString:@""]) || uInfo.privacy != nil) {
                    isFilledUser = TRUE;
                }
                offerObject.userInfo = (Users *)[userObjects objectAtIndex:0];
            }
            if (isFilledUser) {
                self.lblDone.text = @"Give it up to 3 days for landlord to review your offer. We will notify you once landlord responded. In the mean time, please browse for other properties-keep your options open!";
                [self.btnSearchMore setHidden:NO];
                [self.btnSetMore setHidden:YES];
            }else {
                self.lblDone.text = @"Give it up to 3 days for landlord to review your offer. We will notify you once landlord responded. In the meantime, we suggest you to include some info about yourself-landlord wants to know who you are!";
                [self.btnSearchMore setHidden:YES];
                [self.btnSetMore setHidden:NO];
            }
            [delegate saveContext];
            [self.btnBack setHidden:YES];
            [self.btnNext setHidden:YES];
            
            NSDictionary *params;
            if (self.prevViewController != nil && [self.prevViewController isKindOfClass:[OfferListViewController class]]) {
                params = @{@"task":@"offersave",
                           @"userid":delegate.userid,
                           @"id":delegate.offerid,
                           @"term":delegate.term,
                           @"price":delegate.offerPrice,
                           @"propertyid":delegate.pid,
                           @"status":@"1",
                           @"prefertimestart":prefertimestart,
                           @"time":offerTimeStr};
            }else {
                params = @{@"task":@"offersave",
                           @"userid":delegate.userid,
                           @"term":delegate.term,
                           @"price":delegate.offerPrice,
                           @"propertyid":delegate.pid,
                           @"status":@"1",
                           @"prefertimestart":prefertimestart,
                           @"time":offerTimeStr};
            }
            AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:actionUrl]];
            
            [client
             postPath:@"/json/index.php"
             parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if (operation.response.statusCode != 200) {
                     NSLog(@"Failed");
                 } else {
                     NSDictionary *dataDict = (NSDictionary*)[operation.responseString JSONValue];
                     if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]] && [[dataDict objectForKey:@"id"] intValue] > 0) {
                         offerObject.offerid = [NSNumber numberWithInt:[[dataDict objectForKey:@"id"] intValue]];
                         [delegate saveContext];
                     }
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 if ([self isViewLoaded]) {
                     NSLog(@"Failed");
                 }
             }];
            
            if (self.prevViewController != nil && [self.prevViewController isKindOfClass:[OfferListViewController class]]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3f];
                [UIView setAnimationDelegate:self];
                CGRect bounds = [[UIScreen mainScreen] bounds];
                mainView1.transform = CGAffineTransformMakeTranslation( -bounds.size.width * 2, 0 );
                mainView2.transform = CGAffineTransformMakeTranslation( -bounds.size.width * 2, 0 );
                mainView3.transform = CGAffineTransformMakeTranslation( -bounds.size.width * 2, 0 );
                [UIView commitAnimations];
            }

        }
    }
}

- (void)checkTimeButton : (UIButton *)sender
{
    if ([sender.backgroundColor isEqual:[UIColor whiteColor]]) {
        [sender setBackgroundColor:selColor];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (void) doneSaveOfferInfo :(NSString*)data
{
    
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        if ([[dataDict objectForKey:@"status"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Make An Offer" message:@"You couldn't offer this property because this is your own property." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }else if ([[dataDict objectForKey:@"status"] isEqualToNumber:[NSNumber numberWithInt:2]]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Make An Offer" message:@"You've already offer this property." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        int point = [delegate.quality intValue];
        if (point == 13) {
            [self.btnSearchMore setHidden:NO];
        }else {
            [self.btnSearchMore setHidden:YES];
        }
        [self.btnBack setHidden:YES];
        [self.btnNext setHidden:YES];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        CGRect bounds = [[UIScreen mainScreen] bounds];
        mainView1.transform = CGAffineTransformMakeTranslation( -bounds.size.width * 2, 0 );
        mainView2.transform = CGAffineTransformMakeTranslation( -bounds.size.width * 2, 0 );
        mainView3.transform = CGAffineTransformMakeTranslation( -bounds.size.width * 2, 0 );
        [UIView commitAnimations];
        
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Make An Offer" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
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
    /*if ([FBDialogs canPresentShareDialogWithParams:params]) {
        [FBDialogs presentShareDialogWithLink:params.link
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
         }];
    } else {
        // Present the feed dialog
        // Put together the dialog parameters
        NSMutableDictionary *params1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
         params.name, @"name",
         params.caption, @"caption",
         SHARE_MESSAGE, @"description",
         params.link.path, @"link",
         params.picture.path, @"picture",
         nil];
         
         // Show the feed dialog
         [FBWebDialogs presentFeedDialogModallyWithSession:nil
         parameters:params1
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
         }];
    }*/
    
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

- (IBAction)onQuickerBtnPressed:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    int point = [delegate.quality intValue];
    if (point < 13) {
        ProfileEditViewController *profileEditViewController = [[ProfileEditViewController alloc] init];
        profileEditViewController.prevViewController = self;
        [self.navigationController pushViewController:profileEditViewController animated:YES];
    }else {
        MyNavigationController *navController = (MyNavigationController *)self.navigationController;
        int i = 0;
        for (i = 0; i < navController.viewControllers.count; i++) {
            if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[HomeViewController class]]) {
                [self.navigationController popToViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
                break;
            }
        }
        if (i == navController.viewControllers.count) {
            HomeViewController *homeViewController = [[HomeViewController alloc] init];
            homeViewController.prevViewController = self;
            [self.navigationController pushViewController:homeViewController animated:YES];
        }
    }
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Make An Offer" message:@"We are experiencing high load, and will rectify this as soon as possible. We are aware of this issue." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
