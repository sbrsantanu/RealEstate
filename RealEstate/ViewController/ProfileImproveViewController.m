//
//  ProfileImproveViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/30/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "ProfileImproveViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "PostViewController.h"
#import "OfferListViewController.h"
#import "AppointmentViewController.h"
#import "FavoritesViewController.h"
#import "MenuViewController.h"
#import "MyNavigationController.h"

#import "PostNewViewController.h"

#import "Property.h"
#import "PropertyImage.h"
#import "Users.h"

#import "Constant.h"
#import "NSString+SBJSON.h"
#import "ImprovePostCell.h"

@interface ProfileImproveViewController ()

@end

@implementation ProfileImproveViewController

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
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [self.mainView setFrame:CGRectMake(0,44,bounds.size.width,bounds.size.height - 64)];
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [self.mainView setFrame:CGRectMake(0,64,bounds.size.width,bounds.size.height - 64)];
    }
    [self.mainView setContentSize:CGSizeMake(bounds.size.width, 865)];
    [self getListInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getListInfo
{
    /*[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (delegate.beforePoint <= delegate.afterPoint) {
            lblTitle.text = @"Profile improved";
            lblDescription.text = @"Your new profile looking great. Why not improve some of your listings too?";
        }else if (delegate.beforePoint > delegate.afterPoint) {
            lblTitle.text = @"Profile worsened";
            lblDescription.text = @"Your new profile looking bad. Why not improve some of your listings?";
        }
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?task=postlist&userid=%@", actionUrl,delegate.userid]];
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        [self performSelectorOnMainThread:@selector(doneGetListInfo:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tblList reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });*/
    postList = [[NSMutableArray alloc] init];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Get Property Data
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@'",delegate.userid]]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datecreated" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
    
    NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
    [fetchRequest setEntity:propEntity];
    NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Property *propInfo in propObjects) {
        Users *userInfo = propInfo.userInfo;
        BOOL is_valid = TRUE;
        NSDate *curDate = [NSDate date];
        if ([delegate.userid isEqualToString:[NSString stringWithFormat:@"%@",userInfo.user_id]]) {
            if (![propInfo.age isEqualToString:@""] && [delegate getYear:curDate] - [delegate getYear:userInfo.birthday] <= [propInfo.age intValue]) {
                is_valid = FALSE;
            }
            if (![propInfo.race isEqualToString:@""] && ![userInfo.race isEqualToString:propInfo.race]) {
                is_valid = FALSE;
            }
            if (![propInfo.nationality isEqualToString:@""] && ![userInfo.nationality isEqualToString:propInfo.nationality]) {
                is_valid = FALSE;
            }
        }
        if (!is_valid) {
            continue;
        }
        NSMutableDictionary *property = [[NSMutableDictionary alloc] init];
        [property setValue:propInfo.propertyid forKey:@"id"];
        [property setValue:propInfo.name forKey:@"name"];
        [property setValue:propInfo.type forKey:@"type"];
        [propInfo setValue:propInfo.address1 forKey:@"address1"];
        [property setValue:propInfo.quality forKey:@"quality"];
        NSMutableArray *imageList = [[NSMutableArray alloc] init];
        for (PropertyImage *propImage in propInfo.imgInfo) {
            [imageList addObject:propImage.data];
        }
        [property setValue:imageList forKey:@"images"];
        [postList addObject:property];
    }
    [tblList reloadData];
}

