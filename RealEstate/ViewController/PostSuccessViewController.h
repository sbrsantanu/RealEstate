//
//  PostSuccessViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/13/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PostSuccessViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgGroupPhoto;
- (IBAction)onDoneBtnPressed:(id)sender;
- (IBAction)onBackBtnPressed:(id)sender;
- (IBAction)onFacebookBtnPressed:(id)sender;
- (IBAction)onTwitterBtnPressed:(id)sender;
- (IBAction)onPhoneBtnPressed:(id)sender;

@end
