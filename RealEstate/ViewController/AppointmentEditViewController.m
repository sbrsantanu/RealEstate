
//
//  AppointmentEditViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "AppointmentEditViewController.h"
#import "AppDelegate.h"
#import "AppointmentEditCell.h"
#import "ProfileEditViewController.h"
#import "AppointmentSuccessViewController.h"
#import "AppointmentViewController.h"

#import "Constant.h"
#import "MBProgressHUD.h"
#import "NSString+SBJSON.h"

@interface AppointmentEditViewController ()

@end

@implementation AppointmentEditViewController

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
    if ([self.prevViewController isKindOfClass:[AppointmentViewController class]]) {
        [self.btnBack setHidden:NO];
    }else {
        [self.btnBack setHidden:YES];
    }
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [self.labelView setFrame:CGRectMake(0, 44, bounds.size.width, 43)];
        [tblList setFrame:CGRectMake(0,87,bounds.size.width,bounds.size.height - 107)];
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [self.labelView setFrame:CGRectMake(0, 64, bounds.size.width, 43)];
        [tblList setFrame:CGRectMake(0,107,bounds.size.width,bounds.size.height - 107)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getSchedule];
}

- (void)getSchedule
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *reqString = [NSString stringWithFormat:@"%@?task=offertime&offerid=%@", actionUrl,delegate.offerid];
        reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:reqString];
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        [self performSelectorOnMainThread:@selector(doneGetListInfo:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tblList reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void) doneGetListInfo :(NSString*)data
{
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    //AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        //NSDate *now = [NSDate date];
        NSArray *tempTimeList = (NSArray *)[dataDict objectForKey:@"result"];
        timeList = [[NSMutableArray alloc] init];
        for (int i = 0; i < tempTimeList.count; i++) {
            NSDate *newDate = [dateformatter dateFromString:[[tempTimeList objectAtIndex:i] objectForKey:@"prefertimestart"]];
            if (newDate == nil) {
                continue;
            }
            /*long offsetDay = [[[tempTimeList objectAtIndex:i] objectForKey:@"weekday"] intValue];
            newDate = [ newDate dateByAddingTimeInterval:offsetDay * 24 * 60 * 60 ] ;
            if ([delegate getYear:now] > [delegate getYear:newDate]) {
                continue;
            }
            if ([delegate getYear:now] == [delegate getYear:newDate] && [delegate getMonth:now] > [delegate getMonth:newDate]) {
                continue;
            }
            if ([delegate getYear:now] == [delegate getYear:newDate] && [delegate getMonth:now] == [delegate getMonth:newDate] && [delegate getDay:now] > [delegate getDay:newDate]) {
                continue;
            }*/
            [timeList addObject:[tempTimeList objectAtIndex:i]];
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Appointment" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onConfirmBtnPressed:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        NSInteger rows =  [tblList numberOfRowsInSection:0];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        NSArray *weekdays = [[NSArray alloc] initWithObjects:@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",nil];
        int weekday = -1;
        long time = -1;
        for (int row = 0; row < rows; row++) {
            NSDate *newDate = [dateformatter dateFromString:[[timeList objectAtIndex:row] objectForKey:@"prefertimestart"]];
            int startweekday = [delegate getWeekDay:newDate];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            UITableViewCell *cell = [tblList cellForRowAtIndexPath:indexPath];
            NSArray *subviews = [cell.contentView subviews];
            for (UIView *subView in subviews)
            {
                if ([subView isKindOfClass:[UILabel class]]) {
                    UILabel *lblWeekday = (UILabel *)[subviews objectAtIndex:1];
                    UILabel *labelTime = (UILabel *)subView;
                    if ([labelTime.textColor isEqual:[UIColor colorWithRed:74 / 255.0 green:181 / 255.0 blue:229 / 255.0 alpha:1.0]]) {
                        for (int i = 0; i < weekdays.count; i++) {
                            if ([lblWeekday.text isEqualToString:[weekdays objectAtIndex:i]]) {
                                weekday = i;
                                break;
                            }
                        }
                        time = labelTime.tag;
                        break;
                    }
                }
            }
            if (weekday >= 0) {
                if (startweekday <= weekday) {
                    weekday -= startweekday;
                }else {
                    weekday = (weekday + 7) - startweekday;
                }
            }
        }
        if (weekday >= 0) {
            //weekday = (weekday + 6) % 7 + 1;
        }else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Appointment" message:@"Please select one of the preferred time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *reqString = [NSString stringWithFormat:@"%@?task=offertimesave&offerid=%@&weekday=%d&time=%ld",actionUrl,delegate.offerid,weekday,time];
        reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:reqString];
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        [self performSelectorOnMainThread:@selector(doneSaveOfferTime:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void) doneSaveOfferTime :(NSString*)data
{    
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        if ([self.prevViewController isKindOfClass:[AppointmentViewController class]]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            AppointmentViewController *appointViewController = [[AppointmentViewController alloc] init];
            [self.navigationController pushViewController:appointViewController animated:YES];
        }
        /*AppointmentSuccessViewController *appointmentSuccessViewController = [[AppointmentSuccessViewController alloc] init];
        [self.navigationController pushViewController:appointmentSuccessViewController animated:YES];*/
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Appointment" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timeList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([[[timeList objectAtIndex:indexPath.row] objectForKey:@"times"] count] + 2) * 25.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"AppointmentEditCell" owner:self options:nil];
    AppointmentEditCell *cell = [nibArray objectAtIndex:0];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *timesArray = (NSMutableArray *)[[timeList objectAtIndex:indexPath.row] objectForKey:@"times"];
    NSArray *weekdays = [[NSArray alloc] initWithObjects:@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",nil];
    NSArray *months = [[NSArray alloc] initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December",nil];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *newDate = [dateformatter dateFromString:[[timeList objectAtIndex:indexPath.row] objectForKey:@"prefertimestart"]];
    long offsetDay = [[[timeList objectAtIndex:indexPath.row] objectForKey:@"weekday"] intValue];
    newDate = [newDate dateByAddingTimeInterval:offsetDay * 24 * 60 * 60] ;
    cell.lblDate.text = [NSString stringWithFormat:@"%ld %@",(long)[delegate getDay:newDate],[months objectAtIndex:[delegate getMonth:newDate] - 1]];
    cell.lblWeekday.text = [NSString stringWithFormat:@"%@",[weekdays objectAtIndex:[delegate getWeekDay:newDate]]];
    for (int i = 0; i < timesArray.count; i++) {
        UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(186,(i + 1) * 25, 110, 25)];
        int time = [[[timesArray objectAtIndex:i] objectForKey:@"time"] intValue];
        labelTime.text = [NSString stringWithFormat:@"%d:00 - %d:00",time, time + 1];
        if ([[[timesArray objectAtIndex:i] objectForKey:@"status"] intValue] == 1) {
            labelTime.textColor = [UIColor colorWithRed:74 / 255.0 green:181 / 255.0 blue:229 / 255.0 alpha:1.0];
        }else {
            labelTime.textColor = [UIColor grayColor];
        }
        labelTime.tag = time;
        labelTime.textAlignment = NSTextAlignmentCenter;
        labelTime.userInteractionEnabled = YES;
        UITapGestureRecognizer *labelTimeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTimePressed:)];
        [labelTime addGestureRecognizer:labelTimeTap];
        [cell.contentView addSubview:labelTime];
    }
    
    return cell;
}

- (void)onTimePressed:(UITapGestureRecognizer *)gesture {
    UILabel *curLabelTime = (UILabel *)gesture.view;
    UIView *parentView = [curLabelTime superview];
    UILabel *lblCurWeekday = (UILabel *)[parentView.subviews objectAtIndex:1];
    NSArray *weekdays = [[NSArray alloc] initWithObjects:@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",nil];
    int curWeekday = 0;
    for (int i = 0; i < weekdays.count; i++) {
        if ([lblCurWeekday.text isEqualToString:[weekdays objectAtIndex:i]]) {
            curWeekday = i;
            break;
        }
    }
    curLabelTime.textColor = [UIColor colorWithRed:74 / 255.0 green:181 / 255.0 blue:229 / 255.0 alpha:1.0];
    long curTime = curLabelTime.tag;
    NSInteger rows =  [tblList numberOfRowsInSection:0];
    for (int row = 0; row < rows; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell *cell = [tblList cellForRowAtIndexPath:indexPath];
        NSArray *subviews = [cell.contentView subviews];
        for (UIView *subView in subviews)
        {
            UILabel *lblWeekday = (UILabel *)[subviews objectAtIndex:1];
            if ([subView isKindOfClass:[UILabel class]]) {
                int weekday = 0;
                for (int i = 0; i < weekdays.count; i++) {
                    if ([lblWeekday.text isEqualToString:[weekdays objectAtIndex:i]]) {
                        weekday = i;
                        break;
                    }
                }
                UILabel *labelTime = (UILabel *)subView;
                if (labelTime.tag > 0 && (weekday != curWeekday || labelTime.tag != curTime) && [labelTime.textColor isEqual:[UIColor colorWithRed:74 / 255.0 green:181 / 255.0 blue:229 / 255.0 alpha:1.0]]) {
                    labelTime.textColor = [UIColor grayColor];
                }
            }
        }
    }
}

- (NSString *)getDateFromWeekDay:(long)weekday
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSWeekdayCalendarUnit fromDate:now];
    long offsetDay = weekday - [dateComponents weekday] + 1;
    NSDate *newDate = [ now dateByAddingTimeInterval:offsetDay * 24 * 60 * 60 ] ;
    NSDateComponents *newDateComponents = [calendar components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:newDate];
    NSArray *months = [[NSArray alloc] initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December",nil];
    NSString *result = [NSString stringWithFormat:@"%ld %@", (long)[newDateComponents day], [months objectAtIndex:[newDateComponents month] - 1]];
    return result;
}

@end
