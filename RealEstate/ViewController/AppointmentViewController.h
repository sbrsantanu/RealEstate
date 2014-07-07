//
//  AppointmentViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate> {
    NSMutableArray *appList;
    UITextField *activeField;
    NSIndexPath *delIndexPath;
}
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIView *subView;

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) IBOutlet UIButton *btnAll;
@property (strong, nonatomic) IBOutlet UIButton *btnToday;
@property (strong, nonatomic) IBOutlet UIButton *btnTomorrow;
@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (strong, nonatomic) UILabel *noLabel;

@property (nonatomic,strong) UIViewController *prevViewController;

- (void)setEnable:(BOOL)enable;

- (IBAction)onBackBtnPressed:(id)sender;
- (IBAction)onAllBtnPressed:(id)sender;
- (IBAction)onTodayBtnPressed:(id)sender;
- (IBAction)onTomorrowBtnPressed:(id)sender;

@end
