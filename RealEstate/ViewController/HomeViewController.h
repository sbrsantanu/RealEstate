//
//  HomeViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OfferViewController;
@class PostNewViewController;
@class DetailPropertyViewController;

@interface HomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UISearchBarDelegate> {
    
    //IBOutlet UITextField *txtSearch;
    IBOutlet UISearchBar *txtSearch;
    
    IBOutlet UILabel *lblBedroom;
    IBOutlet UILabel *lblType;

    IBOutlet UIView *viewType;
    IBOutlet UIView *viewBedroom;
    IBOutlet UIView *moreBtnView;
    IBOutlet UIView *moreView;
    UIView *roomView;
    UIView *typeView;
    IBOutlet UISegmentedControl *segRental;
    IBOutlet UISegmentedControl *segSqft;
    IBOutlet UISegmentedControl *segParking;
    IBOutlet UITableView *tblLocation;
    NSMutableArray *curPropertyList;
    NSMutableArray *curAreaList;
    CGFloat lastScrollOffset;
}

@property (nonatomic,strong) NSMutableArray *propertyList;
@property (nonatomic,strong) NSMutableArray *areaList;
@property (nonatomic,strong) IBOutlet UITableView *tblList;
@property (strong, nonatomic) IBOutlet UIView *condView;
@property (strong, nonatomic) IBOutlet UIView *navView;

@property (nonatomic,strong) UIViewController *prevViewController;

- (IBAction)onMoreBtnPressed:(id)sender;
- (IBAction)onRoomBtnPressed:(id)sender;

- (IBAction)onTypeBtnPressed:(id)sender;

- (IBAction)onMenuBtnPressed:(id)sender;
- (IBAction)onSearchBtnPressed:(id)sender;

- (void)setEnable:(BOOL)enable;

- (void) getListInfo;

- (IBAction)onAddBtnPressed:(id)sender;

@end
