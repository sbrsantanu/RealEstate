//
//  DetailPropertyViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "DetailPropertyViewController.h"
#import "ProfileEditViewController.h"
#import "ProfileViewController.h"
#import "OfferViewController.h"
#import "AskOwnerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "VerifyViewController.h"
#import "Furnish.h"
#import "Facility.h"


#import "Property.h"
#import "PropertyFurnish.h"
#import "PropertyFacility.h"
#import "PropertyImage.h"
#import "Users.h"
#import "Favorites.h"
#import "Offer.h"

#import "AppDelegate.h"
#import "ImageSlide.h"

#import "Constant.h"
#import "MBProgressHUD.h"
#import "DataModel.h"
#import "AFNetworking.h"

#import "NSString+SBJSON.h"
#import <GoogleMaps/GoogleMaps.h>

@interface DetailPropertyViewController ()

@end

@implementation DetailPropertyViewController {
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
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    
    [self.dataView setContentSize:CGSizeMake(bounds.size.width,850)];
    self.furnishView.layer.borderColor = [[UIColor colorWithRed:128 / 255.0 green:130 / 255.0 blue:132 / 255.0 alpha:1.0] CGColor];
    self.furnishView.layer.borderWidth = 1.0f;
    self.facilityView.layer.borderColor = [[UIColor colorWithRed:128 / 255.0 green:130 / 255.0 blue:132 / 255.0 alpha:1.0] CGColor];
    self.facilityView.layer.borderWidth = 1.0f;
    [self.mapView setHidden:YES];
    
    CALayer *imageLayer = self.imgUserPhoto.layer;
    [imageLayer setCornerRadius:22];
    [imageLayer setBorderColor:[[UIColor clearColor] CGColor]];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0, 0,bounds.size.width , 44)];
        [self.dataView setFrame:CGRectMake(0,44,bounds.size.width,bounds.size.height - 108)];
        //[self.bottomView setFrame:CGRectMake(0, bounds.size.height - 44, 320, 44)];
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [self.dataView setFrame:CGRectMake(0,64,bounds.size.width,bounds.size.height - 108)];
        //[self.bottomView setFrame:CGRectMake(0, bounds.size.height - 44, 320, 44)];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.forQA != nil && [delegate.forQA isEqualToString:@"1"] && self.prevViewController != nil && [self.prevViewController isKindOfClass:[VerifyViewController class]]) {
        [self onQABtnPressed:nil];
    }else if (delegate.forFavorite != nil && [delegate.forFavorite isEqualToString:@"1"] && self.prevViewController != nil && [self.prevViewController isKindOfClass:[VerifyViewController class]]) {
        /*[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
        dispatch_async(myqueue, ^{
            delegate.forFavorite = @"0";
            NSString *reqString = [NSString stringWithFormat:@"%@?task=like&userid=%@&propertyid=%@&fav=%d", actionUrl,delegate.userid,delegate.pid,1];
            reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:reqString];
            NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            [self performSelectorOnMainThread:@selector(doneLike1:) withObject:strData waitUntilDone:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });*/
        [self onFavoriteBtnPressed:nil];
    }else {
        [self getPostInfo];
    }
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void) getPostInfo
{
    /*[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (delegate.userid == nil || [delegate.userid isEqualToString:@""]) {
            delegate.userid = @"0";
        }
        NSString *reqString = [NSString stringWithFormat:@"%@?task=postinfo&id=%@&userid=%@", actionUrl,delegate.pid,delegate.userid];
        reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:reqString];
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        [self performSelectorOnMainThread:@selector(doneGetPostInfo:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.lblLatitude.text floatValue] longitude:[self.lblLongitude.text floatValue] zoom:16 bearing:0 viewingAngle:180];
            mapView_ = [GMSMapView mapWithFrame:self.mapView.bounds camera:camera];
            mapView_.myLocationEnabled = YES;
            self.mapView.layer.borderColor = [[UIColor grayColor] CGColor];
            self.mapView.layer.borderWidth = 1.0f;
            [self.mapView addSubview: mapView_];
            
            // Creates a marker in the center of the map.
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake([self.lblLatitude.text floatValue], [self.lblLongitude.text floatValue]);
            marker.title = self.lblName.text;
            marker.map = mapView_;
        });
    });*/
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Get Property Data
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"propertyid='%@' and userid!='%@'",delegate.pid,delegate.userid]]];
    [fetchRequest setSortDescriptors:nil];
    
    NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
    [fetchRequest setEntity:propEntity];
    NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSDate *curDate = [NSDate date];
    if (propObjects.count > 0) {
        Property *propInfo = (Property *)[propObjects objectAtIndex:0];
        Users *userInfo = propInfo.userInfo;
        NSMutableArray *imageList = [[NSMutableArray alloc] init];
        for (PropertyImage *imageObject in propInfo.imgInfo) {
            NSMutableDictionary *image = [[NSMutableDictionary alloc] init];
            if (imageObject.path != nil) {
                [image setObject:imageObject.path forKey:@"path"];
            }else {
                [image setObject:@"" forKey:@"path"];
            }
            if (imageObject.data != nil) {
                [image setObject:imageObject.data forKey:@"data"];
            }
            [imageList addObject:image];
        }
        CGRect bounds = [[UIScreen mainScreen] bounds];
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"ImageSlide" owner:self options:nil];
        self.imgPhotoView = (ImageSlide *)[nibArray objectAtIndex:0];
        [self.imgPhotoView setFrame:CGRectMake(0,0,bounds.size.width,240)];
        [self.imgPhotoView setImageList:imageList type:0];
        if ([propInfo.name isEqualToString:@""]) {
            self.lblName.text = propInfo.address1;
        }else {
            self.lblName.text = propInfo.name;
        }
        self.imgPhotoView.lblName.text =self.lblName.text;
        if (imageList.count <= 1) {
            [self.imgPhotoView.btnNext setHidden:YES];
            [self.imgPhotoView.btnPrev setHidden:YES];
        }else {
            [self.imgPhotoView.btnNext setHidden:NO];
            [self.imgPhotoView.btnPrev setHidden:NO];
        }
        [self.dataView addSubview:self.imgPhotoView];
        self.lblRental.text = [NSString stringWithFormat:@"RM%@",propInfo.rental];
        if ([propInfo.furnish_type intValue] == 1) {
            self.lblFurnish.text = @"Basic Unit";
        }else if ([propInfo.furnish_type intValue] == 2) {
            self.lblFurnish.text = @"Partial Furnish";
        }else if ([propInfo.furnish_type intValue] == 3) {
            self.lblFurnish.text = @"Fully Furnish";
        }
        
        if ([propInfo.type intValue] == 1) {
            self.lblType.text = @"Landed";
        }else if ([propInfo.type intValue] == 2) {
            self.lblType.text = @"High Rise";
        }
        if (propInfo.userphoto != nil && ![propInfo.userphoto isEqualToString:@""]) {
            //[self.imgUserPhoto setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",profilePhotoUrl, [dic objectForKey:@"photo"]]]];
            [self.imgUserPhoto setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",profilePhotoUrl, propInfo.userphoto]]];
        }else {
            [self.imgUserPhoto setImage:[UIImage imageNamed:@"default_user.png"]];
        }
        
        UITapGestureRecognizer *labelNameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onNamePressed:)];
        self.lblUsername.tag = [userInfo.user_id intValue];
        self.lblPrivacy.text = [NSString stringWithFormat:@"%d",[propInfo.userprivacy intValue]];
        [self.lblUsername addGestureRecognizer:labelNameTap];
        UITapGestureRecognizer *labelNameTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onNamePressed:)];
        
        [self.imgUserPhoto addGestureRecognizer:labelNameTap1];
        
        self.lblUsername.text = propInfo.username;
        self.lblSqft.text = [NSString stringWithFormat:@"%@ sqft", propInfo.sqft];
        if ([propInfo.rooms intValue] == 0) {
            self.lblRooms.text = [NSString stringWithFormat:@"Studio"];
        }else if ([propInfo.rooms intValue] == 1) {
            self.lblRooms.text = [NSString stringWithFormat:@"1 Bedroom"];
        }else {
            self.lblRooms.text = [NSString stringWithFormat:@"%@ Bedrooms",propInfo.rooms];
        }
        if ([propInfo.toilets intValue] == 0) {
            self.lblToilets.text = [NSString stringWithFormat:@"No Toilets"];
        }else if ([propInfo.toilets intValue] == 1) {
            self.lblToilets.text = [NSString stringWithFormat:@"1 Toilet"];
        }else {
            self.lblToilets.text = [NSString stringWithFormat:@"%@ Toilets",propInfo.toilets];
        }
        if ([propInfo.parkings intValue] == 0) {
            self.lblParkings.text = [NSString stringWithFormat:@"No Parking Bays"];
        }else if ([propInfo.parkings intValue] == 1) {
            self.lblParkings.text = [NSString stringWithFormat:@"1 Parking Bay"];
        }else {
            self.lblParkings.text = [NSString stringWithFormat:@"%@ Parking Bays",propInfo.parkings];
        }
        NSDate *availability = propInfo.availability;
        long year = [delegate getYear:availability];
        long month = [delegate getMonth:availability];
        long day = [delegate getDay:availability];
        NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
        if ([propInfo.availability compare:curDate] <= 0) {
            self.lblAvailability.text = @"Available Now";
        }else {
            self.lblAvailability.text = [NSString stringWithFormat:@"%ld %@ %ld Available",year,months[month - 1],day];
        }
        latitude = [propInfo.latitude doubleValue];
        longitude = [propInfo.longitude doubleValue];
        NSMutableAttributedString *desc = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Note: %@", propInfo.describe]];
        [desc addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0f] range:NSMakeRange(0, 5)];
        self.lblDescription.text = [NSString stringWithFormat:@"Note: %@", propInfo.describe];
        self.lblDescription.attributedText = desc;
        NSString *addressText = @"";
        if (propInfo.unit != nil && ![propInfo.unit isEqualToString:@""]) {
            addressText = [NSString stringWithFormat:@"Address: %@,%@", propInfo.unit, propInfo.address1];
        }else {
            addressText = [NSString stringWithFormat:@"Address: %@", propInfo.address1];
        }
        if (propInfo.address2 != nil && ![propInfo.address2 isEqualToString:@""]) {
            addressText = [NSString stringWithFormat:@"%@,%@",addressText,propInfo.address2];
        }
        if (propInfo.zipcode != nil && ![propInfo.zipcode isEqualToString:@""]) {
            addressText = [NSString stringWithFormat:@"%@,%@",addressText,propInfo.zipcode];
        }
        self.lblAddress.text = addressText;
        NSMutableAttributedString *attrAddressText = [[NSMutableAttributedString alloc] initWithString:addressText];
        [attrAddressText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0f] range:NSMakeRange(0, 8)];
        self.lblAddress.attributedText = attrAddressText;
        [self.btnFavorite setImage:[UIImage imageNamed:@"favorite_btn.png"] forState:UIControlStateNormal];
        for (Favorites *favoritesInfo in propInfo.favoritesInfo) {
            NSLog(@"%d,%d,%d,%d",[favoritesInfo.propertyid intValue],[propInfo.propertyid intValue],[favoritesInfo.userid intValue],[propInfo.userid intValue]);
            if ([favoritesInfo.propertyid intValue] == [propInfo.propertyid intValue] && [favoritesInfo.userInfo.user_id intValue] != [propInfo.userid intValue]) {
                [self.btnFavorite setImage:[UIImage imageNamed:@"favorite_btn1.png"] forState:UIControlStateNormal];
            }
        }
        
        NSEntityDescription *furnishEntity = [NSEntityDescription entityForName:@"Furnish" inManagedObjectContext:context];
        [fetchRequest setPredicate:nil];
        [fetchRequest setSortDescriptors:nil];
        [fetchRequest setEntity:furnishEntity];
        NSArray *normalFurnishObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        NSMutableArray *normalFurnishList = [[NSMutableArray alloc] init];
        
        for (Furnish *furnishInfo in normalFurnishObjects) {
            [normalFurnishList addObject:furnishInfo.name];
        }
        
        CGRect frame = viewFurnish.frame;
        NSSet *furnishObjects = propInfo.furnishInfo;
        if (normalFurnishList.count > 0 && furnishObjects.count > 0) {
            if (normalFurnishList.count % 2 == 0) {
                frame.size.height = 50 + (normalFurnishList.count / 2) * 30;
            }else {
                frame.size.height = 50 + (normalFurnishList.count / 2 + 1) * 30;
            }
            int nFurnish = 0;
            for (int i = 0; i < normalFurnishList.count; i++) {
                if (i == 0) {
                    CGRect furnishRect = CGRectMake(10,10,100,30);
                    UILabel *labelFurnish = [[UILabel alloc] initWithFrame:furnishRect];
                    [labelFurnish setText:@"Furnishing"];
                    [labelFurnish setFont:[UIFont boldSystemFontOfSize:12.0f]];
                    [labelFurnish setTextColor:[UIColor blackColor]];
                    [viewFurnish addSubview:labelFurnish];
                }
                bool isExist = false;
                for (PropertyFurnish *furnishObject in furnishObjects) {
                    if ([furnishObject.furnish_name isEqualToString:[normalFurnishList objectAtIndex:i]]) {
                        isExist = true;
                        break;
                    }
                }
                CGRect imgRect = CGRectMake(20 + 135 * (i % 2), 45 + (i / 2) * 30, 20,20);
                UIImageView *imgFurnish = [[UIImageView alloc] initWithFrame:imgRect];
                if (isExist) {
                    nFurnish++;
                    [imgFurnish setImage:[UIImage imageNamed:@"furnish_check.png"]];
                }else {
                    [imgFurnish setImage:[UIImage imageNamed:@"furnish_uncheck.png"]];
                }
                [viewFurnish addSubview:imgFurnish];
                CGRect furnishRect = CGRectMake(45 + 135 * (i % 2),40 + (i / 2) * 30,90,30);
                UILabel *labelFurnish = [[UILabel alloc] initWithFrame:furnishRect];
                [labelFurnish setText:[normalFurnishList objectAtIndex:i]];
                [labelFurnish setFont:[UIFont systemFontOfSize:12.0f]];
                [labelFurnish setTextColor:[UIColor grayColor]];
                [viewFurnish addSubview:labelFurnish];
            }
            if (nFurnish == 0) {
                for (int i = 0; i < viewFurnish.subviews.count; i++) {
                    [[viewFurnish.subviews objectAtIndex:i] removeFromSuperview];
                }
                frame.size.height = 0;
            }
        }else {
            frame.size.height = 0;
        }
        [viewFurnish setFrame:frame];
        
        NSEntityDescription *facilityEntity = [NSEntityDescription entityForName:@"Facility" inManagedObjectContext:context];
        [fetchRequest setPredicate:nil];
        [fetchRequest setSortDescriptors:nil];
        [fetchRequest setEntity:facilityEntity];
        NSArray *normalFacilityObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        NSMutableArray *normalFacilityList = [[NSMutableArray alloc] init];
        
        for (Facility *facilityInfo in normalFacilityObjects) {
            [normalFacilityList addObject:facilityInfo.name];
        }
        
        frame = viewFacility.frame;
        NSSet *facilityObjects = propInfo.facilityInfo;
        if (normalFacilityList.count > 0 && facilityObjects.count > 0) {
            if (normalFacilityList.count % 2 == 0) {
                frame.size.height = 50 + (normalFacilityList.count / 2) * 30;
            }else {
                frame.size.height = 50 + (normalFacilityList.count / 2 + 1) * 30;
            }
            int nFacility = 0;
            for (int i = 0; i < normalFacilityList.count; i++) {
                if (i == 0) {
                    CGRect facilityRect = CGRectMake(10,10,100,30);
                    UILabel *labelFacility = [[UILabel alloc] initWithFrame:facilityRect];
                    [labelFacility setText:@"Facilities"];
                    [labelFacility setFont:[UIFont boldSystemFontOfSize:12.0f]];
                    [labelFacility setTextColor:[UIColor blackColor]];
                    [viewFacility addSubview:labelFacility];
                }
                bool isExist = false;
                for (PropertyFacility *facilityObject in facilityObjects) {
                    if ([facilityObject.facility_name isEqualToString:[normalFacilityList objectAtIndex:i]]) {
                        isExist = true;
                        break;
                    }
                }
                CGRect imgRect = CGRectMake(20 + 135 * (i % 2), 45 + (i / 2) * 30, 20,20);
                UIImageView *imgFacility = [[UIImageView alloc] initWithFrame:imgRect];
                if (isExist) {
                    nFacility++;
                    [imgFacility setImage:[UIImage imageNamed:@"furnish_check.png"]];
                }else {
                    [imgFacility setImage:[UIImage imageNamed:@"furnish_uncheck.png"]];
                }
                [viewFacility addSubview:imgFacility];
                CGRect facilityRect = CGRectMake(45 + 135 * (i % 2),40 + (i / 2) * 30,90,30);
                UILabel *labelFacility = [[UILabel alloc] initWithFrame:facilityRect];
                [labelFacility setText:[normalFacilityList objectAtIndex:i]];
                [labelFacility setFont:[UIFont systemFontOfSize:12.0f]];
                [labelFacility setTextColor:[UIColor grayColor]];
                [viewFacility addSubview:labelFacility];
            }
            if (nFacility == 0) {
                for (int i = 0; i < viewFacility.subviews.count; i++) {
                    [[viewFacility.subviews objectAtIndex:i] removeFromSuperview];
                }
                frame.size.height = 0;
            }
        }else {
            frame.size.height = 0;
        }
        if (viewFurnish.frame.size.height > 0) {
            frame.origin.y = viewFurnish.frame.origin.y + viewFurnish.frame.size.height + 5;
        }else {
            frame.origin.y = viewFurnish.frame.origin.y;
        }
        [viewFacility setFrame:frame];
        frame = self.lblDescription.frame;
        if (self.lblDescription.attributedText.length <= 6) {
            frame.size.height = 0;
            [viewDescription setHidden:YES];
        }else {
            [viewDescription setHidden:NO];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                frame.size = [self.lblDescription.text sizeWithFont:self.lblDescription.font
                                                  constrainedToSize:(CGSize){self.lblDescription.frame.size.width, CGFLOAT_MAX}];
            }else {
                frame.size = [self.lblDescription.text boundingRectWithSize:CGSizeMake(self.lblDescription.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.lblDescription.font} context:nil].size;
            }
            frame.size.width = self.lblDescription.frame.size.width;
            frame.size.height += 10;
        }
        [self.lblDescription setFrame:frame];
        frame = viewDescription.frame;
        if (viewFacility.frame.size.height > 0) {
            frame.origin.y = viewFacility.frame.origin.y + viewFacility.frame.size.height + 5;
        }else {
            frame.origin.y = viewFacility.frame.origin.y;
        }
        if (self.lblDescription.frame.size.height > 0) {
            frame.size.height = self.lblDescription.frame.size.height + 24;
        }else {
            frame.size.height = 0;
        }
        [viewDescription setFrame:frame];
        frame = self.lblAddress.frame;
        if (self.lblAddress.attributedText.length <= 9) {
            frame.size.height = 0;
            [viewAddress setHidden:YES];
        }else {
            [viewAddress setHidden:NO];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                frame.size = [self.lblAddress.text sizeWithFont:self.lblAddress.font
             constrainedToSize:(CGSize){self.lblAddress.frame.size.width, CGFLOAT_MAX}];
            }else {
                 frame.size = [self.lblAddress.text boundingRectWithSize:CGSizeMake(self.lblAddress.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.lblAddress.font} context:nil].size;
            }
            frame.size.width = self.lblAddress.frame.size.width;
            frame.size.height += 10;
        }
        [self.lblAddress setFrame:frame];
        frame = viewAddress.frame;
        if (viewDescription.frame.size.height > 0) {
            frame.origin.y = viewDescription.frame.origin.y + viewDescription.frame.size.height + 5;
        }else {
            frame.origin.y = viewDescription.frame.origin.y;
        }
        if (self.lblAddress.frame.size.height > 0) {
            frame.size.height = self.lblAddress.frame.size.height + 24;
        }else {
            frame.size.height = 0;
        }
        [viewAddress setFrame:frame];
        pUserId = [NSString stringWithFormat:@"%@",propInfo.userid];
        self.dataView.contentSize = CGSizeMake(bounds.size.width , viewAddress.frame.origin.y + viewAddress.frame.size.height + 16);
        self.offerBtn.tag = [propInfo.propertyid intValue];
        [self.offerBtn addTarget:self action:@selector(onOfferBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void) doneGetPostInfo :(NSString*)data
{
    //CGRect bounds = [[UIScreen mainScreen] bounds];
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        NSDictionary *dic = [dataDict objectForKey:@"postinfo"];
    
        NSArray *imageList = (NSArray *)[dic objectForKey:@"images"];
        
        /*if (imageList.count > 0) {
            [self.imgPhoto setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",propertyImageUrl, [imageList objectAtIndex:0]]]];
        }*/
        CGRect bounds = [[UIScreen mainScreen] bounds];
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"ImageSlide" owner:self options:nil];
        self.imgPhotoView = (ImageSlide *)[nibArray objectAtIndex:0];
        [self.imgPhotoView setFrame:CGRectMake(0,0,bounds.size.width,183)];
        [self.imgPhotoView setImageList:imageList type:1];
        if ([[dic objectForKey:@"name"] isEqualToString:@""]) {
            self.lblName.text = [dic objectForKey:@"address1"];
        }else {
            self.lblName.text = [dic objectForKey:@"name"];
        }
        self.imgPhotoView.lblName.text =self.lblName.text;
        if (imageList.count <= 1) {
            [self.imgPhotoView.btnNext setHidden:YES];
            [self.imgPhotoView.btnPrev setHidden:YES];
        }else {
            [self.imgPhotoView.btnNext setHidden:NO];
            [self.imgPhotoView.btnPrev setHidden:NO];
        }
        [self.dataView addSubview:self.imgPhotoView];
        if ([[dic objectForKey:@"furnish_type"] intValue] == 1) {
            self.lblFurnish.text = [NSString stringWithFormat:@"RM%@/mo & Basic Unit",[dic objectForKey:@"rental"]];
        }else if ([[dic objectForKey:@"furnish_type"] intValue] == 2) {
            self.lblFurnish.text = [NSString stringWithFormat:@"RM%@/mo & Partial Furnished",[dic objectForKey:@"rental"]];
        }else if ([[dic objectForKey:@"furnish_type"] intValue] == 3) {
            self.lblFurnish.text = [NSString stringWithFormat:@"RM%@/mo & Fully Furnished",[dic objectForKey:@"rental"]];
        }
        
        if ([[dic objectForKey:@"type"] intValue] == 1) {
            self.lblType.text = @"Landed";
        }else if ([[dic objectForKey:@"type"] intValue] == 2) {
            self.lblType.text = @"High Rise";
        }
        if (![[dic objectForKey:@"photo"] isEqualToString:@""]) {
            [self.imgUserPhoto setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",profilePhotoUrl, [dic objectForKey:@"photo"]]]];
        }else {
            [self.imgUserPhoto setImage:[UIImage imageNamed:@"default_user.png"]];
        }
        
        UITapGestureRecognizer *labelNameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onNamePressed:)];
        self.lblUsername.tag = [[dic objectForKey:@"userid"] intValue];
        [self.lblUsername addGestureRecognizer:labelNameTap];
        
        self.lblUsername.text = [dic objectForKey:@"username"];
        self.lblSqft.text = [NSString stringWithFormat:@"%@ sqft", [dic objectForKey:@"sqft"]];
        if ([[dic objectForKey:@"rooms"] intValue] <= 0) {
            self.lblRooms.text = @"No Bedrooms";
        }else if ([[dic objectForKey:@"rooms"] intValue] == 1) {
            self.lblRooms.text = @"1 Bedroom";
        }else {
            self.lblRooms.text = [NSString stringWithFormat:@"%@ Bedrooms", [dic objectForKey:@"rooms"]];
        }
        self.lblToilets.text = [NSString stringWithFormat:@"%@ toilets", [dic objectForKey:@"toilets"]];
        self.lblParkings.text = [NSString stringWithFormat:@"%@ Parking Bays", [dic objectForKey:@"parkings"]];
        self.lblAvailability.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"availability"]];
        self.lblLatitude.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"latitude"]];
        self.lblLongitude.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"longitude"]];
        self.lblDescription.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"description"]];
        self.lblAddress.text = [NSString stringWithFormat:@"Address: %@", [dic objectForKey:@"address1"]];
        if ([dic objectForKey:@"address2"] != nil && ![[dic objectForKey:@"address2"] isEqualToString:@""]) {
            self.lblAddress.text = [NSString stringWithFormat:@"%@,%@",self.lblAddress.text,[dic objectForKey:@"address2"]];
        }
        if ([[dic objectForKey:@"like"] intValue] == 1) {
            [self.btnFavorite setImage:[UIImage imageNamed:@"favorite_btn1.png"] forState:UIControlStateNormal];
        }else {
            [self.btnFavorite setImage:[UIImage imageNamed:@"favorite_btn.png"] forState:UIControlStateNormal];
        }
        
        NSArray *furnishList = (NSArray *)[dic objectForKey:@"furnishes"];
        if (furnishList.count > 0) {
            CGRect frame = self.furnishView.frame;
            frame.size.height = (furnishList.count / 16 + 1) * 141;
            [self.furnishView setFrame:frame];
            for (int i = 0; i < furnishList.count; i++) {
                CGRect furnishRect = CGRectMake(10 + 80 * ((i % 16) / 4),10 + (i / 16) * 141 + 30 * (i % 4),70,30);
                UILabel *labelFurnish = [[UILabel alloc] initWithFrame:furnishRect];
                [labelFurnish setText:[furnishList objectAtIndex:i]];
                [labelFurnish setFont:[UIFont systemFontOfSize:12.0f]];
                [labelFurnish setTextColor:[UIColor grayColor]];
                [self.furnishView addSubview:labelFurnish];
            }
        }
        
        NSArray *facilityList = (NSArray *)[dic objectForKey:@"facilities"];
        if (facilityList.count > 0) {
            CGRect frame = self.facilityView.frame;
            frame.size.height = (facilityList.count / 9 + 1) * 102;
            [self.facilityView setFrame:frame];
            for (int i = 0; i < facilityList.count; i++) {
                CGRect facilityRect = CGRectMake(10 + 80 * ((i % 9) / 3),(i / 9) * 102 + 30 * (i % 3),70,30);
                UILabel *labelFacility = [[UILabel alloc] initWithFrame:facilityRect];
                [labelFacility setText:[facilityList objectAtIndex:i]];
                [labelFacility setFont:[UIFont systemFontOfSize:12.0f]];
                [labelFacility setTextColor:[UIColor grayColor]];
                [self.facilityView addSubview:labelFacility];
            }
        }
        self.offerBtn.tag = [[dic objectForKey:@"id"] intValue];
        [self.offerBtn addTarget:self action:@selector(onOfferBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property Details" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (void) onOfferBtnPressed:(UIButton *)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.pid = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    if (delegate.phone == nil || [delegate.phone isEqualToString:@""]) {
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Home" message:@"You've already offered this property" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Home" message:@"No such this property" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
}

- (void) doneGetOfferStatus :(NSString*)data
{
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"status"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property Details" message:@"You've already offered this property" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (void) onNamePressed :(UITapGestureRecognizer *)gesture
{
    if ([self.lblPrivacy.text intValue] == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property Details" message:@"This landlord's profile is private" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    /*UILabel *sender = (UILabel *)gesture.view;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.otheruserid = [NSString stringWithFormat:@"%ld",(long)sender.tag];*/
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profileViewController animated:YES];
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onFavoriteBtnPressed:(id)sender {
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.phone == nil || [delegate.phone isEqualToString:@""]) {
        delegate.forFavorite = @"1";
        delegate.forQA = @"0";
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
        [loginViewController.imgBack setImage:[UIImage imageNamed:@"phone_bg1.png"]];
        [loginViewController.imgBack setHidden:YES];
        [loginViewController.view addSubview:loginViewController.imgBack];
        [loginViewController.lblView addSubview:loginViewController.lblError];
        [loginViewController.scrollView addSubview:loginViewController.lblView];
        [loginViewController.view addSubview:loginViewController.scrollView];
        loginViewController.lblError.text = @"Ops, you have not registered or sign in to favourite this property. Signing in is quick, just enter your mobile number";
        [loginViewController.lblView setHidden:NO];
        delegate.afterControllerName = @"DetailPropertyViewController";
        [self.navigationController pushViewController:loginViewController animated:YES];
    }else {
        int fav = 0;
        if ([self.btnFavorite.imageView.image isEqual:[UIImage imageNamed:@"favorite_btn.png"]]) {
            [self.btnFavorite setImage:[UIImage imageNamed:@"favorite_btn1.png"] forState:UIControlStateNormal];
            fav = 1;
        }else {
            [self.btnFavorite setImage:[UIImage imageNamed:@"favorite_btn.png"] forState:UIControlStateNormal];
            fav = 0;
        }
        /*[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
        dispatch_async(myqueue, ^{
            NSString *reqString = [NSString stringWithFormat:@"%@?task=like&userid=%@&propertyid=%@&fav=%d", actionUrl,delegate.userid,delegate.pid,fav];
            reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:reqString];
            NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
            [self performSelectorOnMainThread:@selector(doneLike:) withObject:strData waitUntilDone:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });*/
        NSManagedObjectContext *context = delegate.managedObjectContext;
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        //Get Property Data
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"propertyid='%@'",delegate.pid]]];
        NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
        [fetchRequest setEntity:propEntity];
        NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        //Get Favorite Data
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@' and propertyid='%@'",delegate.userid,delegate.pid]]];
        NSEntityDescription *favEntity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:context];
        [fetchRequest setEntity:favEntity];
        NSArray *favObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (fav == 0) {
            for (Favorites *favObject in favObjects) {
                [context deleteObject:favObject];
            }
        }else {
            if (favObjects.count == 0) {
                if (propObjects.count > 0) {
                    Property *propObject = (Property *)[propObjects objectAtIndex:0];
                    Favorites *favObject = [NSEntityDescription insertNewObjectForEntityForName:@"Favorites" inManagedObjectContext:context];
                    favObject.userid = [NSNumber numberWithInt:[delegate.userid intValue]];
                    favObject.propertyid = [NSNumber numberWithInt:[delegate.pid intValue]];
                    [propObject addFavoritesInfoObject:favObject];
                    [delegate saveContext];
                }
            }
        }

    }
}

