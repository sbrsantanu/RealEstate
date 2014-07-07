//
//  ProfileViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@class ProfileEditViewController;

@interface ProfileViewController : UIViewController

- (void)setEnable:(BOOL)enable;
- (IBAction)onBackBtnPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblAge;
@property (strong, nonatomic) IBOutlet UILabel *lblNationality;
@property (strong, nonatomic) IBOutlet UILabel *lblRace;
@property (strong, nonatomic) IBOutlet UILabel *lblOccupation;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;

@property (strong, nonatomic) IBOutlet AsyncImageView *imgPhoto;

- (IBAction)onEditBtnPressed:(id)sender;

- (void) getProfileInfo;

@end


