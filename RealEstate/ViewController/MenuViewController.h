//
//  MenuViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class HomeViewController;
@class ProfileViewController;
@class PostViewController;
@class OfferListViewController;
@class AppointmentViewController;
@class FavoritesViewController;

@interface MenuViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *navView;
@property (nonatomic, strong) IBOutlet UITableView *tblMenu;
@property (nonatomic, strong) UIViewController *prevViewController;

@property (nonatomic, strong) NSString *option;
- (IBAction)onLogoPressed:(id)sender;

- (void) setEnable:(BOOL)enable;

@end
