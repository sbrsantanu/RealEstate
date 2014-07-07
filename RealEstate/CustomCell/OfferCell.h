//
//  OfferCell.h
//  RealEstate
//
//  Created by XueSongLu on 3/8/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface OfferCell : UITableViewCell

@property (strong, nonatomic) IBOutlet AsyncImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lblOfferText;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segStatus;
@property (strong, nonatomic) IBOutlet UITextView *txtReason;
@property (strong, nonatomic) IBOutlet UIButton *btnInfo;


@end
