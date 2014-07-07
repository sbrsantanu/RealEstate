//
//  ProfileEditViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AsyncImageView.h"

@interface ProfileEditViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource> {
    UITableView *yearView;
    UITableView *monthView;
    UITableView *dateView;
    UITableView *nationView;
    UITableView *raceView;
    NSMutableData *resData;
    UITextField *activeField;
    int point;
    NSMutableArray *nationList;
    NSMutableArray *raceList;
    int post_count;
    int offer_count;
    IBOutlet UIView *cameraOverlayView;
    UIImagePickerController *photoPicker;
    BOOL isBack;
    BOOL isChanged;
    CGFloat lastScrollOffset;
}

@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIView *labelView;
@property (strong, nonatomic) IBOutlet AsyncImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UITextField *txtName;

@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblYear;
@property (strong, nonatomic) IBOutlet UILabel *lblMonth;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIView *viewYear;
@property (strong, nonatomic) IBOutlet UIView *viewMonth;
@property (strong, nonatomic) IBOutlet UIView *viewDate;
@property (strong, nonatomic) IBOutlet UIScrollView *mainView;
@property (strong, nonatomic) IBOutlet UITextField *txtLocation;
@property (strong, nonatomic) IBOutlet UITextField *txtOccupation;
@property (strong, nonatomic) IBOutlet UILabel *lblNationality;
@property (strong, nonatomic) IBOutlet UILabel *lblRace;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segPrivacy;
@property (strong, nonatomic) UIViewController *prevViewController;

@property(nonatomic,assign)id delegate;

- (IBAction)onDoneBtnPressed:(id)sender;

- (IBAction)onBackBtnPressed:(id)sender;
- (IBAction)onSkipBtnPressed:(id)sender;

- (void)setEnable:(BOOL)enable;
- (IBAction)onYearBtnPressed:(id)sender;
- (IBAction)onMonthBtnPressed:(id)sender;
- (IBAction)onDateBtnPressed:(id)sender;
- (IBAction)onNationBtnPressed:(id)sender;
- (IBAction)onRaceBtnPressed:(id)sender;
- (IBAction)onLibraryBtnPressed:(id)sender;
- (IBAction)onTakeBtnPressed:(id)sender;
- (IBAction)onCameraBackBtnPressed:(id)sender;
- (IBAction)onPrivacyChanged:(id)sender;

- (void) getProfileInfo;

@end
