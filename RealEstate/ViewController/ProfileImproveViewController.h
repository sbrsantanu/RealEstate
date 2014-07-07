//
//  ProfileImproveViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/30/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileImproveViewController : UIViewController {
    IBOutlet UITableView *tblList;
    NSMutableArray * postList;
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblDescription;
}
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIScrollView *mainView;
@property (strong, nonatomic) UIViewController *afterViewController;
@property (strong, nonatomic) UIViewController *prevViewController;
- (IBAction)onBackBtnPressed:(id)sender;
- (IBAction)onDoneBtnPressed:(id)sender;

@end
