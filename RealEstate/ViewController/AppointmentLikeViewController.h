//
//  AppointmentLikeViewController.h
//  RealEstate
//
//  Created by Sol.S on 4/14/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentLikeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *btnAgree;
@property (strong, nonatomic) IBOutlet UIButton *btnDisagree;
- (IBAction)onAgreeBtnPressed:(id)sender;
- (IBAction)onDisagreeBtnPressed:(id)sender;


@end
