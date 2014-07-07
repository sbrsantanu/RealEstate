//
//  RateViewController.h
//  RealEstate
//
//  Created by Sol.S on 4/14/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *btnRate;
@property (strong, nonatomic) IBOutlet UIButton *btnRateLater;
- (IBAction)onRateBtnPressed:(id)sender;
- (IBAction)onLaterBtnPressed:(id)sender;

@end
