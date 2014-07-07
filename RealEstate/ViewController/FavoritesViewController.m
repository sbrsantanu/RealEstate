//
//  FavoritesViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "FavoritesViewController.h"

#import "MenuViewController.h"
#import "OfferViewController.h"
#import "MyNavigationController.h"

#import "ProfileEditViewController.h"
#import "DetailPropertyViewController.h"

#import "AppDelegate.h"
#import "AsyncImageView.h"
#import "PropertyCell.h"
#import "MBProgressHUD.h"
#import "Property.h"
#import "PropertyImage.h"
#import "PropertyFacility.h"
#import "PropertyFurnish.h"
#import "Favorites.h"
#import "AFNetworking.h"
#import "Offer.h"

#import "NSString+SBJSON.h"

#import "Constant.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

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
        [self getListInfo];
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

- (void) getListInfo
{
    /*[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?task=favoritelist&userid=%@", actionUrl,delegate.userid]];
    
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
        [self performSelectorOnMainThread:@selector(doneGetListInfo:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tblList reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });*/
    favoriteList = [[NSMutableArray alloc] init];
    NSDate *curDate = [NSDate date];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Get Property Data
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@'",delegate.userid]]];
    
    NSEntityDescription *favEntity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:context];
    [fetchRequest setEntity:favEntity];
    NSArray *favObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *logintimes = [defaults valueForKey:@"logintimes2"];
    if (logintimes != nil && [logintimes isEqualToString:@"1"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
        dispatch_async(myqueue, ^{
            NSString *reqString = [NSString stringWithFormat:@"%@?task=getfavdata&userid=%@", serverActionUrl,delegate.userid];
            reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:reqString];
            NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            
            [self performSelectorOnMainThread:@selector(doneGetListInfo:) withObject:strData waitUntilDone:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [defaults setValue:@"0" forKeyPath:@"logintimes2"];
                [tblList reloadData];
            });
        });
    }else {
        for (Favorites *favInfo in favObjects) {
            Property *propInfo = favInfo.propertyInfo;
            if (propInfo == nil) {
                continue;
            }
            NSMutableDictionary *property = [[NSMutableDictionary alloc] init];
            [property setObject:propInfo.propertyid forKey:@"id"];
            [property setObject:propInfo.userid forKey:@"userid"];
            [property setObject:propInfo.name forKey:@"name"];
            [property setObject:propInfo.rental forKey:@"rental"];
            [property setObject:propInfo.type forKey:@"type"];
            [property setObject:propInfo.furnish_type forKey:@"furnish_type"];
            [property setObject:propInfo.sqft forKey:@"sqft"];
            [property setObject:propInfo.rooms forKey:@"rooms"];
            [property setObject:propInfo.parkings forKey:@"parkings"];
            [property setObject:propInfo.address1 forKey:@"address1"];
            [property setObject:propInfo.address2 forKey:@"address2"];
            [property setObject:propInfo.latitude forKey:@"latitude"];
            [property setObject:propInfo.longitude forKey:@"longitude"];
            [property setObject:propInfo.describe forKey:@"description"];
            [property setObject:propInfo.time forKey:@"time"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"m/d/YY"];
            if ([curDate compare:propInfo.availability] >= 0) {
                [property setObject:@"Available Now" forKey:@"availability"];
            }else {
                [property setObject:[NSString stringWithFormat:@"%@ Available",[dateFormat stringFromDate:propInfo.availability] ] forKey:@"availability"];
            }
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
            [favoriteList addObject:property];
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
        NSManagedObjectContext *context = [delegate managedObjectContext];
        favoriteList = [NSMutableArray arrayWithArray:[dataDict objectForKey:@"favorites"]];
        for (int i = 0; i < favoriteList.count; i++) {
            NSError *error;
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSDictionary *dic = (NSDictionary *)[favoriteList objectAtIndex:i];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid!='%@' and propertyid='%@'",delegate.userid, [[favoriteList objectAtIndex:i] objectForKey:@"id"]]]];
            NSEntityDescription *postEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
            [fetchRequest setEntity:postEntity];
            NSArray *postObjects = [context executeFetchRequest:fetchRequest error:&error];
            Property *propObject;
            if (postObjects.count == 0) {
                propObject = [NSEntityDescription insertNewObjectForEntityForName:@"Property" inManagedObjectContext:context];
            }else {
                propObject = (Property *)[postObjects objectAtIndex:0];
                [propObject removeImgInfo:propObject.imgInfo];
                [propObject removeFurnishInfo:propObject.furnishInfo];
                [propObject removeFacilityInfo:propObject.facilityInfo];
            }
            propObject.propertyid = [NSNumber numberWithInt:[[dic objectForKey:@"id"] intValue]];
            propObject.userid = [NSNumber numberWithInt:[[dic objectForKey:@"userid"] intValue]];
            propObject.username = [dic objectForKey:@"username"];
            propObject.userphoto = [dic objectForKey:@"userphoto"];
            propObject.userprivacy = [NSNumber numberWithBool:[[dic objectForKey:@"userprivacy"] boolValue]];
            
            propObject.name = [dic objectForKey:@"name"];
            propObject.rental = [dic objectForKey:@"rental"];
            propObject.toilets = [NSNumber numberWithInt:[[dic objectForKey:@"toilets"] intValue]];
            propObject.type =  [NSNumber numberWithInt:[[dic objectForKey:@"type"] intValue]];
            propObject.furnish_type =  [NSNumber numberWithInt:[[dic objectForKey:@"furnish_type"] intValue]];
            propObject.sqft =  [NSNumber numberWithInt:[[dic objectForKey:@"sqft"] intValue]];
            propObject.rooms =  [NSNumber numberWithInt:[[dic objectForKey:@"rooms"] intValue]];
            propObject.parkings =  [NSNumber numberWithInt:[[dic objectForKey:@"parkings"] intValue]];
            propObject.address1 =  [dic objectForKey:@"address1"];
            propObject.address2 =  [dic objectForKey:@"address2"];
            propObject.latitude = [NSNumber numberWithFloat:[[dic objectForKey:@"latitude"] floatValue]];
            propObject.longitude = [NSNumber numberWithFloat:[[dic objectForKey:@"longitude"] floatValue]];
            propObject.describe = [dic objectForKey:@"description"];
            propObject.time = [dic objectForKey:@"time"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYY-MM-dd"];
            propObject.prefertimestart = [dateFormat dateFromString:[dic objectForKey:@"prefertimestart"]];
            propObject.availability = [dateFormat dateFromString:[dic objectForKey:@"avail_date"]];
            NSArray *propImages = [[favoriteList objectAtIndex:i] objectForKey:@"images"];
            for (int j = 0; j < propImages.count; j++) {
                PropertyImage *imageObject = [NSEntityDescription insertNewObjectForEntityForName:@"PropertyImage" inManagedObjectContext:context];
                imageObject.propertyid = [NSNumber numberWithInt:[[[propImages objectAtIndex:j] objectForKey:@"propertyid"] intValue]];
                imageObject.path = [[propImages objectAtIndex:j] objectForKey:@"path"];
                //imageObject.data = [NSData dataFromBase64String:[[propImages objectAtIndex:j] objectForKey:@"data"]];
                imageObject.datecreated = [dateFormat dateFromString:[[propImages objectAtIndex:j] objectForKey:@"datecreated"]];
                imageObject.dateupdated = [dateFormat dateFromString:[[propImages objectAtIndex:j] objectForKey:@"dateupdated"]];
                imageObject.propertyInfo = propObject;
            }
            
            NSArray *furnishes = (NSArray *)[dic objectForKey:@"furnishes"];
            for (int j = 0; j < furnishes.count; j++) {
                PropertyFurnish *furnishObject = [NSEntityDescription insertNewObjectForEntityForName:@"PropertyFurnish" inManagedObjectContext:context];
                furnishObject.propertyid = propObject.propertyid;
                furnishObject.furnish_name = [furnishes objectAtIndex:j];
                furnishObject.propertyInfo = propObject;
            }
            
            NSArray *facilities = (NSArray *)[dic objectForKey:@"facilities"];
            for (int j = 0; j < facilities.count; j++) {
                PropertyFacility *facilityObject = [NSEntityDescription insertNewObjectForEntityForName:@"PropertyFacility" inManagedObjectContext:context];
                facilityObject.propertyid = propObject.propertyid;
                facilityObject.facility_name = [facilities objectAtIndex:j];
                facilityObject.propertyInfo = propObject;
            }
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@' and propertyid='%@'",delegate.userid, [[favoriteList objectAtIndex:i] objectForKey:@"id"]]]];
            NSEntityDescription *offerEntity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
            [fetchRequest setEntity:offerEntity];
            NSArray *offerObjects = [context executeFetchRequest:fetchRequest error:&error];
            if (offerObjects.count > 0) {
                Offer *offerObject = (Offer *)[offerObjects objectAtIndex:0];
                offerObject.propertyInfo = propObject;
            }
            Favorites *favObject = [NSEntityDescription insertNewObjectForEntityForName:@"Favorites" inManagedObjectContext:context];
            favObject.userid = [NSNumber numberWithInt:[[[favoriteList objectAtIndex:i] objectForKey:@"userid"] intValue]];
            favObject.propertyid = [NSNumber numberWithInt:[[[favoriteList objectAtIndex:i] objectForKey:@"id"] intValue]];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid!='%@' and propertyid='%@'",delegate.userid,favObject.propertyid]]];
            NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
            [fetchRequest setEntity:propEntity];
            NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
            if (propObjects.count > 0) {
                favObject.propertyInfo = (Property *)[propObjects objectAtIndex:0];
            }
            favObject.userInfo = delegate.userObject;
        }
        [delegate saveContext];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Favorites" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (favoriteList != nil && [favoriteList count] == 0) {
        return 1;
    }else {
        return [favoriteList count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 375.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (favoriteList != nil && [favoriteList count] == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.text = @"No Favorites";
        return cell;
    }
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"PropertyCell" owner:self options:nil];
    PropertyCell *cell = [nibArray objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary * dic = [favoriteList objectAtIndex:indexPath.row];
    if ([dic objectForKey:@"name"] == nil || [[dic objectForKey:@"name"] isEqualToString:@""]) {
        cell.lblName.text = [dic objectForKey:@"address1"];
    }else {
        cell.lblName.text =[NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
    }
    NSString *furnish_type = @"";
    if ([dic objectForKey:@"furnish_type"] != [[NSNull alloc] init]) {
        if ([[dic objectForKey:@"furnish_type"] intValue] == 1) {
            furnish_type = @"Basic Unit";
        }else if ([[dic objectForKey:@"furnish_type"] intValue] == 2) {
            furnish_type = @"Partial Furnished";
        }else if ([[dic objectForKey:@"furnish_type"] intValue] == 3) {
            furnish_type = @"Fully Furnished";
        }
    }
    cell.lblFurnish.text = [NSString stringWithFormat:@"RM%@/mo & %@", [dic objectForKey:@"rental"],furnish_type];
    NSString *type = @"";
    if ([dic objectForKey:@"type"] != [[NSNull alloc] init]) {
        if ([[dic objectForKey:@"type"] intValue] == 1) {
            type = @"Landed";
        }else if ([[dic objectForKey:@"type"] intValue] == 2) {
            type = @"High Rise";
        }
    }
    cell.lblType.text = type;
    cell.lblSize.text = [NSString stringWithFormat:@"%d sqft", [[dic objectForKey:@"sqft"] intValue]];
    cell.lblRooms.text = [NSString stringWithFormat:@"%d Rooms", [[dic objectForKey:@"rooms"] intValue]];
    
    cell.lblAvailability.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"availability"]];
    
    /*[cell.imgView setContentSize:CGSizeMake(320 * imageList.count, 185)];
    [cell.imgView setFrame:CGRectMake(0,0,320,190)];
    for (int i = 0; i < imageList.count; i++) {
        AsyncImageView *newImage = [[AsyncImageView alloc] init];
        [newImage setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",propertyImageUrl, [imageList objectAtIndex:i]]]];
        [newImage setFrame:CGRectMake(i * 320.0f,0,320,185)];
        [cell.imgView addSubview:newImage];
    }*/
    
    cell.btnFavorite.imageView.image = [UIImage imageNamed:@"favorite_btn1.png"];
    
    cell.btnOffer.tag = [[dic objectForKey:@"id"] intValue];
    [cell.btnOffer addTarget:self action:@selector(onOfferBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *imageList = (NSArray *)[dic objectForKey:@"images"];
    
    cell.imgView.tag = [[dic objectForKey:@"id"] intValue];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [cell.imgView addGestureRecognizer:singleTap];
    cell.btnFavorite.tag = [[dic objectForKey:@"id"] intValue];
    [cell.btnFavorite addTarget:self action:@selector(onFavoriteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell setPropertyDetail:[[dic objectForKey:@"id"] intValue] pictures:imageList type:0];
    return cell;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIScrollView *sender = (UIScrollView *)gesture.view;
    delegate.pid = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    DetailPropertyViewController *detailPropertyViewController = [[DetailPropertyViewController alloc] init];
    [self.navigationController pushViewController:detailPropertyViewController animated:YES];
    
}

- (IBAction)onFavoriteBtnPressed:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIButton *favBtn = (UIButton *)sender;
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Get Favorite Data
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@' and propertyid='%ld'",delegate.userid,(long)favBtn.tag]]];
    NSEntityDescription *favEntity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:context];
    [fetchRequest setEntity:favEntity];
    NSArray *favObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Favorites *favObject in favObjects) {
        [context deleteObject:favObject];
    }
    [delegate saveContext];
    [self getListInfo];
    NSDictionary *params = @{@"task":@"like",
                             @"userid":delegate.userid,
                             @"propertyid":[NSString stringWithFormat:@"%ld",(long)favBtn.tag],
                             @"fav":@"0"};
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
    /*NSString *pid = [NSString stringWithFormat:@"%d",favBtn.tag];
    NSString *reqString = [NSString stringWithFormat:@"%@?task=like&userid=%@&propertyid=%@&fav=%d", actionUrl,delegate.userid,pid,fav];
    reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:reqString];
    NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    [self performSelectorOnMainThread:@selector(doneLike:) withObject:strData waitUntilDone:YES];*/
}

- (void) doneLike :(NSString*)data
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [tblList reloadData];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Favorite" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}


- (void) onOfferBtnPressed:(UIButton *)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.pid = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    if (delegate.phone == nil || [delegate.phone isEqualToString:@""]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        OfferViewController *offerViewController = [[OfferViewController alloc] init];
        [self.navigationController pushViewController:offerViewController animated:YES];
        return;
    }
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Get User Data
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid!='%@' and propertyid='%@'",delegate.userid,delegate.pid]]];
    NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
    [fetchRequest setEntity:propEntity];
    NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (propObjects.count > 0) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@' and propertyid='%@'",delegate.userid,delegate.pid]]];
        NSEntityDescription *offerEntity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
        [fetchRequest setEntity:offerEntity];
        NSArray *offerObjects = [context executeFetchRequest:fetchRequest error:&error];
        BOOL canOffer = TRUE;
        if (offerObjects.count > 0) {
            Offer *offerObject = [offerObjects objectAtIndex:0];
            if ([offerObject.status isEqualToNumber:[NSNumber numberWithInt:0]] || [offerObject.status isEqualToNumber:[NSNumber numberWithInt:1]]) {
                canOffer = FALSE;
            }
        }
        if (canOffer) {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            OfferViewController *offerViewController = [[OfferViewController alloc] init];
            [self.navigationController pushViewController:offerViewController animated:YES];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Favorites" message:@"You've already offered this property" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Favorites" message:@"No such this property" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
}

- (void) doneGetOfferStatus :(NSString*)data
{
    
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"status"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        OfferViewController *offerViewController = [[OfferViewController alloc] init];
        [self.navigationController pushViewController:offerViewController animated:YES];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Favorites" message:@"You've already offered this property" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
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
        }
    }
}*/

#pragma ---- UITableView delegate ----------

@end