- (IBAction)onMapBtnPressed:(id)sender {
    if (self.mapView.isHidden) {
        if (mapView_ == nil) {
            //NSLog(@"%@,%@",self.lblLatitude.text, self.lblLongitude.text);
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:15 bearing:0 viewingAngle:180];
            mapView_ = [GMSMapView mapWithFrame:self.mapView.bounds camera:camera];
            mapView_.myLocationEnabled = YES;
            self.mapView.layer.borderColor = [[UIColor grayColor] CGColor];
            self.mapView.layer.borderWidth = 1.0f;
            [self.mapView addSubview: mapView_];
        
            // Creates a marker in the center of the map.
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(latitude, longitude);
            marker.title = self.lblName.text;
            marker.map = mapView_;
        }
        [self.mapView setHidden:NO];
        [self.btnMap setImage:[UIImage imageNamed:@"image_btn.png"] forState:UIControlStateNormal];
        [self.imgPhotoView setHidden:YES];
    }else {
        [self.mapView setHidden:YES];
        [self.btnMap setImage:[UIImage imageNamed:@"map_btn.png"] forState:UIControlStateNormal];
        [self.imgPhotoView setHidden:NO];
    }
}

- (IBAction)onQABtnPressed:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.phone == nil || [delegate.phone isEqualToString:@""]) {
        delegate.forQA = @"1";
        delegate.forFavorite = @"0";
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
        [loginViewController.imgBack setImage:[UIImage imageNamed:@"phone_bg1.png"]];
        [loginViewController.imgBack setHidden:YES];
        [loginViewController.view addSubview:loginViewController.imgBack];
        [loginViewController.lblView addSubview:loginViewController.lblError];
        [loginViewController.scrollView addSubview:loginViewController.lblView];
        [loginViewController.view addSubview:loginViewController.scrollView];
        loginViewController.lblError.text = @"Ops, you have not registered or sign in to ask a question. Signing in is quick, just enter your mobile number";
        [loginViewController.lblView setHidden:NO];
        delegate.afterControllerName = @"DetailPropertyViewController";
        [self.navigationController pushViewController:loginViewController animated:YES];
        return;
    }else {
        [delegate.dataModel setPUserId: delegate.userid];
        [delegate.dataModel setDeviceToken:delegate.deviceToken];
        [delegate.dataModel setMessageType:@"Chat"];
        [delegate.dataModel setPropertyId: delegate.pid];
        delegate.userType = @"1";
        [delegate.dataModel setNickname:[delegate.username stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self postJoinRequest];
    }
}

