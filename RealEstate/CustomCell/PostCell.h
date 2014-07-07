//
//  PostCell.h
//  RealEstate
//
//  Created by XueSongLu on 3/8/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "CMTwoToneProgressBar.h"

@interface PostCell : UITableViewCell <UIScrollViewDelegate> {
    NSString *propertyId;
    AsyncImageView *curImageView;
    NSArray *imagesArray;
    NSMutableArray *curImages;
    long totalPage;
    long curPage;
    int type;
    CGRect bounds;
}
@property (strong, nonatomic) IBOutlet CMTwoToneProgressBar *prgQuality;
    
@property (nonatomic,strong) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblImgNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnPrev;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;

@property (strong, nonatomic) IBOutlet UIScrollView *imgView;
@property (strong, nonatomic) IBOutlet UIButton *btnQA;

- (IBAction)onNextBtnPressed:(id)sender;
- (IBAction)onPrevBtnPressed:(id)sender;
- (void) setPropertyDetail:(int)pid pictures:(NSArray *)pictureArray type:(int)imageType;

@end
