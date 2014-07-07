//
//  MenuCell.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCellContentWith:(long) type
{
    //[lblTitle setFont:[UIFont fontWithName:@"GothaHTFXLigIta" size:19]];
    //UIFontDescriptor * fontD = [lblTitle.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    //lblTitle.font = [UIFont fontWithDescriptor:fontD size:19];
    [self.lblTitle setFont:[UIFont fontWithName:@"Gotham HTF" size:19]];
    NSArray *menuItems = [[NSArray alloc] initWithObjects:
                          @{@"name":@"PROFILE", @"path":@"profile_btn.png"},
                          @{@"name":@"POSTS", @"path":@"post_btn.png"},
                          @{@"name":@"OFFERS", @"path":@"offer_btn.png"},
                          @{@"name":@"APPOINTMENTS", @"path":@"appoint_btn.png"},
                          @{@"name":@"FAVOURITE", @"path":@"favorite_menu.png"},
                          @{@"name":@"NOTIFICATION", @"path":@"notification_btn.png"},nil];
    if (type != 0) {
        [self.lblTitle setText:[[menuItems objectAtIndex:type] valueForKey:@"name"]];
    }
    
    [self.imgMenu setImage:[UIImage imageNamed:[[menuItems objectAtIndex:type] valueForKey:@"path"]]];
}

@end
