//
//  FavoritesViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesViewController : UIViewController {
    NSMutableArray * favoriteList;
    
    IBOutlet UITableView *tblList;
    NSIndexPath *delIndexPath;
    
}

@property (strong, nonatomic) IBOutlet UIView *navView;
- (void)setEnable:(BOOL)enable;
- (IBAction)onBackBtnPressed:(id)sender;
@property (nonatomic,strong) UIViewController *prevViewController;

@end
