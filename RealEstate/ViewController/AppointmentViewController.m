//
//  AppointmentViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "AppointmentViewController.h"
#import "AppointmentEditViewController.h"
#import "AppointmentCell.h"
#import "MenuViewController.h"
#import "ProfileEditViewController.h"
#import "MyNavigationController.h"

#import "MBProgressHUD.h"

#import "NSString+SBJSON.h"

#import "AppDelegate.h"
#import "Constant.h"

#import "AFNetworking.h"
#import <GoogleMaps/GoogleMaps.h>

@interface AppointmentViewController ()

@end

@implementation AppointmentViewController {
    GMSMapView *mapView_;
}

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
    [self.btnAll setBackgroundColor:[UIColor colorWithRed:156 / 255.0 green:204 / 255.0 blue:23 / 255.0 alpha:1.0]];
    [self.btnToday setBackgroundColor:[UIColor clearColor]];
    [self.btnTomorrow setBackgroundColor:[UIColor clearColor]];
    self.btnAll.layer.borderWidth = 0;
    self.btnToday.layer.borderWidth = 1;
    self.btnToday.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnTomorrow.layer.borderWidth = 1;
    self.btnTomorrow.layer.borderColor = [[UIColor whiteColor] CGColor];
    if ([self.prevViewController isKindOfClass:[MenuViewController class]]) {
        MenuViewController *menuViewController = (MenuViewController *)self.prevViewController;
        menuViewController.prevViewController = self;
    }
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [self.subView setFrame:CGRectMake(0, 44, bounds.size.width, 40)];
        [self.tblList setFrame:CGRectMake(0,84,bounds.size.width,bounds.size.height - 104)];
        [self.mapView setFrame:CGRectMake(0,44,bounds.size.width,bounds.size.height - 64)];
        self.noLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 84, bounds.size.width, bounds.size.height - 104)];
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [self.subView setFrame:CGRectMake(0, 64, bounds.size.width, 43)];
        [self.tblList setFrame:CGRectMake(0,104,bounds.size.width,bounds.size.height - 104)];
        [self.mapView setFrame:CGRectMake(0,64,bounds.size.width,bounds.size.height - 64)];
        self.noLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 104, bounds.size.width, bounds.size.height - 104)];
    }
    self.noLabel.backgroundColor = [UIColor whiteColor];
    self.noLabel.textAlignment = NSTextAlignmentCenter;
    self.noLabel.font = [UIFont systemFontOfSize:20.0f];
    self.noLabel.text = @"No Appointments";
    [self.noLabel setHidden:YES];
    [self.view addSubview:self.noLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    [self.mapView setHidden:YES];
}

-(void)dismissView {
    for (int i = 0; i < self.tblList.numberOfSections; i++) {
        for (int j = 0; j < [self.tblList numberOfRowsInSection:i]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NSArray *subViews = [self.tblList cellForRowAtIndexPath:indexPath].contentView.subviews;
            UIView *viewInfo = (UIView *)[subViews objectAtIndex:7];
            [viewInfo setHidden:YES];
        }
    }
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
        if (![self.btnAll.backgroundColor isEqual:[UIColor clearColor]]) {
            [self getListInfo:1];
        }else if (![self.btnToday.backgroundColor isEqual:[UIColor clearColor]]) {
            [self getListInfo:2];
        }else if (![self.btnTomorrow.backgroundColor isEqual:[UIColor clearColor]]) {
            [self getListInfo:3];
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
    if (self.mapView != nil && ![self.mapView isHidden]) {
        [mapView_ removeFromSuperview];
        mapView_ = nil;
        [self.mapView setHidden:YES];
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    menuViewController.prevViewController = self;
    MyNavigationController *n = [[MyNavigationController alloc] initWithRootViewController:menuViewController];
    n.navigationBarHidden = YES;
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionLeft withOffset:0 animated:TRUE];
}

- (IBAction)onAllBtnPressed:(id)sender {
    [self.btnAll setBackgroundColor:[UIColor colorWithRed:156 / 255.0 green:204 / 255.0 blue:23 / 255.0 alpha:1.0]];
    [self.btnToday setBackgroundColor:[UIColor clearColor]];
    [self.btnTomorrow setBackgroundColor:[UIColor clearColor]];
    self.btnAll.layer.borderWidth = 0;
    self.btnToday.layer.borderWidth = 1;
    self.btnToday.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnTomorrow.layer.borderWidth = 1;
    self.btnTomorrow.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self getListInfo:1];
}

