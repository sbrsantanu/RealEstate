//
//  PostCell.m
//  RealEstate
//
//  Created by XueSongLu on 3/8/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "PostCell.h"
#import "Constant.h"

@implementation PostCell

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

- (IBAction)onNextBtnPressed:(id)sender {
    [self scrollToNext];
}

- (void)scrollToNext
{
    if (totalPage <= 1) {
        return;
    }
    
    NSArray *subViews = [self.imgView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:curPage];
    
    for (int i = 0; i < 3; i++) {
        AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0,0,bounds.size.width,240)];
        imageView.userInteractionEnabled = YES;
        if ([[curImages objectAtIndex:i] objectForKey:@"data"] == nil) {
            [imageView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",propertyImageUrl,[[curImages objectAtIndex:i] objectForKey:@"path"]]]];
        }else {
            [imageView setImage:[UIImage imageWithData:[[curImages objectAtIndex:i] objectForKey:@"data"]]];
        }
        /*if (type == 1) {
            [imageView setImage:[UIImage imageWithData:[[curImages objectAtIndex:i] objectForKey:@"data"]]];
        }else {
            [imageView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",propertyImageUrl,[[curImages objectAtIndex:i] objectForKey:@"path"]]]];
        }*/
        imageView.frame = CGRectOffset(imageView.frame, bounds.size.width * i, 0);
        
        [self.imgView addSubview:imageView];
    }
    if (curPage < totalPage) {
        curPage++;
    }else {
        curPage = 1;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    for (int i = 1; i < 3; i++) {
        AsyncImageView *imageView = (AsyncImageView *)[self.imgView.subviews objectAtIndex:i];
        imageView.transform = CGAffineTransformMakeTranslation( -bounds.size.width, 0 );
    }
    [UIView commitAnimations];
    AsyncImageView *imageView = (AsyncImageView *)[self.imgView.subviews objectAtIndex:0];
    CGRect frame = imageView.frame;
    frame.origin.x = bounds.size.width * 2;
    [imageView setFrame:frame];
    self.lblImgNumber.text = [NSString stringWithFormat:@"%ld / %ld",curPage, totalPage];
}

- (void)scrollToPrev
{
    if (totalPage <= 1) {
        return;
    }
    
    NSArray *subViews = [self.imgView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:curPage];
    
    for (int i = 0; i < 3; i++) {
        AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0,0,bounds.size.width,240)];
        imageView.userInteractionEnabled = YES;
        if ([[curImages objectAtIndex:i] objectForKey:@"data"] == nil) {
            [imageView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",propertyImageUrl,[[curImages objectAtIndex:i] objectForKey:@"path"]]]];
        }else {
            [imageView setImage:[UIImage imageWithData:[[curImages objectAtIndex:i] objectForKey:@"data"]]];
        }
        /*if (type == 1) {
            [imageView setImage:[UIImage imageWithData:[[curImages objectAtIndex:i] objectForKey:@"data"]]];
        }else {
            [imageView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",propertyImageUrl,[[curImages objectAtIndex:i] objectForKey:@"path"]]]];
        }*/
        imageView.frame = CGRectOffset(imageView.frame, bounds.size.width * i, 0);
        
        [self.imgView addSubview:imageView];
    }
    if (curPage > 1) {
        curPage--;
    }else {
        curPage = totalPage;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    for (int i = 0; i < 2; i++) {
        AsyncImageView *imageView = (AsyncImageView *)[self.imgView.subviews objectAtIndex:i];
        imageView.transform = CGAffineTransformMakeTranslation( bounds.size.width, 0 );
    }
    [UIView commitAnimations];
    AsyncImageView *imageView = (AsyncImageView *)[self.imgView.subviews objectAtIndex:2];
    CGRect frame = imageView.frame;
    frame.origin.x = 0;
    [imageView setFrame:frame];
    self.lblImgNumber.text = [NSString stringWithFormat:@"%ld / %ld",curPage, totalPage];
}

- (void)refreshScrollView {
    
    if (totalPage == 0) {
        return;
    }
    NSArray *subViews = [self.imgView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:curPage];
    int nIndex = 0;
    if (totalPage <= 1) {
        nIndex = 1;
    }else {
        nIndex = 3;
    }
    for (int i = 0; i < nIndex; i++) {
        AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0,0,bounds.size.width,240)];
        imageView.userInteractionEnabled = YES;
        if ([[curImages objectAtIndex:i] objectForKey:@"data"] == nil) {
            [imageView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",propertyImageUrl,[[curImages objectAtIndex:i] objectForKey:@"path"]]]];
        }else {
            [imageView setImage:[UIImage imageWithData:[[curImages objectAtIndex:i] objectForKey:@"data"]]];
        }
        /*if (type == 1) {
            [imageView setImage:[UIImage imageWithData:[[curImages objectAtIndex:i] objectForKey:@"data"]]];
        }else {
            [imageView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",propertyImageUrl,[[curImages objectAtIndex:i] objectForKey:@"path"]]]];
        }*/
        imageView.frame = CGRectOffset(imageView.frame, bounds.size.width * i, 0);
        
        [self.imgView addSubview:imageView];
    }
    self.lblImgNumber.text = [NSString stringWithFormat:@"%ld / %ld",curPage, totalPage];
    if (nIndex <= 1) {
        [self.imgView setContentOffset:CGPointMake(0,0) animated:NO];
    }else {
        [self.imgView setContentOffset:CGPointMake(bounds.size.width,0) animated:NO];
    }
}

- (long)validPageValue:(NSInteger)value {
    
    if(value == 0) value = totalPage;                   // value＝1为第一张，value = 0为前面一张
    if(value == totalPage + 1) value = 1;
    
    return value;
}

- (NSArray *)getDisplayImagesWithCurpage:(long)page {
    
    long pre = [self validPageValue:curPage-1];
    long last = [self validPageValue:curPage+1];
    
    if([curImages count] != 0) [curImages removeAllObjects];
    
    if (totalPage > 1) {
        [curImages addObject:[imagesArray objectAtIndex:pre-1]];
        [curImages addObject:[imagesArray objectAtIndex:curPage-1]];
        [curImages addObject:[imagesArray objectAtIndex:last-1]];
    }else {
        [curImages addObject:[imagesArray objectAtIndex:curPage-1]];
    }
    
    return curImages;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    if(x >= bounds.size.width * 2) {
        curPage = [self validPageValue:curPage+1];
        [self refreshScrollView];
    }
    if(x <= 0) {
        curPage = [self validPageValue:curPage-1];
        [self refreshScrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    if (totalPage <= 1) {
        return;
    }
    [self.imgView setContentOffset:CGPointMake(bounds.size.width, 0) animated:YES];
}

- (IBAction)onPrevBtnPressed:(id)sender {
    [self scrollToPrev];
}

- (void) setPropertyDetail:(int)pid pictures:(NSArray *)pictureArray type:(int)imageType {
    curPage = 1;
    bounds = [[UIScreen mainScreen] bounds];
    totalPage = pictureArray.count;
    if (totalPage <= 1) {
        self.imgView.contentSize = CGSizeMake(bounds.size.width, 240);
    }else {
        self.imgView.contentSize = CGSizeMake(bounds.size.width * 3,240);
    }
    self.imgView.delegate = self;
    self.imgView.directionalLockEnabled = YES;
    curImages = [[NSMutableArray alloc] init];
    imagesArray = [[NSArray alloc] initWithArray:pictureArray];
    propertyId = [NSString stringWithFormat:@"%d",pid];
    type = imageType;
    [self refreshScrollView];
}

@end
