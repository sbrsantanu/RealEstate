//
//  PostViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostEditViewController;
@class PostNewViewController;

@class DataModel;
@class AFHTTPClient;

@interface PostViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray * postList;
    IBOutlet UITableView *tblList;
}

@property (strong, nonatomic) IBOutlet UIView *navView;
@property (nonatomic,strong) UIViewController *prevViewController;
@property (strong, nonatomic) IBOutlet UIImageView *imgArrow;

- (void) getListInfo;
- (void)setEnable:(BOOL)enable;
- (IBAction)onMenuBtnPressed:(id)sender;
- (IBAction)onAddPostBtnPressed:(id)sender;

@end