- (IBAction)onTodayBtnPressed:(id)sender {
    
    [self.btnToday setBackgroundColor:[UIColor colorWithRed:156 / 255.0 green:204 / 255.0 blue:23 / 255.0 alpha:1.0]];
    [self.btnAll setBackgroundColor:[UIColor clearColor]];
    [self.btnTomorrow setBackgroundColor:[UIColor clearColor]];
    self.btnToday.layer.borderWidth = 0;
    self.btnAll.layer.borderWidth = 1;
    self.btnAll.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnTomorrow.layer.borderWidth = 1;
    self.btnTomorrow.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self getListInfo:2];
}

- (IBAction)onTomorrowBtnPressed:(id)sender {
    [self.btnTomorrow setBackgroundColor:[UIColor colorWithRed:156 / 255.0 green:204 / 255.0 blue:23 / 255.0 alpha:1.0]];
    [self.btnToday setBackgroundColor:[UIColor clearColor]];
    [self.btnAll setBackgroundColor:[UIColor clearColor]];
    self.btnTomorrow.layer.borderWidth = 0;
    self.btnToday.layer.borderWidth = 1;
    self.btnToday.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnAll.layer.borderWidth = 1;
    self.btnAll.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self getListInfo:3];
}

- (void) getListInfo:(int)option
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *reqString = [NSString stringWithFormat:@"%@?task=appointmentlist&userid=%@&option=%d",actionUrl,delegate.userid,option];
        NSLog(@"%@",reqString);
        reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:reqString];
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        [self performSelectorOnMainThread:@selector(doneGetListInfo:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.tblList reloadData];
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
        NSArray *tempAppList = (NSArray *)[dataDict objectForKey:@"result"];
        appList = [[NSMutableArray alloc] init];
        for (int i = 0; i < tempAppList.count; i++) {
            NSDate *newDate = [dateformatter dateFromString:[[tempAppList objectAtIndex:i] objectForKey:@"prefertimestart"]];
            if (newDate == nil) {
                continue;
            }
            /*long offsetDay = [[[tempAppList objectAtIndex:i] objectForKey:@"weekday"] intValue];
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
            [appList addObject:[tempAppList objectAtIndex:i]];
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Appointment" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 0.01f)];
    if (appList != nil) {
        if ([appList count] == 0) {
            [self.noLabel setHidden:NO];
            return 0;
        }else {
            [self.noLabel setHidden:YES];
            return [appList count];
        }
    }else {
        return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    long weekday = [[[appList objectAtIndex:section] objectForKey:@"weekday"] intValue] + 1;
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *now = [dateformatter dateFromString:[[appList objectAtIndex:section] objectForKey:@"prefertimestart"]];
    long offsetDay = [[[appList objectAtIndex:section] objectForKey:@"weekday"] intValue];
    NSDate *newDate = [ now dateByAddingTimeInterval:offsetDay * 24 * 60 * 60 ] ;
    NSDateComponents *newDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:newDate];
    NSArray *months = [[NSArray alloc] initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December",nil];
    NSArray *weekdays = [[NSArray alloc] initWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",nil];
    NSString *result = [NSString stringWithFormat:@"%ld %@ %@", (long)[newDateComponents day], [months objectAtIndex:[newDateComponents month] - 1],[weekdays objectAtIndex:weekday - 1]];
    return result;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    long weekday = [[[appList objectAtIndex:section] objectForKey:@"weekday"] intValue] + 1;
    //NSDate *now = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *now = [dateformatter dateFromString:[[appList objectAtIndex:section] objectForKey:@"prefertimestart"]];
    //NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:now];
    //long offsetDay = weekday - (([dateComponents weekday] + 5) % 7) - 1;
    long offsetDay = [[[appList objectAtIndex:section] objectForKey:@"weekday"] intValue];
    NSDate *newDate = [ now dateByAddingTimeInterval:offsetDay * 24 * 60 * 60 ] ;
    NSDateComponents *newDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:newDate];
    NSArray *months = [[NSArray alloc] initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December",nil];
    NSArray *weekdays = [[NSArray alloc] initWithObjects:@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday",nil];
    //NSString *result = [NSString stringWithFormat:@"%ld %@ %@", (long)[newDateComponents day], [months objectAtIndex:[newDateComponents month] - 1],[weekdays objectAtIndex:weekday - 1]];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 120, 18)];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setFont:[UIFont boldSystemFontOfSize:18]];
    [label1 setTextColor:[UIColor grayColor]];
    [label1 setText:[NSString stringWithFormat:@"%ld %@", (long)[newDateComponents day], [months objectAtIndex:[newDateComponents month] - 1]]];
    [view addSubview:label1];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(140, 20, 100, 18)];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setFont:[UIFont systemFontOfSize:14]];
    [label2 setTextColor:[UIColor lightGrayColor]];
    [label2 setText:[NSString stringWithFormat:@"%@",[weekdays objectAtIndex:weekday - 1]]];
    [view addSubview:label2];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[appList objectAtIndex:section] objectForKey:@"data"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107.0f;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"AppointmentCell" owner:self options:nil];
    AppointmentCell *cell = [nibArray objectAtIndex:0];
    CALayer *imageLayer = cell.imgPhoto.layer;
    [imageLayer setCornerRadius:18];
    [imageLayer setBorderColor:[[UIColor clearColor] CGColor]];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    NSDictionary *dic = [[[appList objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
    if (![[dic objectForKey:@"photo"] isEqualToString:@""]) {
        [cell.imgPhoto setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",profilePhotoUrl, [dic objectForKey:@"photo"]]]];
    }else {
        cell.imgPhoto.image = [UIImage imageNamed:@"default_user.png"];
    }
    cell.appointid = [[dic objectForKey:@"offerid"] intValue];
    cell.lblUsername.text = [dic objectForKey:@"username"];
    cell.lblAppTime.text = [NSString stringWithFormat:@"%@ - %@:00", [dic objectForKey:@"propertyname"],[dic objectForKey:@"time"]];
    cell.lblContact.text = [NSString stringWithFormat:@"+%@",[dic objectForKey:@"phone"]];
    NSString *address = @"";
    if ([dic objectForKey:@"unit"] != nil && ![[dic objectForKey:@"unit"] isEqualToString:@""]) {
        address = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unit"]];
    }
    if ([dic objectForKey:@"address1"] != nil && ![[dic objectForKey:@"address1"] isEqualToString:@""]) {
        address = [NSString stringWithFormat:@"%@, %@",address, [dic objectForKey:@"address1"]];
    }
    if ([dic objectForKey:@"address2"] != nil && ![[dic objectForKey:@"address2"] isEqualToString:@""]) {
        address = [NSString stringWithFormat:@"%@, %@",address,[dic objectForKey:@"address2"]];
    }
    if ([dic objectForKey:@"zipcode"] != nil && ![[dic objectForKey:@"zipcode"] isEqualToString:@""]) {
        address = [NSString stringWithFormat:@"%@, %@",address,[dic objectForKey:@"zipcode"]];
    }
    UITapGestureRecognizer *callTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callTapGestureCaptured:)];
    cell.contactNumber = [dic objectForKey:@"phone"];
    cell.contactAddress = [NSString stringWithFormat:@"%@ %@", [dic objectForKey:@"address1"],[dic objectForKey:@"zipcode"]];
    [cell.lblContact addGestureRecognizer:callTap];
    UITapGestureRecognizer *locTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locTapGestureCaptured:)];
    cell.contactLoc = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[dic objectForKey:@"latitude"], @"latitude", [dic objectForKey:@"longitude"], @"longitude", nil];
    [cell.lblAddress addGestureRecognizer:locTap];
    
    cell.lblAddress.text = address;
    cell.btnReschedule.tag = [[dic objectForKey:@"offerid"] intValue];
    [cell.btnReschedule addTarget:self action:@selector(onBtnReschedulePressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnInfo addTarget:self action:@selector(onBtnInfoPressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)callTapGestureCaptured:(UIGestureRecognizer *)gesture {
    NSString *phoneNumber = @"";
    for (int i = 0; i < [self.tblList numberOfSections]; i++) {
        for (int j = 0; j < [self.tblList numberOfRowsInSection:i]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            AppointmentCell *cell = (AppointmentCell *)[self.tblList cellForRowAtIndexPath:indexPath];
            UIView *contactView = (UIView *)[cell.contentView.subviews objectAtIndex:7];
            UILabel *contactLabel = [contactView.subviews objectAtIndex:0];
            if ([contactLabel isEqual:gesture.view]) {
                phoneNumber = [NSString stringWithFormat:@"tel:%@",[cell contactNumber]];
                break;
            }
        }
    }
    if (phoneNumber != nil && ![phoneNumber isEqualToString:@""]) {
        NSURL *url= [NSURL URLWithString:phoneNumber];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.1) {
            UIWebView *webview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
            [webview loadRequest:[NSURLRequest requestWithURL:url]];
            webview.hidden = YES;
            [self.view addSubview:webview];
        } else {
            [[UIApplication sharedApplication] openURL: url];
        }
    }
}

-(void)locTapGestureCaptured:(UIGestureRecognizer *)gesture {
    float latitude = 0, longitude = 0;
    NSString *address = @"";
    for (int i = 0; i < [self.tblList numberOfSections]; i++) {
        for (int j = 0; j < [self.tblList numberOfRowsInSection:i]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            AppointmentCell *cell = (AppointmentCell *)[self.tblList cellForRowAtIndexPath:indexPath];
            UIView *contactView = (UIView *)[cell.contentView.subviews objectAtIndex:7];
            UILabel *addressLabel = [contactView.subviews objectAtIndex:1];
            if ([addressLabel isEqual:gesture.view]) {
                latitude = [[[cell contactLoc] objectForKey:@"latitude"] floatValue];
                longitude = [[[cell contactLoc] objectForKey:@"longitude"] floatValue];
                address = [cell contactAddress];
                break;
            }
        }
    }
    /*if (locStr != nil && ![locStr isEqualToString:@""]) {
        NSURL *url= [NSURL URLWithString:locStr];
        [mapView loadRequest:[NSURLRequest requestWithURL:url]];
        //[self.view bringSubviewToFront:mapView];
        mapView.hidden = NO;
    }*/
    if (self.mapView.isHidden) {
        if (mapView_ == nil) {
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:16 bearing:0 viewingAngle:180];
            mapView_ = [GMSMapView mapWithFrame:self.mapView.bounds camera:camera];
            mapView_.myLocationEnabled = YES;
            self.mapView.layer.borderColor = [[UIColor grayColor] CGColor];
            self.mapView.layer.borderWidth = 1.0f;
            [self.mapView addSubview: mapView_];
        }
        // Creates a marker in the center of the map.
        [mapView_ clear];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(latitude, longitude);
        marker.title = [NSString stringWithFormat:@"This is position : %@",address];
        marker.map = mapView_;
        [self.mapView setHidden:NO];
    }else {
        [self.mapView setHidden:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Appointment" message:@"Do you really want to remove this appointment?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alertView.tag = 1;
        delIndexPath = indexPath;
        [alertView show];
        return;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            NSDictionary *dic = [[[appList objectAtIndex:delIndexPath.section] objectForKey:@"data"] objectAtIndex:delIndexPath.row];
            [[[appList objectAtIndex:delIndexPath.section] objectForKey:@"data"] removeObject:dic];
            NSArray *data = (NSArray *)[[appList objectAtIndex:delIndexPath.section] objectForKey:@"data"];
            if (data.count == 0) {
                [appList removeObject:[appList objectAtIndex:delIndexPath.section]];
            }
            [self.tblList reloadData];
            NSDictionary *params = @{@"task":@"removeappt",
                                     @"offerid":[NSString stringWithFormat:@"%d",[[dic objectForKey:@"offerid"] intValue]]
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
        }
    }
}
- (void)onBtnReschedulePressed:(id)sender
{
    UIButton *rescheduleBtn = (UIButton *)sender;
    int timeCount = 0;
    NSLog(@"%@",appList);
    for (int i = 0; i < appList.count; i++) {
        NSArray *dataArray = [[appList objectAtIndex:i] objectForKey:@"data"];
        for (int j = 0; j < dataArray.count; j++) {
            NSDictionary *dic = [dataArray objectAtIndex:j];
            if ([[dic objectForKey:@"offerid"] intValue] == rescheduleBtn.tag ) {
                timeCount += [[dic objectForKey:@"timecount"] intValue];
            }
        }
    }
    if (timeCount <= 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Appointment" message:@"Only one preferred time available from landlord. You can not reschedule." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    NSArray *subViews = rescheduleBtn.superview.subviews;
    UILabel *labelName = (UILabel *)[subViews objectAtIndex:2];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.offerid = [NSString stringWithFormat:@"%ld",(long)rescheduleBtn.tag];
    AppointmentEditViewController *appointmentEditViewController = [[AppointmentEditViewController alloc] init];
    appointmentEditViewController.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(58,31,204,21)];
    [[appointmentEditViewController.view.subviews objectAtIndex:0] addSubview:appointmentEditViewController.lblTitle];
    appointmentEditViewController.lblTitle.text = [NSString stringWithFormat:@"%@'s PREFERED TIME",labelName.text.uppercaseString];
    appointmentEditViewController.prevViewController = self;
    [self.navigationController pushViewController:appointmentEditViewController animated:YES];
}

- (void)onBtnInfoPressed:(id)sender
{
    for (int i = 0; i < self.tblList.numberOfSections; i++) {
        for (int j = 0; j < [self.tblList numberOfRowsInSection:i]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            NSArray *subViews = [self.tblList cellForRowAtIndexPath:indexPath].contentView.subviews;
            UIView *viewInfo = (UIView *)[subViews objectAtIndex:7];
            [viewInfo setHidden:YES];
        }
    }
    UIButton *infoBtn = (UIButton *)sender;
    NSArray *subViews = infoBtn.superview.subviews;
    UIView *viewInfo = (UIView *)[subViews objectAtIndex:7];
    if ([viewInfo isHidden]) {
        [viewInfo setHidden:NO];
    }else {
        [viewInfo setHidden:YES];
    }
}

@end
