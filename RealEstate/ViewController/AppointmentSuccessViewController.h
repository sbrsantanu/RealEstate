//
//  AppointmentSuccessViewController.h
//  RealEstate
//
//  Created by Sol.S on 4/11/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentSuccessViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *btnSearchMore;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
- (IBAction)onFacebookBtnPressed:(id)sender;
- (IBAction)onTwitterBtnPressed:(id)sender;
- (IBAction)onPhoneBtnPressed:(id)sender;
- (IBAction)onDoneBtnPressed:(id)sender;
- (IBAction)onSearchMoreBtnPressed:(id)sender;

@end
