//
//  NotificationViewController.m
//  RealEstate
//
//  Created by Sol.S on 5/24/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "NotificationViewController.h"

#import "AppDelegate.h"
#import "Notification.h"
#import "MenuViewController.h"
#import "MyNavigationController.h"
#import "OfferListViewController.h"
#import "AskOwnerViewController.h"
#import "AppointmentEditViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

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
    selectedItem = 0;
    self.btnAll.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnAll.layer.borderWidth = 0.0f;
    self.btnAll.backgroundColor = [UIColor colorWithRed:156 / 255.0 green:204 / 255.0 blue:23 / 255.0 alpha:1.0f];
    
    self.btnToday.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnToday.layer.borderWidth = 1.0f;
    self.btnToday.backgroundColor = [UIColor clearColor];
    
    self.btnPast.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnPast.layer.borderWidth = 1.0f;
    self.btnPast.backgroundColor = [UIColor clearColor];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [self.subView setFrame:CGRectMake(0, 44, bounds.size.width, 40)];
        [self.tblView setFrame:CGRectMake(0,0,bounds.size.width,bounds.size.height)];
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.navView.frame.size.height + self.subView.frame.size.height, 0, 0, 0);
        self.tblView.contentInset = contentInsets;
        self.tblView.scrollIndicatorInsets = contentInsets;
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [self.subView setFrame:CGRectMake(0, 64, bounds.size.width, 40)];
        [self.tblView setFrame:CGRectMake(0,0,bounds.size.width,bounds.size.height)];
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.navView.frame.size.height + self.subView.frame.size.height, 0, 0, 0);
        self.tblView.contentInset = contentInsets;
        self.tblView.scrollIndicatorInsets = contentInsets;
    }
    [self.view bringSubviewToFront:self.subView];
    [self.view bringSubviewToFront:self.navView];
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tblView addSubview:refresh];
    [self getNotificationList];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
    [self getNotificationList];
}

- (void)getNotificationList
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Get Offer Data
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datecreated" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
    
    NSEntityDescription *notifyEntity = [NSEntityDescription entityForName:@"Notification" inManagedObjectContext:context];
    [fetchRequest setEntity:notifyEntity];
    NSArray *notifyObjects = [context executeFetchRequest:fetchRequest error:&error];
    notificationList = [[NSMutableArray alloc] init];
    for (Notification *notificationInfo in notifyObjects) {
        NSMutableDictionary *notificationData = [[NSMutableDictionary alloc] init];
        [notificationData setObject:notificationInfo.type forKey:@"type"];
        [notificationData setObject:notificationInfo.notifyString forKey:@"notifyString"];
        [notificationData setObject:notificationInfo.datecreated forKey:@"datecreated"];
        [notificationList addObject:notificationData];
    }
    [self filterList];
}

