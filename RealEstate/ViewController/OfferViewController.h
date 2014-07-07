//
//  OfferViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@class OfferConfirmViewController,DataModel, AFHTTPClient;

@interface OfferViewController : UIViewController <UITextFieldDelegate,MFMailComposeViewControllerDelegate> {
    //OfferConfirmViewController *offerConfirmViewController;
    UIColor *noSelColor;
    UIColor *selColor;
    IBOutlet UIScrollView *mainView1;
    IBOutlet UIScrollView *mainView2;
    IBOutlet UIScrollView *mainView3;
    IBOutlet UIView *navView;
    NSMutableArray *weekdayStr;
    IBOutlet UIButton *btnSelMark;
    NSDate *prefertimestart;
}

- (void)setEnable:(BOOL)enable;
- (IBAction)onBackBtnPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *lblTenantTime;

@property (strong, nonatomic) IBOutlet UIButton *lblLandTime;
@property (nonatomic, assign) DataModel* dataModel;
@property (nonatomic, assign) AFHTTPClient *client;

@property (strong, nonatomic) IBOutlet UILabel *lblPropertyName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblList;
@property (strong, nonatomic) IBOutlet UIButton *btnTerm1;
@property (strong, nonatomic) IBOutlet UIButton *btnTerm2;
@property (strong, nonatomic) IBOutlet UITextField *txtOffer;
@property (strong, nonatomic) IBOutlet UIView *timeView;
@property (strong, nonatomic) IBOutlet UIScrollView *offerView;
@property (strong, nonatomic) IBOutlet UIView *timeView1;
@property (strong, nonatomic) IBOutlet UILabel *lblOffer;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UIButton *btnSearchMore;
@property (strong, nonatomic) IBOutlet UIImageView *imgGroupPhoto;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) UIViewController *prevViewController;
@property (strong, nonatomic) IBOutlet UILabel *lblDone;
@property (strong, nonatomic) IBOutlet UIButton *btnSetMore;
@property (strong, nonatomic) IBOutlet UIView *viewLandTime;
@property (strong, nonatomic) IBOutlet UIView *imgLandTime;
@property (strong, nonatomic) IBOutlet UIView *viewSelTime;
@property (strong, nonatomic) IBOutlet UIView *imgSelTime;

- (IBAction)onTermBtn1Pressed:(id)sender;
- (IBAction)onTermBtn2Pressed:(id)sender;
- (IBAction)onSearchMoreBtnPressed:(id)sender;

- (IBAction)onNextBtnPressed:(id)sender;
- (IBAction)onFacebookBtnPressed:(id)sender;
- (IBAction)onTwitterBtnPressed:(id)sender;
- (IBAction)onPhoneBtnPressed:(id)sender;
- (IBAction)onQuickerBtnPressed:(id)sender;

@end
