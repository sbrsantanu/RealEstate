//
//  PostViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "PostViewController.h"
#import "PostEditViewController.h"
#import "PostNewViewController.h"
#import "MyNavigationController.h"
#import "ProfileEditViewController.h"
#import "AskOwnerViewController.h"

#import "MenuViewController.h"

#import "PostCell.h"
#import "AsyncImageView.h"
#import "MBProgressHUD.h"
#import "DataModel.h"
#import "AFNetworking.h"

#import "Property.h"
#import "Users.h"
#import "PropertyImage.h"
#import "NSData+Base64.h"
#import "PropertyFurnish.h"
#import "PropertyFacility.h"


#import "UIImage+animatedGIF.h"

#import "NSString+SBJSON.h"

#import "Constant.h"

#import "AppDelegate.h"

@interface PostViewController ()

@end

@implementation PostViewController

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
    
    if ([self.prevViewController isKindOfClass:[MenuViewController class]]) {
        MenuViewController *menuViewController = (MenuViewController *)self.prevViewController;
        menuViewController.prevViewController = self;
    }
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [tblList setFrame:CGRectMake(0,44,bounds.size.width,bounds.size.height - 64)];
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [tblList setFrame:CGRectMake(0,64,bounds.size.width,bounds.size.height - 64)];
    }
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [tblList addSubview:refresh];
    [self getListInfo];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
    [self getListInfo];
}

-(void)viewDidAppear:(BOOL)animated
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

- (IBAction)onMenuBtnPressed:(id)sender {
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    menuViewController.prevViewController = self;
    MyNavigationController *n = [[MyNavigationController alloc] initWithRootViewController:menuViewController];
    n.navigationBarHidden = YES;
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionLeft withOffset:0 animated:TRUE];
}

- (IBAction)onAddPostBtnPressed:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.userid == nil || [delegate.userid isEqualToString:@""] || [delegate.userid isEqualToString:@"0"]) {
        ProfileEditViewController *profileEditViewController = [[ProfileEditViewController alloc] init];
        profileEditViewController.prevViewController = self;
        [self.navigationController pushViewController:profileEditViewController animated:YES];
    }else {
        PostNewViewController *postNewViewController = [[PostNewViewController alloc] init];
        [self.navigationController pushViewController:postNewViewController animated:YES];
    }
}

- (void) getListInfo
{
    postList = [[NSMutableArray alloc] init];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Get User Data
    
    
    //Get Property Data
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@'",delegate.userid]]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datecreated" ascending:NO];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"propertyid" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor,sortDescriptor1, nil]];
    
    NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
    [fetchRequest setEntity:propEntity];
    NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *logintimes = [defaults valueForKey:@"logintimes1"];
    if (logintimes != nil && [logintimes isEqualToString:@"1"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
        dispatch_async(myqueue, ^{
            NSString *reqString = [NSString stringWithFormat:@"%@?task=getpostdata&userid=%@", serverActionUrl,delegate.userid];
            reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:reqString];
            NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            
            [self performSelectorOnMainThread:@selector(doneGetListInfo:) withObject:strData waitUntilDone:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [defaults setValue:@"0" forKeyPath:@"logintimes1"];
                [tblList reloadData];
            });
        });
    }else {
        for (Property *propInfo in propObjects) {
            NSMutableDictionary *property = [[NSMutableDictionary alloc] init];
            [property setObject:propInfo.propertyid forKey:@"id"];
            [property setObject:propInfo.name forKey:@"name"];
            [property setObject:propInfo.type forKey:@"type"];
            [property setObject:propInfo.address1 forKey:@"address1"];
            [property setObject:propInfo.quality forKey:@"quality"];
            NSMutableArray *imageList = [[NSMutableArray alloc] init];
            for (PropertyImage *propImage in propInfo.imgInfo) {
                NSMutableDictionary *image = [[NSMutableDictionary alloc] init];
                if (propImage.path != nil) {
                    [image setObject:propImage.path forKey:@"path"];
                }else {
                    [image setObject:@"" forKey:@"path"];
                }
                if (propImage.data != nil) {
                    [image setObject:propImage.data forKey:@"data"];
                }
                [imageList addObject:image];
            }
            [property setObject:imageList forKey:@"images"];
            [postList addObject:property];
        }
        [tblList reloadData];
    }
}