-(void)filterList
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    curNotificationList = [[NSMutableArray alloc] init];
    if (selectedItem == 0) {
        for (int i = 0; i < notificationList.count; i++) {
            [curNotificationList addObject:[notificationList objectAtIndex:i]];
        }
    }else if (selectedItem == 1) {
        NSDate *curDate = [NSDate date];
        for (int i = 0; i < notificationList.count; i++) {
            NSDate *dateCreated = (NSDate *)[[notificationList objectAtIndex:i] objectForKey:@"datecreated"];
            if ([delegate getYear:dateCreated] == [delegate getYear:curDate] && [delegate getMonth:dateCreated] == [delegate getMonth:curDate] && [delegate getDay:dateCreated] == [delegate getDay:curDate]) {
                [curNotificationList addObject:[notificationList objectAtIndex:i]];
            }
        }
    }else if (selectedItem == 2) {
        NSDate *curDate = [NSDate date];
        for (int i = 0; i < notificationList.count; i++) {
            NSDate *dateCreated = (NSDate *)[[notificationList objectAtIndex:i] objectForKey:@"datecreated"];
            if ([delegate getYear:dateCreated] == [delegate getYear:curDate] && [delegate getMonth:dateCreated] == [delegate getMonth:curDate] && [delegate getDay:dateCreated] == [delegate getDay:curDate]) {
                continue;
            }
            [curNotificationList addObject:[notificationList objectAtIndex:i]];
        }
    }
    [self.tblView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (curNotificationList == nil) {
        return 0;
    }else if (curNotificationList.count == 0) {
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        return 1;
    }else {
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        return curNotificationList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (curNotificationList.count == 0) {
        return 60.0f;
    }
    CGRect frame = CGRectMake(0, 0, 0, 0);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        frame.size = [[[curNotificationList objectAtIndex:indexPath.row] objectForKey:@"notifyString"] sizeWithFont:[UIFont systemFontOfSize:12.0f]
                                          constrainedToSize:(CGSize){280, CGFLOAT_MAX}];
    }else {
        frame.size = [[[curNotificationList objectAtIndex:indexPath.row] objectForKey:@"notifyString"] boundingRectWithSize:CGSizeMake(280, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil].size;
    }
    return frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (curNotificationList.count == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor grayColor];
        if (selectedItem == 0) {
            cell.textLabel.text = @"There are no notifications you received.";
        }else if (selectedItem == 1) {
            cell.textLabel.text = @"There are no notifications you received today.";
        }else if (selectedItem == 2) {
            cell.textLabel.text = @"There are no notifications you received before.";
        }
        cell.textLabel.numberOfLines = 2;
        return cell;
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.numberOfLines = 0;
        [cell.textLabel setFont:[UIFont systemFontOfSize:12.0f]];
        NSString *notifyType = [[curNotificationList objectAtIndex:indexPath.row] objectForKey:@"type"];
        if ([notifyType isEqualToString:@"NewOffer"]) {
            cell.tag = 1;
        }else if ([notifyType isEqualToString:@"Chat"]) {
            cell.tag = 2;
        }else if ([notifyType isEqualToString:@"Appoint"]) {
            cell.tag = 3;
        }
        cell.textLabel.text = [[curNotificationList objectAtIndex:indexPath.row] objectForKey:@"notifyString"];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyNavigationController *navController = (MyNavigationController *)self.navigationController;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.tag == 1) {
        OfferListViewController *offerListViewController = nil;
        for (int i = 0; i < navController.viewControllers.count; i++) {
            if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[OfferListViewController class]]) {
                offerListViewController = (OfferListViewController*)[navController.viewControllers objectAtIndex:i];
                [navController popToViewController:offerListViewController animated:YES];
                break;
            }
        }
        if (offerListViewController == nil) {
            offerListViewController = [[OfferListViewController alloc] init];
            [navController pushViewController:offerListViewController animated:YES];
        }
        [self.revealSideViewController popViewControllerAnimated:YES];
    }else if (cell.tag == 2) {
        AskOwnerViewController *askOwnerViewController = nil;
        for (int i = 0; i < navController.viewControllers.count; i++) {
            if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[AskOwnerViewController class]]) {
                askOwnerViewController = (AskOwnerViewController*)[navController.viewControllers objectAtIndex:i];
                [navController popToViewController:askOwnerViewController animated:YES];
                break;
            }
        }
        if (askOwnerViewController == nil) {
            askOwnerViewController = [[AskOwnerViewController alloc] init];
            [navController pushViewController:askOwnerViewController animated:YES];
        }
        [self.revealSideViewController popViewControllerAnimated:YES];
    }else if (cell.tag == 3) {
        AppointmentEditViewController *appointmentEditViewController = nil;
        for (int i = 0; i < navController.viewControllers.count; i++) {
            if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[AppointmentEditViewController class]]) {
                appointmentEditViewController = (AppointmentEditViewController*)[navController.viewControllers objectAtIndex:i];
                [navController popToViewController:appointmentEditViewController animated:YES];
                break;
            }
        }
        if (appointmentEditViewController == nil) {
            appointmentEditViewController = [[AppointmentEditViewController alloc] init];
            [navController pushViewController:appointmentEditViewController animated:YES];
        }
        [self.revealSideViewController popViewControllerAnimated:YES];
    }
}

