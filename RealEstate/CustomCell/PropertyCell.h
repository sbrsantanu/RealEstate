//
//  PropertyCell.h
//  RealEstate
//
//  Created by XueSongLu on 3/8/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface PropertyCell : UITableViewCell <UIScrollViewDelegate> {
    
    NSString *propertyId;
    NSArray *imagesArray;
    NSMutableArray *curImages;
    long totalPage;
    long curPage;
    int type;
    CGRect bounds;
}

@property (strong, nonatomic) IBOutlet UIButton *btnPrev;

@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblFurnish;
@property (nonatomic, strong) IBOutlet UILabel *lblType;
@property (nonatomic, strong) IBOutlet UILabel *lblSize;
@property (nonatomic, strong) IBOutlet UILabel *lblRooms;
@property (nonatomic, strong) IBOutlet UILabel *lblAvailability;
@property (strong, nonatomic) IBOutlet UILabel *lblImgNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnFavorite;
@property (strong, nonatomic) IBOutlet UIButton *btnOffer;
@property (strong, nonatomic) IBOutlet UIScrollView *imgView;

- (NSArray *)getDisplayImagesWithCurpage:(long)page;
- (void)refreshScrollView;

- (IBAction)onNextBtnPressed:(id)sender;
- (IBAction)onPrevBtnPressed:(id)sender;

- (void) setPropertyDetail: (int)pid pictures:(NSArray *)pictureArray type:(int)imageType;
@end
