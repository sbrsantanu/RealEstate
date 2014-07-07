//
//  PostEditViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@class OutImageSlider;

@interface PostEditViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate> {
    
    
    IBOutlet UIView *viewMeetingTime;
    IBOutlet UIView *viewPropertyDescription;
    IBOutlet UIView *viewPhoto;
    IBOutlet UIView *viewFurnish;
    IBOutlet UIView *viewFacility;
    IBOutlet UIView *viewPropertyDetail;
    IBOutlet UIView *viewPropertyCommon;
    IBOutlet UIView *viewFiltering;
    
    UITableView *yearView;
    UITableView *monthView;
    UITableView *dateView;
    UITableView *propView;
    
    UITableView *criteriaAgeView;
    UITableView *criteriaRaceView;
    UITableView *criteriaNationalityView;
    
    
    NSMutableArray *normalFurnishList;
    NSMutableArray *normalFacilityList;
    NSMutableArray *nationalityList;
    NSMutableArray *raceList;
    UITextField *activeField;
    UITextView *activeView;
    UIImagePickerController *photoPicker;
    
    //Camera View
    
    IBOutlet UIView *cameraView;
    IBOutlet UIView *cameraNavView;
    IBOutlet UIView *cameraBtnView;
    
    IBOutlet UIImageView *tempCameraView;
    
    int curNumImage;
    BOOL isCameraOn;
    BOOL isTaken;
    
    CGFloat lastScrollOffset;
    
    NSMutableArray *curPropList;
    NSMutableArray *propList;
    NSDate *prefertimestart;
}
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIView *labelView;
@property (strong, nonatomic) IBOutlet UILabel *lblPropertyName;
@property (strong, nonatomic) IBOutlet UIView *viewYear;
@property (strong, nonatomic) IBOutlet UIView *viewMonth;
@property (strong, nonatomic) IBOutlet UIView *viewDate;

@property (strong, nonatomic) IBOutlet UILabel *lblNationality;
@property (strong, nonatomic) IBOutlet UILabel *lblRace;
@property (strong, nonatomic) IBOutlet UIView *viewCriteriaAge;
@property (strong, nonatomic) IBOutlet UIView *viewCriteriaRace;
@property (strong, nonatomic) IBOutlet UIView *viewCriteriaNationality;

@property (strong, nonatomic) IBOutlet UIScrollView *dataView;
@property (strong, nonatomic) IBOutlet UIView *timeView;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress1;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress2;
@property (strong, nonatomic) IBOutlet UITextField *txtZipcode;
@property (strong, nonatomic) IBOutlet UITextField *txtRentals;
@property (strong, nonatomic) IBOutlet UITextField *txtSqft;
@property (strong, nonatomic) IBOutlet UIView *imgArea;
@property (strong, nonatomic) IBOutlet UIView *furnishView;
@property (strong, nonatomic) IBOutlet UIView *facilityView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segType;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRooms;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segToilets;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segParking;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segFurnish;
@property (strong, nonatomic) IBOutlet UIView *furnishShape;
@property (strong, nonatomic) IBOutlet UILabel *lblFurnishOthers;
@property (strong, nonatomic) IBOutlet UIView *facilityShape;
@property (strong, nonatomic) IBOutlet UILabel *lblFacilityOthers;
@property (strong, nonatomic) IBOutlet UITextField *txtFurnishOthers;
@property (strong, nonatomic) IBOutlet UITextField *txtFacilityOthers;
@property (strong, nonatomic) IBOutlet UIView *furnishOtherView;
@property (strong, nonatomic) IBOutlet UIView *facilityOtherView;
@property (strong, nonatomic) IBOutlet UILabel *lblYear;
@property (strong, nonatomic) IBOutlet UILabel *lblMonth;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblCriteriaAge;
@property (strong, nonatomic) IBOutlet UILabel *lblCriteriaRace;
@property (strong, nonatomic) IBOutlet UILabel *lblCriteriaNationality;
@property (strong, nonatomic) IBOutlet OutImageSlider *imgPhotoView;

@property (nonatomic,strong) UIViewController *prevViewController;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UILabel *lblUnit;
@property (strong, nonatomic) IBOutlet UITextField *txtUnit;
@property (strong, nonatomic) IBOutlet UILabel *lblType;
@property (strong, nonatomic) IBOutlet UIView *viewAvailable;
@property (strong, nonatomic) IBOutlet UIView *viewUnavailable;
@property (strong, nonatomic) IBOutlet UIView *imgAvailable;
@property (strong, nonatomic) IBOutlet UIView *imgUnavailable;

- (IBAction)onAddOtherFurnishBtnPressed:(id)sender;
- (IBAction)onAddOtherFacilityBtnPressed:(id)sender;

- (void) setEnable:(BOOL)enable;
- (IBAction)onBackBtnPressed:(id)sender;
- (IBAction)onSaveBtnPressed:(id)sender;
- (IBAction)onYearBtnPressed:(id)sender;
- (IBAction)onDateBtnPressed:(id)sender;
- (IBAction)onMonthBtnPressed:(id)sender;
- (IBAction)onFurnishPressed:(id)sender;
- (IBAction)onSkipBtnPressed:(id)sender;
- (IBAction)onCriteriaAgeBtnPressed:(id)sender;
- (IBAction)onCriteriaRaceBtnPressed:(id)sender;
- (IBAction)onCriteriaNationalityBtnPressed:(id)sender;
- (IBAction)onMorePhotoBtnPressed:(id)sender;
- (IBAction)onTakeBtnPressed:(id)sender;
- (IBAction)onLibraryBtnPressed:(id)sender;
- (IBAction)onDoneBtnPressed:(id)sender;
- (IBAction)onTypeChanged:(id)sender;
- (IBAction)onNameChanged:(id)sender;

@end
