//
//  OfferListViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferListViewController : UIViewController <UIAlertViewDelegate,UITextFieldDelegate> {
    NSMutableArray *offerList;
    IBOutlet UITableView *tblList;
    int option;
    int suboption;
    NSMutableArray *newOfferList;
    NSMutableArray *waitingOfferList;
    NSMutableArray *odeclineOfferList;
    NSMutableArray *pdeclineOfferList;
    NSMutableArray *declineOfferList;
    UITextField *activeField;
}
@property (strong, nonatomic) UILabel *noLabel;
@property (strong, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIButton *badgeNewBtn;
@property (nonatomic,strong) UIViewController *prevViewController;

@property (strong, nonatomic) IBOutlet UIButton *badgeDeclineBtn;
@property (strong, nonatomic) IBOutlet UIButton *btnNew;
@property (strong, nonatomic) IBOutlet UIButton *btnWaiting;
@property (strong, nonatomic) IBOutlet UIButton *btnDecline;

- (void)setEnable:(BOOL)enable;
- (IBAction)onBackBtnPressed:(id)sender;
- (IBAction)onNewBtnPressed:(id)sender;
- (IBAction)onWaitingBtnPressed:(id)sender;
- (IBAction)onDeclineBtnPressed:(id)sender;

@end
