//
//  LoginViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/12/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VerifyViewController;

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    UITextField *activeField;
    IBOutlet UIView *viewStatusBar;
}

@property (strong, nonatomic) IBOutlet UIImageView *imgMask;
@property (strong, nonatomic) IBOutlet UILabel *lblError;
@property (strong, nonatomic) IBOutlet UITextField *txtPrefix;
@property (strong, nonatomic) IBOutlet UIView *lblView;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtSpace;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIViewController *prevViewController;
@property (strong, nonatomic) NSString *afterControllerName;
@property (strong, nonatomic) IBOutlet UIImageView *imgBack;
@property (strong, nonatomic) IBOutlet UIButton *btnSkip;
- (IBAction)onJoinBtnPressed:(id)sender;
- (IBAction)onSkipBtnPressed:(id)sender;

@end
