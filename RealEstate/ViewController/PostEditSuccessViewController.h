//
//  PostEditSuccessViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/20/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface PostEditSuccessViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblPropertyName;
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)getAdPostedBtnPressed:(id)sender;
- (IBAction)onSkipBtnPressed:(id)sender;
- (IBAction)onBackBtnPressed:(id)sender;
- (IBAction)onPhoneBtnPressed:(id)sender;
- (IBAction)onTwitterBtnPressed:(id)sender;
- (IBAction)onFacebookBtnPressed:(id)sender;

@end