- (void) doneGetListInfo :(NSString*)data
{
    NSDictionary  *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        postList = [NSMutableArray arrayWithArray:[dataDict objectForKey:@"posts"]];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([postList count] == 0) {
        return 1;
    }else {
        return [postList count];

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 259.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([postList count] == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.text = @"No Posts";
        return cell;
    }else {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"ImprovePostCell" owner:self options:nil];
        ImprovePostCell *cell = [nibArray objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary * dic = [postList objectAtIndex:indexPath.row];
        
        if ([[dic objectForKey:@"type"] intValue] == 1) {
            cell.lblName.text = [dic objectForKey:@"address1"];
        }else {
            cell.lblName.text = [dic objectForKey:@"name"];
        }
        cell.prgQualityBefore = [[CMTwoToneProgressBar alloc] initWithFrame:CGRectMake(88,201,154,10)];
        [cell.prgQualityBefore setProgressBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:231 / 255.0 blue:232 / 255.0 alpha:1.0]];
        [cell.prgQualityBefore setProgressBarColor:[UIColor colorWithRed:74 / 255.0 green:181 / 255.0 blue:229 / 255.0 alpha:1.0]];
        [cell.prgQualityBefore setProgress:(delegate.beforePoint + [[dic objectForKey:@"quality"] intValue]) / 26.0f animated:NO];
        [cell.prgQualityBefore setOuterBorderColor:[UIColor whiteColor]];
        [cell.contentView addSubview:cell.prgQualityBefore];
        
        cell.prgQualityAfter = [[CMTwoToneProgressBar alloc] initWithFrame:CGRectMake(88,228,154,10)];
        [cell.prgQualityAfter setProgressBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:231 / 255.0 blue:232 / 255.0 alpha:1.0]];
        [cell.prgQualityAfter setProgressBarColor:[UIColor colorWithRed:74 / 255.0 green:181 / 255.0 blue:229 / 255.0 alpha:1.0]];
        [cell.prgQualityAfter setProgress:(delegate.afterPoint + [[dic objectForKey:@"quality"] intValue]) / 26.0f animated:NO];
        [cell.prgQualityAfter setOuterBorderColor:[UIColor whiteColor]];
        [cell.contentView addSubview:cell.prgQualityAfter];
        
        NSArray *imageList = (NSArray *)[dic objectForKey:@"images"];
        if (imageList.count <= 1) {
            [cell.btnNext setHidden:YES];
            [cell.btnPrev setHidden:YES];
        }else {
            [cell.btnNext setHidden:NO];
            [cell.btnPrev setHidden:NO];
        }
        [cell setPropertyDetail:[[dic objectForKey:@"id"] intValue] pictures:imageList type:1];
        return cell;
    }
}

- (IBAction)onBackBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDoneBtnPressed:(id)sender {
    /*if ([self.afterViewController isKindOfClass:[PostViewController class]]) {
        PostViewController *postViewController = (PostViewController *)self.afterViewController;
        postViewController.prevViewController = self.prevViewController;
        [self.navigationController popToViewController:self.afterViewController animated:YES];
    }else if ([self.afterViewController isKindOfClass:[OfferListViewController class]]) {
        OfferListViewController *offerListViewController = (OfferListViewController *)self.afterViewController;
        offerListViewController.prevViewController = self.prevViewController;
        [self.navigationController popToViewController:self.afterViewController animated:YES];
    }else if ([self.afterViewController isKindOfClass:[AppointmentViewController class]]) {
        AppointmentViewController *appointmentViewController = (AppointmentViewController *)self.afterViewController;
        appointmentViewController.prevViewController = self.prevViewController;
        [self.navigationController popToViewController:self.afterViewController animated:YES];
    }else if ([self.afterViewController isKindOfClass:[FavoritesViewController class]]) {
        FavoritesViewController *favoritesViewController = (FavoritesViewController *)self.afterViewController;
        favoritesViewController.prevViewController = self.prevViewController;
        [self.navigationController popToViewController:self.afterViewController animated:YES];
    }else if ([self.afterViewController isKindOfClass:[MenuViewController class]]) {
        MenuViewController *menuViewController = [[MenuViewController alloc] init];
        menuViewController.prevViewController = self.prevViewController;
        MyNavigationController *n = [[MyNavigationController alloc] initWithRootViewController:menuViewController];
        n.navigationBarHidden = YES;
        [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionLeft withOffset:0 animated:TRUE];
        [self.navigationController popViewControllerAnimated:NO];
    }*/
    MyNavigationController *navController = (MyNavigationController *)self.navigationController;
    int i = 0;
    for (i = 0; i < navController.viewControllers.count; i++) {
        if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[PostViewController class]]) {
            [self.navigationController popToViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
            break;
        }
    }
    if (i == navController.viewControllers.count) {
        PostViewController *postViewController = [[PostViewController alloc] init];
        [self.navigationController pushViewController:postViewController animated:YES];
    }
}
@end
