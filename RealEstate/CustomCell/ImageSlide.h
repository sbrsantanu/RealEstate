//
//  ImageSlide.h
//  RealEstate
//
//  Created by Sol.S on 4/4/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSlide : UIView <UIScrollViewDelegate> {
    
    NSArray *imagesArray;
    NSMutableArray *curImages;
    long totalPage;
    long curPage;
    CGRect imageRect;
    int type;
}

@property (strong, nonatomic) IBOutlet UIButton *btnPrev;

@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblImgNumber;
@property (strong, nonatomic) IBOutlet UIScrollView *imgView;

- (NSArray *)getDisplayImagesWithCurpage:(long)page;
- (void)refreshScrollView;

- (IBAction)onNextBtnPressed:(id)sender;
- (IBAction)onPrevBtnPressed:(id)sender;

- (void) setImageList:(NSArray *)pictureArray type:(int)imageType;

- (NSArray *) getImageList;

@end
