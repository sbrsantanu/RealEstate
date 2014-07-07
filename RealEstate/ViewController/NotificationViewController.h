//
//  NotificationViewController.h
//  RealEstate
//
//  Created by Sol.S on 5/24/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController <UITableViewDataSource, UITableViewDataSource> {
    NSMutableArray *notificationList;
    NSMutableArray *curNotificationList;
    int selectedItem;
    CGFloat lastScrollOffset;
}
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UIButton *btnAll;
@property (strong, nonatomic) IBOutlet UIButton *btnToday;
@property (strong, nonatomic) IBOutlet UIButton *btnPast;
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UIView *subView;

- (IBAction)onBackBtnPressed:(id)sender;
- (IBAction)onTypeBtnPressed:(id)sender;


@end
