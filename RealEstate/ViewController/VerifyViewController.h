//
//  VerifyViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/12/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyViewController : UIViewController <UITextFieldDelegate> {
    UITextField *activeField;
}

@property (nonatomic, strong) UIToolbar *keyboardToolbar;
@property (strong, nonatomic) IBOutlet UITextField *txtVerifyCode;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIView *navView;

- (IBAction)onBackBtnPressed:(id)sender;
- (IBAction)onNextBtnPressed:(id)sender;

@end
