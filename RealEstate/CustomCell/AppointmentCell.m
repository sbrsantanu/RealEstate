//
//  AppointmentCell.m
//  RealEstate
//
//  Created by XueSongLu on 3/9/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "AppointmentCell.h"

@implementation AppointmentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CALayer *imageLayer = self.imgPhoto.layer;
        [imageLayer setCornerRadius:18];
        [imageLayer setBorderWidth:1];
        [imageLayer setMasksToBounds:YES];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onCloseBtnPressed:(id)sender {
    [self.viewInfo setHidden:YES];
}
@end
