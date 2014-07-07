//
//  MenuCell.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MenuCellHome = 0,
    MenuCellProfile = 1,
    MenuCellPost = 2,
    MenuCellOffer = 3,
    MenuCellAppointment = 4,
    MenuCellFavorite = 5,
} MenuCellType;

@interface MenuCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView *imgMenu;
@property (nonatomic,strong) IBOutlet IBOutlet UILabel *lblTitle;

- (void) setCellContentWith:(long) type;

@end
