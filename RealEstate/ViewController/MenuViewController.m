//
//  MenuViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "MenuViewController.h"

#import "HomeViewController.h"
#import "PostViewController.h"
#import "FavoritesViewController.h"
#import "ProfileViewController.h"
#import "OfferListViewController.h"
#import "ProfileEditViewController.h"
#import "AppointmentViewController.h"
#import "MyNavigationController.h"
#import "LoginViewController.h"
#import "VerifyViewController.h"
#import "CMTwoToneProgressBar.h"
#import "NotificationViewController.h"

#import "AppDelegate.h"

#import "MenuCell.h"
#import "Constant.h"
#import "SHKActivityIndicator.h"

#import "NSString+SBJSON.h"

#import "ProfileViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 61)];
        [self.tblMenu setFrame:CGRectMake(0,61,bounds.size.width,bounds.size.height - 81)];
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 81)];
        [self.tblMenu setFrame:CGRectMake(0,81,bounds.size.width,bounds.size.height - 81)];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	long cellRow = [indexPath row];
    
	MenuCell * cell = nil;
    
    NSString *cellid = @"MenuCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:cellid owner:self options:nil];
        for(id currentObject in topLevelObjects){
            if([currentObject isKindOfClass:[MenuCell class]]){
                cell = (MenuCell*)currentObject;
                break;
            }
        }
        //cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (indexPath.row == 0) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (delegate.userid == nil || [delegate.userid isEqualToString:@""] || [delegate.userid isEqualToString:@"0"]) {
            cell.lblTitle.text = @"JOIN / LOGIN";
        }else {
            cell.lblTitle.text = @"PROFILE";
            CMTwoToneProgressBar *progressView = [[CMTwoToneProgressBar alloc] initWithFrame:CGRectMake(180,28,100,10)];
            int point = [delegate.quality intValue];
            [progressView setProgress:point / 13.0f animated:NO];
            [progressView setProgressBarColor:[UIColor colorWithRed:0.0 green:170 / 255.0 blue:244 / 255.0 alpha:1.0]];
            [progressView setProgressBackgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:progressView];
        }
    }
    [cell setCellContentWith:cellRow];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long cellRow = indexPath.row;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.phone == nil || [delegate.phone isEqualToString:@""]) {
        if (cellRow == 0) {
            delegate.afterControllerName = @"ProfileEditViewController";
        }else if (cellRow == 1) {
            delegate.afterControllerName = @"PostViewController";
        }else if (cellRow == 2) {
            delegate.afterControllerName = @"OfferListViewController";
        }else if (cellRow == 3) {
            delegate.afterControllerName = @"AppointmentViewController";
        }else if (cellRow == 4) {
            delegate.afterControllerName = @"FavoritesViewController";
        }else if (cellRow == 5) {
            delegate.afterControllerName = @"NotificationViewController";
        }
        MyNavigationController *navController = (MyNavigationController *)self.prevViewController.navigationController;
        int i = 0;
        for (i = 0; i < navController.viewControllers.count; i++) {
            if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[LoginViewController class]]) {
                [self.prevViewController.navigationController popToViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
                break;
            }
        }
        if (i == navController.viewControllers.count) {
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            loginViewController.prevViewController = self;
            [self.prevViewController.navigationController pushViewController:loginViewController animated:YES];
        }
        [self.revealSideViewController popViewControllerAnimated:YES];
        return;
    }
    
    if (cellRow == 0) {
        MyNavigationController *navController = (MyNavigationController *)self.prevViewController.navigationController;
        int i = 0;
        for (i = 0; i < navController.viewControllers.count; i++) {
            if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[ProfileEditViewController class]]) {
                [self.prevViewController.navigationController popToViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
                ProfileEditViewController *profileEditViewController = (ProfileEditViewController *)[navController.viewControllers objectAtIndex:i];
                [profileEditViewController getProfileInfo];
                break;
            }
        }
        if (i == navController.viewControllers.count) {
            ProfileEditViewController *profileEditViewController = [[ProfileEditViewController alloc] init];
            profileEditViewController.prevViewController = self;
            [self.prevViewController.navigationController pushViewController:profileEditViewController animated:YES];
        }
        [self.revealSideViewController popViewControllerAnimated:YES];
    }else if (cellRow == 1) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        MyNavigationController *navController = (MyNavigationController *)self.prevViewController.navigationController;
        int i = 0;
        for (i = 0; i < navController.viewControllers.count; i++) {
            if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[PostViewController class]]) {
                [self.prevViewController.navigationController popToViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
                break;
            }
        }
        if (i == navController.viewControllers.count) {
            PostViewController *postViewController = [[PostViewController alloc] init];
            delegate.postViewController = postViewController;
            postViewController.prevViewController = self;
            [self.prevViewController.navigationController pushViewController:postViewController animated:YES];
        }
        [self.revealSideViewController popViewControllerAnimated:YES];
        
    }else if (cellRow == 2) {
        MyNavigationController *navController = (MyNavigationController *)self.prevViewController.navigationController;
        int i = 0;
        for (i = 0; i < navController.viewControllers.count; i++) {
            if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[OfferListViewController class]]) {
                [self.prevViewController.navigationController popToViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
                break;
            }
        }
        if (i == navController.viewControllers.count) {
            OfferListViewController *offerListViewController = [[OfferListViewController alloc] init];
            offerListViewController.prevViewController = self;
            [self.prevViewController.navigationController pushViewController:offerListViewController animated:YES];
        }
        [self.revealSideViewController popViewControllerAnimated:YES];
    }else if (cellRow == 3) {
        MyNavigationController *navController = (MyNavigationController *)self.prevViewController.navigationController;
        int i = 0;
        for (i = 0; i < navController.viewControllers.count; i++) {
            if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[AppointmentViewController class]]) {
                [self.prevViewController.navigationController popToViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
                break;
            }
        }
        if (i == navController.viewControllers.count) {
            AppointmentViewController *appointmentViewController = [[AppointmentViewController alloc] init];
            appointmentViewController.prevViewController = self;
            [self.prevViewController.navigationController pushViewController:appointmentViewController animated:YES];
        }
        [self.revealSideViewController popViewControllerAnimated:YES];
    }else if (cellRow == 4) {
        MyNavigationController *navController = (MyNavigationController *)self.prevViewController.navigationController;
        int i = 0;
        for (i = 0; i < navController.viewControllers.count; i++) {
            if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[FavoritesViewController class]]) {
                [self.prevViewController.navigationController popToViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
                break;
            }
        }
        if (i == navController.viewControllers.count) {
            FavoritesViewController *favoritesViewController = [[FavoritesViewController alloc] init];
            favoritesViewController.prevViewController = self;
            [self.prevViewController.navigationController pushViewController:favoritesViewController animated:YES];
        }
    }else if (cellRow == 5) {
        MyNavigationController *navController = (MyNavigationController *)self.prevViewController.navigationController;
        int i = 0;
        for (i = 0; i < navController.viewControllers.count; i++) {
            if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[NotificationViewController class]]) {
                [self.prevViewController.navigationController popToViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
                break;
            }
        }
        if (i == navController.viewControllers.count) {
            NotificationViewController *notificationViewController = [[NotificationViewController alloc] init];
            [self.prevViewController.navigationController pushViewController:notificationViewController animated:YES];
        }
    }
    [self.revealSideViewController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)onLogoPressed:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MyNavigationController *navController = (MyNavigationController *)self.prevViewController.navigationController;
    int i = 0;
    for (i = 0; i < navController.viewControllers.count; i++) {
        if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[HomeViewController class]]) {
            [self.prevViewController.navigationController popToViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
            break;
        }
    }
    if (i == navController.viewControllers.count) {
        HomeViewController *homeViewController = [[HomeViewController alloc] init];
        delegate.postViewController = homeViewController;
        homeViewController.prevViewController = self;
        [self.prevViewController.navigationController pushViewController:homeViewController animated:YES];
    }
    [self.revealSideViewController popViewControllerAnimated:YES];
}

- (void) setEnable:(BOOL)enable
{
    [self.view setUserInteractionEnabled:enable];
}

@end