- (IBAction)onShareBtnPressed:(id)sender {
    
    NSArray *activityItems = nil;
    UIImageView *_postImage = nil;
    for (int i = 0; i < self.imgPhotoView.imgView.subviews.count; i++) {
        UIImageView *imgView = [self.imgPhotoView.imgView.subviews objectAtIndex:i];
        if (imgView.frame.origin.x == 0) {
            _postImage = imgView;
        }
    }
    NSString *shareMsg = @"";
    if (self.lblAddress.text != nil && ![self.lblAddress.text isEqualToString:@""]) {
        shareMsg = [NSString stringWithFormat:@"This house[%@] is awesome. check it out at SAYWA.my",[self.lblAddress.text substringFromIndex:9]];
    }else {
        shareMsg = @"This house is awesome. check it out at SAYWA.my";
    }
    if (_postImage != nil && _postImage.image != nil) {
        activityItems = @[shareMsg, _postImage.image];
    } else {
        activityItems = @[shareMsg];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void) doneLike :(NSString*)data
{
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property Details" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (void) doneLike1 :(NSString*)data
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [self getPostInfo];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Home" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (void)postJoinRequest {
	//MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	//hud.labelText = NSLocalizedString(@"Connecting", nil);
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverActionUrl]];
    NSDictionary *params = @{@"task":@"joinChat",
                             @"deviceToken":[delegate.dataModel deviceToken],
                             @"p_user_id":pUserId,
                             @"user_type":@"2",
                             @"propertyid":delegate.pid};
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
    if ([self.lblType.text isEqualToString:@"Landed"]) {
        if (self.lblAddress.text != nil && ![self.lblAddress.text isEqualToString:@""]) {
            delegate.pname = [self.lblAddress.text substringFromIndex:8];
        }else {
            delegate.pname = @"";
        }
    }else {
        delegate.pname = self.lblName.text;
    }
    [self.navigationController pushViewController:askOwnerViewController animated:YES];
}

@end
