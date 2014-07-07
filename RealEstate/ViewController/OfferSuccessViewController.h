//
//  OfferSuccessViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferSuccessViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *mainView;
@property (strong, nonatomic) IBOutlet UIImageView *imgGroupPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lblPropertyName;
@property (strong, nonatomic) IBOutlet UIButton *btnSearchMore;
@property (strong, nonatomic) IBOutlet UIButton *btnGetQucker;

- (IBAction)onBackBtnPressed:(id)sender;
- (IBAction)onSearchMoreBtnPressed:(id)sender;
- (void) setEnable:(BOOL)enable;

@end
