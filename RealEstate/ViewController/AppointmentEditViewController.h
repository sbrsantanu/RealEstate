//
//  AppointmentEditViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentEditViewController : UIViewController {
    
    IBOutlet UITableView *tblList;
    NSMutableArray *timeList;
}
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIView *labelView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) UIViewController *prevViewController;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

- (IBAction)onBackBtnPressed:(id)sender;
- (IBAction)onConfirmBtnPressed:(id)sender;

@end