- (IBAction)onBackBtnPressed:(id)sender {
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    menuViewController.prevViewController = self;
    MyNavigationController *n = [[MyNavigationController alloc] initWithRootViewController:menuViewController];
    n.navigationBarHidden = YES;
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionLeft withOffset:0 animated:TRUE];
}

- (IBAction)onTypeBtnPressed:(id)sender {
    if ([sender isEqual:self.btnAll]) {
        selectedItem = 0;
        self.btnAll.layer.borderWidth = 0.0f;
        self.btnAll.backgroundColor = [UIColor colorWithRed:156 / 255.0 green:204 / 255.0 blue:23 / 255.0 alpha:1.0f];
        self.btnToday.layer.borderWidth = 1.0f;
        self.btnToday.backgroundColor = [UIColor clearColor];
        self.btnPast.layer.borderWidth = 1.0f;
        self.btnPast.backgroundColor = [UIColor clearColor];
    }else if ([sender isEqual:self.btnToday]) {
        selectedItem = 1;
        self.btnPast.layer.borderWidth = 1.0f;
        self.btnPast.backgroundColor = [UIColor clearColor];
        self.btnAll.layer.borderWidth = 1.0f;
        self.btnAll.backgroundColor = [UIColor clearColor];
        self.btnToday.layer.borderWidth = 0.0f;
        self.btnToday.backgroundColor = [UIColor colorWithRed:156 / 255.0 green:204 / 255.0 blue:23 / 255.0 alpha:1.0f];
    }else if ([sender isEqual:self.btnPast]) {
        selectedItem = 2;
        self.btnToday.layer.borderWidth = 1.0f;
        self.btnToday.backgroundColor = [UIColor clearColor];
        self.btnAll.layer.borderWidth = 1.0f;
        self.btnAll.backgroundColor = [UIColor clearColor];
        self.btnPast.layer.borderWidth = 0.0f;
        self.btnPast.backgroundColor = [UIColor colorWithRed:156 / 255.0 green:204 / 255.0 blue:23 / 255.0 alpha:1.0f];
    }
    [self filterList];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        [UIView setAnimationDelegate:self];
        if ([scrollView isEqual:self.tblView]) {
            CGRect rect = self.navView.frame;
            if (rect.origin.y < -(self.subView.frame.size.height + rect.size.height) / 2) {
                lastScrollOffset = scrollView.contentOffset.y;
                [self.tblView setContentOffset:CGPointMake(0,lastScrollOffset + (self.subView.frame.size.height + rect.size.height + rect.origin.y))];
                rect.origin.y = -(self.subView.frame.size.height + rect.size.height);
            }else {
                rect.origin.y = 0;
            }
            [self.navView setFrame:rect];
            rect = self.subView.frame;
            rect.origin.y = self.navView.frame.origin.y + self.navView.frame.size.height;
            [self.subView setFrame:rect];
        }
        [UIView commitAnimations];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        return;
    }
    if ([scrollView isEqual:self.tblView]) {
        CGRect rect = self.navView.frame;
        if (scrollView.contentInset.top + scrollView.contentOffset.y < 0 && rect.origin.y >= 0) {
            return;
        }
        rect.origin.y -= (scrollView.contentOffset.y - lastScrollOffset);
        if (rect.origin.y >= 0) {
            rect.origin.y = 0;
        }
        if (rect.origin.y < -(self.subView.frame.size.height + rect.size.height)) {
            rect.origin.y = -(self.subView.frame.size.height + rect.size.height);
        }
        [self.navView setFrame:rect];
        rect = self.subView.frame;
        rect.origin.y = self.navView.frame.origin.y + self.navView.frame.size.height;
        [self.subView setFrame:rect];
        
        lastScrollOffset = scrollView.contentOffset.y;
    }
}

@end
