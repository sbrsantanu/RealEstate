//
//  DetailPropertyViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import "AsyncImageView.h"

@class AFHTTPClient;
@class DataModel;
@class  ImageSlide;
@interface DetailPropertyViewController : UIViewController <CLLocationManagerDelegate,UIActionSheetDelegate> {
    
    IBOutlet UIView *viewUser;
    IBOutlet UIView *viewRental;
    IBOutlet UIView *viewFurnish;
    IBOutlet UIView *viewCommon;
    IBOutlet UIView *viewFurnishType;
    IBOutlet UIView *viewFacility;
    IBOutlet UIView *viewDescription;
    IBOutlet UIView *viewAddress;
    NSString *pUserId;
    double longitude;
    double latitude;
}

@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblPrivacy;

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblOthers;
@property (strong, nonatomic) IBOutlet UIScrollView *dataView;
@property (strong, nonatomic) IBOutlet AsyncImageView *imgUserPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lblUsername;
@property (strong, nonatomic) IBOutlet UILabel *lblFurnish;
@property (strong, nonatomic) IBOutlet UILabel *lblType;
@property (strong, nonatomic) IBOutlet UILabel *lblSqft;
@property (strong, nonatomic) IBOutlet UILabel *lblRooms;
@property (strong, nonatomic) IBOutlet UILabel *lblToilets;
@property (strong, nonatomic) IBOutlet UILabel *lblParkings;
@property (strong, nonatomic) IBOutlet UILabel *lblAvailability;
@property (strong, nonatomic) IBOutlet UILabel *lblLongitude;
@property (strong, nonatomic) IBOutlet UILabel *lblLatitude;
@property (strong, nonatomic) IBOutlet UIView *furnishView;
@property (strong, nonatomic) IBOutlet UIView *facilityView;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;
@property (strong, nonatomic) IBOutlet UITextView *txtAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnFavorite;
@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *offerBtn;
@property (strong, nonatomic) UIViewController *prevViewController;
@property (strong, nonatomic) IBOutlet UIButton *btnMap;
@property (strong, nonatomic) IBOutlet ImageSlide *imgPhotoView;
@property (strong, nonatomic) IBOutlet UILabel *lblRental;

- (void) setEnable:(BOOL)enable;
- (IBAction)onBackBtnPressed:(id)sender;
- (IBAction)onFavoriteBtnPressed:(id)sender;
- (IBAction)onMapBtnPressed:(id)sender;
- (IBAction)onQABtnPressed:(id)sender;
- (IBAction)onShareBtnPressed:(id)sender;

@end
