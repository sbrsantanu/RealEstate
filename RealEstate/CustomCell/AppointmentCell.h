//
//  AppointmentCell.h
//  RealEstate
//
//  Created by XueSongLu on 3/9/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface AppointmentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet AsyncImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lblUsername;
@property (strong, nonatomic) IBOutlet UILabel *lblAppTime;
@property (strong, nonatomic) IBOutlet UIButton *btnReschedule;
@property (assign, nonatomic) int appointid;
@property (strong, nonatomic) IBOutlet UIButton *btnInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblContact;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UIView *viewInfo;
@property (strong, nonatomic) NSString *contactNumber;
@property (strong, nonatomic) NSString *contactAddress;
@property (strong, nonatomic) NSMutableDictionary *contactLoc;
- (IBAction)onCloseBtnPressed:(id)sender;

@end