- (void) doneGetListInfo :(NSString*)data
{
    
    NSDictionary  *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = delegate.managedObjectContext;
        postList = (NSMutableArray *)[dataDict objectForKey:@"properties"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MM-dd"];
        for (int i = 0; i < postList.count; i++) {
            Property *propObject = [NSEntityDescription insertNewObjectForEntityForName:@"Property" inManagedObjectContext:context];
            propObject.propertyid = [NSNumber numberWithInt:[[[postList objectAtIndex:i] objectForKey:@"id"] intValue]];
            propObject.userid = [NSNumber numberWithInt:[[[postList objectAtIndex:i] objectForKey:@"userid"] intValue]];
            propObject.name = [[postList objectAtIndex:i] objectForKey:@"name"];
            propObject.quality = [NSNumber numberWithInt:[[[postList objectAtIndex:i] objectForKey:@"quality"] intValue]];
            propObject.type = [NSNumber numberWithInt:[[[postList objectAtIndex:i] objectForKey:@"type"] intValue]];
            propObject.rooms = [NSNumber numberWithInt:[[[postList objectAtIndex:i] objectForKey:@"rooms"] intValue]];
            propObject.toilets = [NSNumber numberWithInt:[[[postList objectAtIndex:i] objectForKey:@"toilets"] intValue]];
            propObject.sqft = [NSNumber numberWithInt:[[[postList objectAtIndex:i] objectForKey:@"sqft"] intValue]];
            propObject.parkings = [NSNumber numberWithInt:[[[postList objectAtIndex:i] objectForKey:@"parkings"] intValue]];
            propObject.availability = [dateFormat dateFromString:[[postList objectAtIndex:i] objectForKey:@"availability"]];
            propObject.rental = [[postList objectAtIndex:i] objectForKey:@"rental"];
            propObject.furnish_type = [NSNumber numberWithInt:[[[postList objectAtIndex:i] objectForKey:@"furnish_type"] intValue]];
            propObject.address1 = [[postList objectAtIndex:i] objectForKey:@"address1"];
            propObject.address2 = [[postList objectAtIndex:i] objectForKey:@"address2"];
            propObject.zipcode = [[postList objectAtIndex:i] objectForKey:@"zipcode"];
            propObject.describe = [[postList objectAtIndex:i] objectForKey:@"description"];
            propObject.latitude = [NSNumber numberWithDouble:[[[postList objectAtIndex:i] objectForKey:@"latitude"] doubleValue]];
            propObject.longitude = [NSNumber numberWithDouble:[[[postList objectAtIndex:i] objectForKey:@"longitude"] doubleValue]];
            propObject.time = [[postList objectAtIndex:i] objectForKey:@"time"];
            propObject.status = [NSNumber numberWithInt:[[[postList objectAtIndex:i] objectForKey:@"status"] intValue]];
            propObject.datecreated = [dateFormat dateFromString:[[postList objectAtIndex:i] objectForKey:@"datecreated"]];
            propObject.dateupdated = [dateFormat dateFromString:[[postList objectAtIndex:i] objectForKey:@"dateupdated"]];
            propObject.age = [[postList objectAtIndex:i] objectForKey:@"age"];
            propObject.nationality = [[postList objectAtIndex:i] objectForKey:@"nationality"];
            propObject.race = [[postList objectAtIndex:i] objectForKey:@"race"];
            propObject.unit = [[postList objectAtIndex:i] objectForKey:@"unit"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYY-MM-dd"];
            propObject.prefertimestart = [dateFormat dateFromString:[[postList objectAtIndex:i] objectForKey:@"prefertimestart"]];
            propObject.availability = [dateFormat dateFromString:[[postList objectAtIndex:i] objectForKey:@"avail_date"]];
            propObject.userInfo = delegate.userObject;
            NSArray *propImages = [[postList objectAtIndex:i] objectForKey:@"images"];
            for (int j = 0; j < propImages.count; j++) {
                /*dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
                dispatch_async(myqueue, ^{*/
                    PropertyImage *imageObject = [NSEntityDescription insertNewObjectForEntityForName:@"PropertyImage" inManagedObjectContext:context];
                    imageObject.propertyid = [NSNumber numberWithInt:[[[propImages objectAtIndex:j] objectForKey:@"propertyid"] intValue]];
                    imageObject.path = [[propImages objectAtIndex:j] objectForKey:@"path"];
                    imageObject.datecreated = [dateFormat dateFromString:[[propImages objectAtIndex:j] objectForKey:@"datecreated"]];
                    imageObject.dateupdated = [dateFormat dateFromString:[[propImages objectAtIndex:j] objectForKey:@"dateupdated"]];
                    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[propImages objectAtIndex:j] objectForKey:@"path"]]];
                    imageObject.data = data;
                    imageObject.propertyInfo = propObject;
                    //imageObject.data = [NSData dataFromBase64String:[[propImages objectAtIndex:j] objectForKey:@"data"]];
                    //[delegate saveContext];
                //});
            }
            NSArray *propFurnishes = [[postList objectAtIndex:i] objectForKey:@"furnishes"];
            for (int j = 0; j < propFurnishes.count; j++) {
                PropertyFurnish *furnishObject = [NSEntityDescription insertNewObjectForEntityForName:@"PropertyFurnish" inManagedObjectContext:context];
                furnishObject.propertyid = [NSNumber numberWithInt:[[[propFurnishes objectAtIndex:j] objectForKey:@"propertyid"] intValue]];
                furnishObject.furnish_name = [[propFurnishes objectAtIndex:j] objectForKey:@"furnish_name"];
            }
            NSArray *propFacilities = [[postList objectAtIndex:i] objectForKey:@"facilities"];
            for (int j = 0; j < propFacilities.count; j++) {
                PropertyFacility *facilityObject = [NSEntityDescription insertNewObjectForEntityForName:@"PropertyFacility" inManagedObjectContext:context];
                facilityObject.propertyid = [NSNumber numberWithInt:[[[propFacilities objectAtIndex:j] objectForKey:@"propertyid"] intValue]];
                facilityObject.facility_name = [[propFacilities objectAtIndex:j] objectForKey:@"facility_name"];
            }
            NSLog(@"%@",propObject);
        }
        [delegate saveContext];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (postList == nil) {
        return 0;
    }else if ([postList count] == 0) {
        [self.imgArrow setHidden:NO];
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"arrow" withExtension:@"gif"];
        self.imgArrow.image = [UIImage animatedImageWithAnimatedGIFURL:url];
        return 1;
    }else {
        [self.imgArrow setHidden:YES];
        return [postList count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([postList count] == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.text = @"You can post a property listing immediately, click the post icon and you are ready to go!";
        cell.textLabel.numberOfLines = 3;
        return cell;
    }else {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        PostCell *cell = [nibArray objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary * dic = [postList objectAtIndex:indexPath.row];
        
        if ([[dic objectForKey:@"type"] intValue] == 1) {
            cell.lblName.text = [dic objectForKey:@"address1"];
        }else {
            cell.lblName.text = [dic objectForKey:@"name"];
        }
        cell.prgQuality = [[CMTwoToneProgressBar alloc] initWithFrame:CGRectMake(88,267,154,10)];
        [cell.prgQuality setProgressBackgroundColor:[UIColor colorWithRed:230 / 255.0 green:231 / 255.0 blue:232 / 255.0 alpha:1.0]];
        [cell.prgQuality setProgressBarColor:[UIColor colorWithRed:74 / 255.0 green:181 / 255.0 blue:229 / 255.0 alpha:1.0]];
        [cell.prgQuality setProgress:([delegate.quality intValue] + [[dic objectForKey:@"quality"] intValue]) / 26.0f animated:NO];
        [cell.prgQuality setOuterBorderColor:[UIColor whiteColor]];
        [cell.contentView addSubview:cell.prgQuality];
        
        NSArray *imageList = (NSArray *)[dic objectForKey:@"images"];
        if (imageList.count <= 1) {
            [cell.btnPrev setHidden:YES];
            [cell.btnNext setHidden:YES];
        }else {
            [cell.btnPrev setHidden:NO];
            [cell.btnNext setHidden:NO];
        }
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
        cell.imgView.tag = [[dic objectForKey:@"id"] intValue];
        [cell.imgView addGestureRecognizer:singleTap];
        [cell setPropertyDetail:[[dic objectForKey:@"id"] intValue] pictures:imageList type:2];
        cell.btnQA.tag = [[dic objectForKey:@"id"] intValue];
        [cell.btnQA addTarget:self action:@selector(onQABtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIScrollView *sender = (UIScrollView *)gesture.view;
    delegate.pid = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    PostEditViewController *postEditViewController = [[PostEditViewController alloc] init];
    [self.navigationController pushViewController:postEditViewController animated:YES];
    
}

- (void)onQABtnPressed:(UIButton *)sender
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UILabel *lblPropName = (UILabel *)[[sender superview].subviews objectAtIndex:3];
    [delegate.dataModel setPUserId: delegate.userid];
    [delegate.dataModel setDeviceToken:delegate.deviceToken];
    [delegate.dataModel setPropertyId: [NSString stringWithFormat:@"%ld",(long)sender.tag]];
    [delegate.dataModel setNickname:[delegate.username stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    delegate.userType = @"2";
    delegate.pname = lblPropName.text;
    [self postJoinRequest:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
}

- (void)postJoinRequest:(NSString *)pid {
	//MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	//hud.labelText = NSLocalizedString(@"Connecting", nil);
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.pid = pid;
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverActionUrl]];
    NSDictionary *params = @{@"task":@"joinChat",
                             @"deviceToken":[delegate.dataModel deviceToken],
                             @"p_user_id":delegate.userid,
                             @"user_type":@"1",
                             @"propertyid":pid};
    [client postPath:@"index.php"
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 if ([self isViewLoaded]) {
                     //[MBProgressHUD hideHUDForView:self.view animated:YES];
                     if([operation.response statusCode] != 200) {
                         //ShowErrorAlert(NSLocalizedString(@"There was an error communicating with the server", nil));
                     } else {
                         NSDictionary *dataDict = (NSDictionary *)[operation.responseString JSONValue];
                         if ([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                             
                         }else {
                             
                         }
                         //[self userDidJoin];
                     }
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 if ([self isViewLoaded]) {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     //NSLog(@"%@",[error description]);
                     //ShowErrorAlert([error localizedDescription]);
                 }
             }];
    AskOwnerViewController *askOwnerViewController = [[AskOwnerViewController alloc] init];
    [askOwnerViewController setOption:1];
    [self.navigationController pushViewController:askOwnerViewController animated:YES];
}

@end
