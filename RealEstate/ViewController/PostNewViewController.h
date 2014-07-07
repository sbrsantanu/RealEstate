//
//  PostNewViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/12/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class PostPhotoViewController;

@interface PostNewViewController : UIViewController <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate, MFMailComposeViewControllerDelegate> {
    
    //PreSet Basic Parameter
    IBOutlet UIScrollView *mainView1;
    
    UITableView *yearView;
    UITableView *monthView;
    UITableView *dateView;
    
    UITableView *propView;
    
    NSMutableArray *curPropList;
    NSMutableArray *propList;
    
    PostPhotoViewController *postPhotoViewController;
    UIImagePickerController *photoPicker;
    
    NSMutableData *resData;
    NSMutableArray *normalFurnishList;
    NSMutableArray *normalFacilityList;
    UITextField *activeField;
    
    //Navigation Bar
    IBOutlet UIView *navView;
    
    //Camera View
    IBOutlet UIView *cameraView;
    
    //Final Set Basic Parameter
    IBOutlet UIScrollView *mainView2;
    IBOutlet UITextField *txtName;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblUnit;
    IBOutlet UITextField *txtUnit;
    IBOutlet UISegmentedControl *segType;
    IBOutlet UISegmentedControl *segRooms;
    IBOutlet UISegmentedControl *segToilets;
    IBOutlet UISegmentedControl *segParkings;
    IBOutlet UITextField *txtSqft;
    
    IBOutlet UIView *viewYear;
    IBOutlet UILabel *lblYear;
    
    IBOutlet UIView *viewMonth;
    IBOutlet UILabel *lblMonth;
    
    IBOutlet UIView *viewDate;
    IBOutlet UILabel *lblDate;
    
    IBOutlet UITextField *txtRental;
    IBOutlet UISegmentedControl *segFurnish;
    IBOutlet UITextField *txtAddress1;
    IBOutlet UILabel *lblAddress;
    IBOutlet UITextField *txtAddress2;
    IBOutlet UITextField *txtZipcode;
    IBOutlet UILabel *lblZipcode;
    IBOutlet UILabel *lblType;
    
    //Success View
    IBOutlet UIScrollView *mainView3;
    
    //More Settings View
    IBOutlet UIScrollView *mainView4;
    
    //Camera Overlay View
    IBOutlet UIView *cameraNavView;
    IBOutlet UIView *cameraTopBlankView;
    IBOutlet UIView *cameraBottomBlankView;
    IBOutlet UIView *cameraBtnView;
    IBOutlet UIView *viewTerms;
    
    IBOutlet UIImageView *tempCameraView;
    
    int roomNumber;
    int toiletNumber;
    int numPhoto;
}

@property (strong, nonatomic) IBOutlet UIView *imgCameraView;
@property (strong, nonatomic) IBOutlet UILabel *lblRoomNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) UIViewController *prevViewController;
@property (strong, nonatomic) IBOutlet UIImageView *imgGroupPhoto;

- (IBAction)onNameChanged:(id)sender;
- (IBAction)onBackBtnPressed:(id)sender;
- (IBAction)onNextBtnPressed:(id)sender;
- (IBAction)onYearBtnPressed:(id)sender;
- (IBAction)onMonthBtnPressed:(id)sender;
- (IBAction)onDateBtnPressed:(id)sender;
- (IBAction)onSaveBtnPressed:(id)sender;
- (IBAction)onTakeBtnPressed:(id)sender;
- (IBAction)onLibraryBtnPressed:(id)sender;
- (IBAction)onFacebookBtnPressed:(id)sender;
- (IBAction)onTwitterBtnPressed:(id)sender;
- (IBAction)onPhoneBtnPressed:(id)sender;
- (IBAction)onSkipBtnPressed:(id)sender;
- (IBAction)onAttractBtnPressed:(id)sender;
- (IBAction)onOkBtnPressed:(id)sender;
- (IBAction)onTypeSelected:(id)sender;

- (void) setEnable:(BOOL)enable;

@end
