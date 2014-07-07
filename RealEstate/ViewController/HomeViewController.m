//
//  HomeViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "Reachability.h"

#import "HomeViewController.h"
#import "OfferViewController.h"
#import "PostNewViewController.h"
#import "DetailPropertyViewController.h"
#import "ProfileEditViewController.h"
#import "MenuViewController.h"
#import "MyNavigationController.h"
#import "LoginViewController.h"
#import "VerifyViewController.h"

#import "AFNetworking.h"

#import "Property.h"
#import "Users.h"
#import "Favorites.h"
#import "PropertyImage.h"
#import "PropertyFacility.h"
#import "PropertyFurnish.h"
#import "Postcode.h"
#import "State.h"
#import "Offer.h"

#import "PPRevealSideViewController.h"

#import "PropertyCell.h"
#import "AsyncImageView.h"
#import "MBProgressHUD.h"

#import "NSString+SBJSON.h"

#import "AppDelegate.h"
#import "Constant.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (txtSearch.subviews && txtSearch.subviews.count > 0) {
        // Get main searchBar view
        UIView *searchBarView = [txtSearch.subviews objectAtIndex:0];
        // Iterate through its subviews
        for (UIView* searchBarSubview in [searchBarView subviews]) {
            // Check for a text field
            if ([searchBarSubview isKindOfClass:[UITextField class]]) {
                // Success. Now you can change its appearance.
                [searchBarSubview.layer setCornerRadius:15.0f];
                break;
            }
        }
    }
    
    txtSearch.delegate = self;
    
    UITapGestureRecognizer *bedTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRoomBtnPressed:)];
    [lblBedroom addGestureRecognizer:bedTap];
    
    UITapGestureRecognizer *propTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTypeBtnPressed:)];
    [lblType addGestureRecognizer:propTap];
    
    UITapGestureRecognizer *moreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMoreBtnPressed:)];
    [moreBtnView addGestureRecognizer:moreTap];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        roomView = [[UIView alloc] initWithFrame:CGRectMake(viewBedroom.frame.origin.x, 44 + viewBedroom.frame.origin.y + viewBedroom.frame.size.height, viewBedroom.frame.size.width, 150)];
    }else {
        roomView = [[UIView alloc] initWithFrame:CGRectMake(viewBedroom.frame.origin.x, 64 + viewBedroom.frame.origin.y + viewBedroom.frame.size.height, viewBedroom.frame.size.width, 150)];
    }
    roomView.backgroundColor = [UIColor colorWithRed:82 / 255.0 green:234 / 255.0 blue:212 / 255.0 alpha:1.0];
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    for (int i = 0; i < 5; i++) {
        NSString *bedStr;
        if (i < 2) {
            bedStr = [NSString stringWithFormat:@"%d Bedroom",i];
        }else if (i < 4) {
            bedStr = [NSString stringWithFormat:@"%d Bedrooms",i];
        }else {
            bedStr = @"4+ Bedrooms";
        }
        UILabel *labelBed = [[UILabel alloc] initWithFrame:CGRectMake(15,i * 30,viewBedroom.frame.size.width - 15,30)];
        [labelBed setText:bedStr];
        [labelBed setTextColor:[UIColor whiteColor]];
        [labelBed setBackgroundColor:[UIColor clearColor]];
        [labelBed setFont:font];
        labelBed.userInteractionEnabled = YES;
        UITapGestureRecognizer *roomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(roomGestureCaptured:)];
        [labelBed addGestureRecognizer:roomTap];
        [roomView addSubview:labelBed];
    }
    [roomView setHidden:YES];
    self.tblList.userInteractionEnabled = YES;
    [self.view addSubview:roomView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        typeView = [[UIView alloc] initWithFrame:CGRectMake(viewType.frame.origin.x, 44 + viewType.frame.origin.y + viewType.frame.size.height, viewType.frame.size.width, 60)];
    }else {
        typeView = [[UIView alloc] initWithFrame:CGRectMake(viewType.frame.origin.x, 64 + viewType.frame.origin.y + viewType.frame.size.height, viewType.frame.size.width, 60)];
    }
    typeView.backgroundColor = [UIColor colorWithRed:82 / 255.0 green:234 / 255.0 blue:212 / 255.0 alpha:1.0];
    for (int i = 0; i < 2; i++) {
        NSString *typeStr;
        if (i == 0) {
            typeStr = @"Landed";
        }else {
            typeStr = @"High Rise";
        }
        UILabel *labelType = [[UILabel alloc] initWithFrame:CGRectMake(15,i * 30,viewType.frame.size.width - 15,30)];
        [labelType setText:typeStr];
        //[labelType setTextColor:[UIColor colorWithRed:45 / 255.0 green:160 / 255.0 blue:224 / 255.0 alpha:1.0f]];
        [labelType setTextColor:[UIColor whiteColor]];
        [labelType setBackgroundColor:[UIColor clearColor]];
        [labelType setFont:font];
        labelType.userInteractionEnabled = YES;
        UITapGestureRecognizer *typeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeGestureCaptured:)];
        [labelType addGestureRecognizer:typeTap];
        [typeView addSubview:labelType];
    }
    [typeView setHidden:YES];
    [self.view addSubview:typeView];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    [moreView setFrame:CGRectMake(0,113,bounds.size.width,270)];
    [moreView setHidden:YES];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [segParking setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [segRental setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [segSqft setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    if ([self.prevViewController isKindOfClass:[MenuViewController class]]) {
        MenuViewController *menuViewController = (MenuViewController *)self.prevViewController;
        menuViewController.prevViewController = self;
    }
    tblLocation.delegate = self;
    curAreaList = [[NSMutableArray alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [[txtSearch.subviews objectAtIndex:0] removeFromSuperview];
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [self.condView setFrame:CGRectMake(0, 44, bounds.size.width, 40)];
        [moreView setFrame:CGRectMake(0,84,bounds.size.width,270)];
    }else {
        txtSearch.placeholder = @"Enter location                  ";
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [self.condView setFrame:CGRectMake(0, 64, bounds.size.width, 40)];
        [moreView setFrame:CGRectMake(0,104,bounds.size.width,270)];
    }
    [self.tblList setFrame:CGRectMake(0,0,bounds.size.width,bounds.size.height)];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(84, 0, 0, 0);
    self.tblList.contentInset = contentInsets;
    self.tblList.scrollIndicatorInsets = contentInsets;
    [tblLocation setFrame:CGRectMake(0,0,bounds.size.width,bounds.size.height)];
    UIEdgeInsets contentInsets1 = UIEdgeInsetsMake(self.navView.frame.size.height, 0, 0, 0);
    tblLocation.contentInset = contentInsets1;
    tblLocation.scrollIndicatorInsets = contentInsets1;
    [self.view bringSubviewToFront:self.condView];
    [self.view bringSubviewToFront:self.navView];
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tblList addSubview:refresh];
    viewBedroom.layer.borderColor = [[UIColor whiteColor] CGColor];
    viewBedroom.layer.borderWidth = 1.0f;
    viewType.layer.borderColor = [[UIColor whiteColor] CGColor];
    viewType.layer.borderWidth = 1.0f;
    moreBtnView.backgroundColor = [UIColor clearColor];
    [self getListInfo];
}


- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
    [self getListInfo];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [tblLocation setHidden:YES];
    [self.condView setHidden:NO];
    [self filterList];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [roomView setHidden:YES];
    [typeView setHidden:YES];
    [moreView setHidden:YES];
    viewBedroom.layer.borderWidth = 1.0f;
    viewType.layer.borderWidth = 1.0f;
    self.tblList.userInteractionEnabled = YES;
    return YES;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.condView setHidden:YES];
    NSString *searchText = txtSearch.text;
    if (searchText == nil) {
        [tblLocation setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }else {
        searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([searchText isEqualToString:@""]) {
            [tblLocation setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5]];
            [tblLocation setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        }else {
            [tblLocation setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
            [tblLocation setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        }
    }
    [tblLocation reloadData];
    [tblLocation setHidden:NO];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSString *searchText = [txtSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (searchText == nil || [searchText isEqualToString:@""]) {
        [tblLocation setHidden:YES];
        [self.condView setHidden:NO];
        [self filterList];
    }    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText == nil) {
        [tblLocation setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }else {
        searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([searchText isEqualToString:@""]) {
            [tblLocation setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5]];
            [tblLocation setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        }else {
            [tblLocation setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
            [tblLocation setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        }
    }
    [curAreaList removeAllObjects];
    for (int i = 0; i < self.areaList.count; i++) {
        NSDictionary *areaVal = [self.areaList objectAtIndex:i];
        if (searchText != nil && ![searchText isEqualToString:@""]) {
            NSString *areaName = [[areaVal objectForKey:@"name"] lowercaseString];
            NSString *postOffice = [[areaVal objectForKey:@"post_office"] lowercaseString];
            NSString *postCode = [[areaVal objectForKey:@"post_code"] lowercaseString];
            NSString *searchString = [searchText lowercaseString];
            NSRange range1 = [areaName rangeOfString:searchString];
            NSRange range2 = [postCode rangeOfString:searchText];
            NSRange range3 = [postOffice rangeOfString:searchString];
            if (range1.location != NSNotFound || range3.location != NSNotFound || range2.location != NSNotFound) {
                [curAreaList addObject:[areaVal objectForKey:@"name"]];
            }
        }
    }
    if (curAreaList.count == 0 && searchText != nil && ![searchText isEqualToString:@""]) {
        [curAreaList addObject:@"No Results Found"];
    }
    [tblLocation reloadData];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
    viewBedroom.layer.borderWidth = 1.0f;
    viewType.layer.borderWidth = 1.0f;
    [roomView setHidden:YES];
    [typeView setHidden:YES];
    [moreView setHidden:YES];
}

- (void)typeGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UILabel *sender = (UILabel *)gesture.view;
    lblType.text = [NSString stringWithFormat:@"%@",sender.text];
    viewType.layer.borderWidth = 1.0f;
    [typeView setHidden:YES];
    self.tblList.userInteractionEnabled = YES;
    [self filterList];
}

- (void)roomGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UILabel *sender = (UILabel *)gesture.view;
    lblBedroom.text = [NSString stringWithFormat:@"%@",sender.text];
    [roomView setHidden:YES];
    viewBedroom.layer.borderWidth = 1.0f;
    self.tblList.userInteractionEnabled = YES;
    [self filterList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMoreBtnPressed:(id)sender {
    [self.view endEditing:YES];
    if ([moreView isHidden]) {
        [moreView setHidden:NO];
        [typeView setHidden:YES];
        [roomView setHidden:YES];
        viewBedroom.layer.borderWidth = 1.0f;
        viewType.layer.borderWidth = 1.0f;
        self.tblList.userInteractionEnabled = NO;
    }else {
        [moreView setHidden:YES];
        self.tblList.userInteractionEnabled = YES;
    }
}

- (IBAction)onRoomBtnPressed:(id)sender {
    [self.view endEditing:YES];
    if ([roomView isHidden]) {
        lblBedroom.text = @"All Bedrooms";
        [roomView setHidden:NO];
        [typeView setHidden:YES];
        [moreView setHidden:YES];
        viewBedroom.layer.borderWidth = 0.0f;
        viewType.layer.borderWidth = 1.0f;
        self.tblList.userInteractionEnabled = NO;
    }else {
        viewBedroom.layer.borderWidth = 1.0f;
        [roomView setHidden:YES];
        self.tblList.userInteractionEnabled = YES;
        [self filterList];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [roomView setHidden:YES];
    [typeView setHidden:YES];
    [moreView setHidden:YES];
    self.tblList.userInteractionEnabled = YES;
}

- (IBAction)onTypeBtnPressed:(id)sender {
    [self.view endEditing:YES];
    if ([typeView isHidden]) {
        lblType.text = @"All Properties";
        [typeView setHidden:NO];
        [roomView setHidden:YES];
        [moreView setHidden:YES];

        viewType.layer.borderWidth = 0.0f;
        viewBedroom.layer.borderWidth = 1.0f;
        self.tblList.userInteractionEnabled = NO;
    }else {
        viewType.layer.borderWidth = 1.0f;
        [typeView setHidden:YES];
        self.tblList.userInteractionEnabled = YES;
        [self filterList];
    }
}

- (IBAction)onMenuBtnPressed:(id)sender {
    MenuViewController *menuViewController = [[MenuViewController alloc] init];
    menuViewController.prevViewController = self;
    MyNavigationController *n = [[MyNavigationController alloc] initWithRootViewController:menuViewController];
    n.navigationBarHidden = YES;
    [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionLeft withOffset:0 animated:TRUE];
}

- (IBAction)onSearchBtnPressed:(id)sender {
    [moreView setHidden:YES];
    self.tblList.userInteractionEnabled = YES;
    [self filterList];
}

- (void) setEnable:(BOOL)enable
{
    [self.view setUserInteractionEnabled:enable];
}

- (void)filterList
{
    [curPropertyList removeAllObjects];
    for (int i = 0; i < self.propertyList.count; i++) {
        NSString *plocation1 = [[self.propertyList objectAtIndex:i] objectForKey:@"address1"];
        NSString *plocation2 = [[self.propertyList objectAtIndex:i] objectForKey:@"address2"];
        NSString *pZipcode = [[self.propertyList objectAtIndex:i] objectForKey:@"zipcode"];
        //NSString *pnation = [[self.propertyList objectAtIndex:i] objectForKey:@"nationality"];
        if (![txtSearch.text isEqualToString:@""]) {
            NSArray *loc = [txtSearch.text componentsSeparatedByString:@","];
            if (loc.count == 1) {
                NSRange range1 = [plocation1 rangeOfString:[txtSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                NSRange range2 = [plocation2 rangeOfString:[txtSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                if (range1.location == NSNotFound && range2.location == NSNotFound && ![pZipcode isEqualToString:txtSearch.text]) {
                    continue;
                }
            }/*else if (loc.count == 2) {
                NSString *location = [[loc objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSString *nationality = [[loc objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSRange range1 = [plocation1 rangeOfString:location];
                NSRange range2 = [plocation2 rangeOfString:location];
                //NSRange range3 = [pnation rangeOfString:nationality];
                if ((range1.location == NSNotFound && range2.location == NSNotFound) || range3.location == NSNotFound) {
                    continue;
                }
            }*/
        }
        int prooms = [[[self.propertyList objectAtIndex:i] objectForKey:@"rooms"] intValue];
        if (![lblBedroom.text isEqualToString:@"All Bedrooms"]) {
            NSRange range = [lblBedroom.text rangeOfString:@"Bedroom"];
            int rooms = [[lblBedroom.text substringToIndex:range.location] intValue];
            if (rooms != prooms) {
                continue;
            }
        }
        int ptype = [[[self.propertyList objectAtIndex:i] objectForKey:@"type"] intValue];
        if (([lblType.text isEqualToString:@"Landed"] && ptype != 1) || ([lblType.text isEqualToString:@"High Rise"] && ptype != 2)) {
            continue;
        }
        int prental = [[[self.propertyList objectAtIndex:i] objectForKey:@"rental"] intValue];
        if ((segRental.selectedSegmentIndex == 1 && (prental < 1000 || prental >= 2000)) || (segRental.selectedSegmentIndex == 2 && (prental < 2000 || prental >= 3000)) || (segRental.selectedSegmentIndex == 3 && (prental < 3000 || prental >= 4000)) || (segRental.selectedSegmentIndex == 4 && prental < 4000)) {
            continue;
        }
        int psqft = [[[self.propertyList objectAtIndex:i] objectForKey:@"sqft"] intValue];
        if ((segSqft.selectedSegmentIndex == 1 && psqft >= 1000) || (segSqft.selectedSegmentIndex == 2 && (psqft < 1000 || psqft >= 2000)) || (segSqft.selectedSegmentIndex == 3 && (psqft < 2000 || psqft >= 3000)) || (segSqft.selectedSegmentIndex == 4 && psqft < 3000)) {
            continue;
        }
        int pparkings = [[[self.propertyList objectAtIndex:i] objectForKey:@"parkings"] intValue];
        if (segParking.selectedSegmentIndex > 0 && segParking.selectedSegmentIndex != pparkings) {
            continue;
        }
        [curPropertyList addObject:[self.propertyList objectAtIndex:i]];
    }
    
    for (int i = 0; i < curPropertyList.count; i++) {
        NSMutableDictionary *propInfo = [curPropertyList objectAtIndex:i];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSError *error;
        NSManagedObjectContext *context = [delegate managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@' and propertyid='%@'",delegate.userid, [propInfo objectForKey:@"id"]]]];
        NSEntityDescription *favEntity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:context];
        [fetchRequest setEntity:favEntity];
        NSArray *favObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (favObjects.count > 0) {
            [propInfo setValue:@"1" forKey:@"like"];
        }else {
            [propInfo setValue:@"0" forKey:@"like"];
        }
        [curPropertyList setObject:propInfo atIndexedSubscript:i];
    }
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [self.condView setFrame:CGRectMake(0, 44, bounds.size.width, 40)];
        [moreView setFrame:CGRectMake(0,84,bounds.size.width,270)];
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [self.condView setFrame:CGRectMake(0, 64, bounds.size.width, 40)];
        [moreView setFrame:CGRectMake(0,104,bounds.size.width,270)];
    }
    [self.tblList reloadData];
}

- (IBAction)onAddBtnPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [roomView setHidden:YES];
    [typeView setHidden:YES];
    [tblLocation setHidden:YES];
    [moreView setHidden:YES];
    self.tblList.userInteractionEnabled = YES;
    PostNewViewController *postNewViewController = [[PostNewViewController alloc] init];
    [self.navigationController pushViewController:postNewViewController animated:YES];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        [UIView setAnimationDelegate:self];
        if ([scrollView isEqual:self.tblList]) {
            CGRect rect = self.navView.frame;
            if (rect.origin.y < -(self.condView.frame.size.height + rect.size.height) / 2) {
                lastScrollOffset = scrollView.contentOffset.y;
                [self.tblList setContentOffset:CGPointMake(0,lastScrollOffset + (self.condView.frame.size.height + rect.size.height + rect.origin.y))];
                rect.origin.y = -(self.condView.frame.size.height + rect.size.height);
            }else {
                rect.origin.y = 0;
            }
            [self.navView setFrame:rect];
            rect = self.condView.frame;
            rect.origin.y = self.navView.frame.origin.y + self.navView.frame.size.height;
            [self.condView setFrame:rect];
        }else if ([scrollView isEqual:tblLocation]) {
            CGRect rect = self.navView.frame;
            if (rect.origin.y < -rect.size.height / 2) {
                lastScrollOffset = scrollView.contentOffset.y;
                [self.tblList setContentOffset:CGPointMake(0,lastScrollOffset + (rect.size.height + rect.origin.y))];
                rect.origin.y = -rect.size.height;
            }else {
                rect.origin.y = 0;
            }
            [self.navView setFrame:rect];
            rect = self.condView.frame;
            rect.origin.y = self.navView.frame.origin.y + self.navView.frame.size.height;
            [self.condView setFrame:rect];
        }
        [UIView commitAnimations];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        return;
    }
    if ([scrollView isEqual:self.tblList]) {
        CGRect rect = self.navView.frame;
        if (scrollView.contentInset.top + scrollView.contentOffset.y < 0 && rect.origin.y >= 0) {
            return;
        }
        rect.origin.y -= (scrollView.contentOffset.y - lastScrollOffset);
        if (rect.origin.y >= 0) {
            rect.origin.y = 0;
        }
        if (rect.origin.y < -(self.condView.frame.size.height + rect.size.height)) {
            rect.origin.y = -(self.condView.frame.size.height + rect.size.height);
        }
        [self.navView setFrame:rect];
        rect = self.condView.frame;
        rect.origin.y = self.navView.frame.origin.y + self.navView.frame.size.height;
        [self.condView setFrame:rect];
        
        lastScrollOffset = scrollView.contentOffset.y;
    }else if ([scrollView isEqual:tblLocation]) {
        CGRect rect = self.navView.frame;
        if (scrollView.contentInset.top + scrollView.contentOffset.y < 0 && rect.origin.y >= 0) {
            return;
        }
        rect.origin.y -= (scrollView.contentOffset.y - lastScrollOffset);
        if (rect.origin.y >= 0) {
            rect.origin.y = 0;
        }
        if (rect.origin.y < -rect.size.height) {
            rect.origin.y = -rect.size.height;
        }
        [self.navView setFrame:rect];
        rect = self.condView.frame;
        rect.origin.y = self.navView.frame.origin.y + self.navView.frame.size.height;
        [self.condView setFrame:rect];
        
        lastScrollOffset = scrollView.contentOffset.y;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UITableView *tblView = (UITableView *)scrollView;
    if ([tblView isEqual:tblLocation]) {
        [self.view endEditing:YES];
    }else {
        //lastScrollOffset = scrollView.contentOffset.y;

    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [tblLocation setHidden:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.forFavorite != nil && [delegate.forFavorite isEqualToString:@"1"] && self.prevViewController != nil && [self.prevViewController isKindOfClass:[VerifyViewController class]]) {
        NSManagedObjectContext *context = delegate.managedObjectContext;
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        //Get Property Data
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"propertyid='%@'",delegate.pid]]];
        NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
        [fetchRequest setEntity:propEntity];
        NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        //Get Favorite Data
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@' and propertyid='%@'",delegate.userid,delegate.pid]]];
        NSEntityDescription *favEntity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:context];
        [fetchRequest setEntity:favEntity];
        NSArray *favObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (favObjects.count == 0) {
            if (propObjects.count > 0) {
                Property *propObject = (Property *)[propObjects objectAtIndex:0];
                if (propObject.userid != [NSNumber numberWithInt:[delegate.userid intValue]]) {
                    Favorites *favObject = [NSEntityDescription insertNewObjectForEntityForName:@"Favorites" inManagedObjectContext:context];
                    favObject.userid = [NSNumber numberWithInt:[delegate.userid intValue]];
                    favObject.propertyid = [NSNumber numberWithInt:[delegate.pid intValue]];
                    favObject.propertyInfo = propObject;
                    [delegate saveContext];
                }else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Home" message:@"This is your own property" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alertView show];
                }
            }
        }
        [self filterList];
    }/*else {
        [self filterList];
    }*/
}

- (void) doneLike1 :(NSString*)data
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Home" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (void) getListInfo
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    self.areaList = [[NSMutableArray alloc] init];
    
    //Get Area Data
    [fetchRequest setPredicate:nil];
    NSEntityDescription *codeEntity = [NSEntityDescription entityForName:@"Postcode" inManagedObjectContext:context];
    [fetchRequest setSortDescriptors:nil];
    [fetchRequest setEntity:codeEntity];
    NSArray *codeObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Postcode *codeInfo in codeObjects) {
        NSMutableDictionary *area = [[NSMutableDictionary alloc] init];
        [area setValue:codeInfo.area forKey:@"name"];
        [area setValue:codeInfo.post_office forKey:@"post_office"];
        [area setValue:codeInfo.state_code forKey:@"state_code"];
        [area setValue:codeInfo.postcode forKey:@"post_code"];
        //[area setValue:codeInfo.stateInfo.state_name forKey:@"state_name"];
        [self.areaList addObject:area];
    }
    [tblLocation reloadData];
    
    Reachability *hostReachability = [Reachability reachabilityWithHostName:serverUrl];
    NetworkStatus hostStatus = [hostReachability currentReachabilityStatus];
    if (hostStatus == NotReachable) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Home" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
        /*self.propertyList = [[NSMutableArray alloc] init];
        
        //Get User Data
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"user_id='%@'",delegate.userid]]];
        NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
        [fetchRequest setEntity:userEntity];
        NSArray *userObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (userObjects.count == 0) {
            delegate.quality = 0;
            delegate.username = @"Ananymous Person";
            delegate.photo = @"";
        }else {
            Users *userInfo = (Users *)[userObjects objectAtIndex:0];
            delegate.quality = [NSString stringWithFormat:@"%@",userInfo.quality];
            delegate.username = userInfo.name;
            //delegate.photo = userInfo.photo;
        }
        //Get Property Data
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid!='%@'",delegate.userid]]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"quality" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
        
        NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
        [fetchRequest setEntity:propEntity];
        NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (Property *propInfo in propObjects) {
            Users *userInfo = propInfo.userInfo;
            BOOL is_valid = TRUE;
            NSDate *curDate = [NSDate date];
            if ([delegate.userid isEqualToString:[NSString stringWithFormat:@"%@",userInfo.user_id]]) {
                if (![propInfo.age isEqualToString:@""]) {
                    long year = [delegate getYear:curDate] - [delegate getYear:userInfo.birthday];
                    long age = [propInfo.age intValue];
                    if ((age == 18 && (year <= 18 || year > 25)) || (age == 25 && (year <= 25 || year > 30)) || (age == 30 && (year <= 30 || year > 35)) || (age == 35 && (year <= 35 || year > 40)) || (age == 40 && year <= 40)) {
                        is_valid = FALSE;
                    }
                }
                if (![propInfo.race isEqualToString:@""] && ![userInfo.race isEqualToString:propInfo.race]) {
                    is_valid = FALSE;
                }
                if (![propInfo.nationality isEqualToString:@""] && ![userInfo.nationality isEqualToString:propInfo.nationality]) {
                    is_valid = FALSE;
                }
            }
            if ([propInfo.datecreated timeIntervalSinceNow] <= -30 * 24 * 60 * 60 || [propInfo.datecreated timeIntervalSinceNow] > -5 * 60 * 60) {
                is_valid = FALSE;
            }
            if (!is_valid) {
                continue;
            }
            NSMutableDictionary *property = [[NSMutableDictionary alloc] init];
            [property setObject:propInfo.propertyid forKey:@"id"];
            [property setObject:propInfo.username forKey:@"username"];
            [property setObject:propInfo.userphoto forKey:@"userphoto"];
            [property setObject:propInfo.userprivacy forKey:@"userprivacy"];
            [property setObject:propInfo.name forKey:@"name"];
            [property setObject:propInfo.type forKey:@"type"];
            [property setObject:propInfo.furnish_type forKey:@"furnish_type"];
            [property setObject:propInfo.sqft forKey:@"sqft"];
            [property setObject:propInfo.rooms forKey:@"rooms"];
            [property setObject:propInfo.availability forKey:@"availability"];
            [property setObject:propInfo.rental forKey:@"rental"];
            [property setObject:propInfo.parkings forKey:@"parkings"];
            [property setObject:propInfo.address1 forKey:@"address1"];
            [property setObject:propInfo.address2 forKey:@"address2"];
            [property setObject:@"0" forKey:@"like"];
            for (Favorites *favoritesInfo in propInfo.favoritesInfo) {
                if ([favoritesInfo.propertyid intValue] == [propInfo.propertyid intValue] && [favoritesInfo.userid intValue] == [propInfo.userid intValue]) {
                    [property setObject:@"1" forKey:@"like"];
                }
            }
            NSDate *availability = propInfo.availability;
            long year = [delegate getYear:availability];
            long month = [delegate getMonth:availability];
            long day = [delegate getDay:availability];
            if ([propInfo.availability compare:curDate] <= 0) {
                [property setObject:@"Available Now" forKey:@"availability"];
            }else {
                [property setObject:[NSString stringWithFormat:@"%ld/%ld/%ld Available",month,day,year % 100] forKey:@"availability"];
            }
            NSMutableArray *imageList = [[NSMutableArray alloc] init];
            for (PropertyImage *propImage in propInfo.imgInfo) {
                NSMutableDictionary *image = [[NSMutableDictionary alloc] init];
                [image setObject:propImage.path forKey:@"path"];
                if (propImage.data != nil) {
                    [image setObject:propImage.data forKey:@"data"];
                }else {
                    [image setObject:@"" forKey:@"data"];
                }
                [imageList addObject:image];
            }
            [property setObject:imageList forKey:@"images"];
            [self.propertyList addObject:property];
        }
        curPropertyList = [[NSMutableArray alloc] initWithArray:self.propertyList];*/
        //[self.tblList reloadData];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
        dispatch_async(myqueue, ^{
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if (delegate.userid == nil || [delegate.userid isEqualToString:@""]) {
                delegate.userid = @"0";
            }
            NSString *reqString = [NSString stringWithFormat:@"%@?task=homelist&userid=%@", actionUrl,delegate.userid];
            reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:reqString];
            NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            [self performSelectorOnMainThread:@selector(doneGetListInfo:) withObject:strData waitUntilDone:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self filterList];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    }
}

- (void) doneGetListInfo :(NSString*)data
{
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        self.propertyList = [NSMutableArray arrayWithArray:[dataDict objectForKey:@"properties"]];
        curPropertyList = [NSMutableArray arrayWithArray:[dataDict objectForKey:@"properties"]];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.quality = [NSString stringWithFormat:@"%d",[[[dataDict objectForKey:@"profile"]objectForKey:@"quality"] intValue]];
        delegate.username = [NSString stringWithFormat:@"%@",[[dataDict objectForKey:@"profile"]objectForKey:@"username"]];
        delegate.photo = [NSString stringWithFormat:@"%@",[[dataDict objectForKey:@"profile"]objectForKey:@"photo"]];
        NSError *error;
        NSManagedObjectContext *context = [delegate managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        for (int i = 0; i < self.propertyList.count; i++) {
            NSDictionary *dic = (NSDictionary *)[self.propertyList objectAtIndex:i];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid!='%@' and propertyid='%@'",delegate.userid, [[self.propertyList objectAtIndex:i] objectForKey:@"id"]]]];
            NSEntityDescription *postEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
            [fetchRequest setEntity:postEntity];
            NSArray *postObjects = [context executeFetchRequest:fetchRequest error:&error];
            Property *propObject;
            if (postObjects.count == 0) {
                propObject = [NSEntityDescription insertNewObjectForEntityForName:@"Property" inManagedObjectContext:context];
            }else {
                propObject = (Property *)[postObjects objectAtIndex:0];
                [propObject removeImgInfo:propObject.imgInfo];
                [propObject removeFurnishInfo:propObject.furnishInfo];
                [propObject removeFacilityInfo:propObject.facilityInfo];
            }
            propObject.propertyid = [NSNumber numberWithInt:[[dic objectForKey:@"id"] intValue]];
            propObject.userid = [NSNumber numberWithInt:[[dic objectForKey:@"userid"] intValue]];
            propObject.username = [dic objectForKey:@"username"];
            propObject.userphoto = [dic objectForKey:@"userphoto"];
            propObject.userprivacy = [NSNumber numberWithBool:[[dic objectForKey:@"userprivacy"] boolValue]];
            
            propObject.name = [dic objectForKey:@"name"];
            propObject.rental = [dic objectForKey:@"rental"];
            propObject.toilets = [NSNumber numberWithInt:[[dic objectForKey:@"toilets"] intValue]];
            propObject.type =  [NSNumber numberWithInt:[[dic objectForKey:@"type"] intValue]];
            propObject.furnish_type =  [NSNumber numberWithInt:[[dic objectForKey:@"furnish_type"] intValue]];
            propObject.sqft =  [NSNumber numberWithInt:[[dic objectForKey:@"sqft"] intValue]];
            propObject.rooms =  [NSNumber numberWithInt:[[dic objectForKey:@"rooms"] intValue]];
            propObject.parkings =  [NSNumber numberWithInt:[[dic objectForKey:@"parkings"] intValue]];
            propObject.address1 =  [dic objectForKey:@"address1"];
            propObject.address2 =  [dic objectForKey:@"address2"];
            propObject.latitude = [NSNumber numberWithFloat:[[dic objectForKey:@"latitude"] floatValue]];
            propObject.longitude = [NSNumber numberWithFloat:[[dic objectForKey:@"longitude"] floatValue]];
            propObject.describe = [dic objectForKey:@"description"];
            propObject.time = [dic objectForKey:@"time"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYY-MM-dd"];
            propObject.prefertimestart = [dateFormat dateFromString:[dic objectForKey:@"prefertimestart"]];
            propObject.availability = [dateFormat dateFromString:[dic objectForKey:@"avail_date"]];
            NSArray *propImages = [[self.propertyList objectAtIndex:i] objectForKey:@"images"];
            for (int j = 0; j < propImages.count; j++) {
                PropertyImage *imageObject = [NSEntityDescription insertNewObjectForEntityForName:@"PropertyImage" inManagedObjectContext:context];
                imageObject.propertyid = [NSNumber numberWithInt:[[[propImages objectAtIndex:j] objectForKey:@"propertyid"] intValue]];
                imageObject.path = [[propImages objectAtIndex:j] objectForKey:@"path"];
                //imageObject.data = [NSData dataFromBase64String:[[propImages objectAtIndex:j] objectForKey:@"data"]];
                imageObject.datecreated = [dateFormat dateFromString:[[propImages objectAtIndex:j] objectForKey:@"datecreated"]];
                imageObject.dateupdated = [dateFormat dateFromString:[[propImages objectAtIndex:j] objectForKey:@"dateupdated"]];
                imageObject.propertyInfo = propObject;
            }
            
            NSArray *furnishes = (NSArray *)[dic objectForKey:@"furnishes"];
            for (int j = 0; j < furnishes.count; j++) {
                PropertyFurnish *furnishObject = [NSEntityDescription insertNewObjectForEntityForName:@"PropertyFurnish" inManagedObjectContext:context];
                furnishObject.propertyid = propObject.propertyid;
                furnishObject.furnish_name = [furnishes objectAtIndex:j];
                furnishObject.propertyInfo = propObject;
            }
            
            NSArray *facilities = (NSArray *)[dic objectForKey:@"facilities"];
            for (int j = 0; j < facilities.count; j++) {
                PropertyFacility *facilityObject = [NSEntityDescription insertNewObjectForEntityForName:@"PropertyFacility" inManagedObjectContext:context];
                facilityObject.propertyid = propObject.propertyid;
                facilityObject.facility_name = [facilities objectAtIndex:j];
                facilityObject.propertyInfo = propObject;
            }
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@' and propertyid='%@'",delegate.userid, [[self.propertyList objectAtIndex:i] objectForKey:@"id"]]]];
            NSEntityDescription *offerEntity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
            [fetchRequest setEntity:offerEntity];
            NSArray *offerObjects = [context executeFetchRequest:fetchRequest error:&error];
            if (offerObjects.count > 0) {
                Offer *offerObject = (Offer *)[offerObjects objectAtIndex:0];
                offerObject.propertyInfo = propObject;
            }
        }
        [delegate saveContext];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Home" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tblList]) {
        if (curPropertyList == nil) {
            return 0;
        }
        if (curPropertyList.count == 0) {
            return 1;
        }else {
            return [curPropertyList count];
        }
    }else {
        if (curAreaList != nil && curAreaList.count == 1 && [[curAreaList objectAtIndex:0] isEqualToString:@"No Results Found"]) {
            tblLocation.userInteractionEnabled = NO;
        }else {
            tblLocation.userInteractionEnabled = YES;
        }
        return [curAreaList count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tblList]) {
        return 375.0f;
    }else {
        return 50.0f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tblList]) {
        if (curPropertyList.count == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"Sorry, we don't have anything like that in database";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.numberOfLines = 2;
            return cell;
        }
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"PropertyCell" owner:self options:nil];
        PropertyCell *cell = [nibArray objectAtIndex:0];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        NSDictionary * dic = [curPropertyList objectAtIndex:indexPath.row];
        
        if ([[dic objectForKey:@"type"] intValue] == 1) {
            cell.lblName.text =[NSString stringWithFormat:@"%@", [dic objectForKey:@"address1"]];
        }else {
            cell.lblName.text =[NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
        }
        NSString *furnish_type = @"";
        if ([dic objectForKey:@"furnish_type"] != [[NSNull alloc] init]) {
            if ([[dic objectForKey:@"furnish_type"] intValue] == 1) {
                furnish_type = @"Basic Unit";
            }else if ([[dic objectForKey:@"furnish_type"] intValue] == 2) {
                furnish_type = @"Partial Furnished";
            }else if ([[dic objectForKey:@"furnish_type"] intValue] == 3) {
                furnish_type = @"Fully Furnished";
            }
        }
        cell.lblFurnish.text = [NSString stringWithFormat:@"RM%@/mo & %@", [dic objectForKey:@"rental"],furnish_type];
        NSString *type = @"";
        if ([dic objectForKey:@"type"] != [[NSNull alloc] init]) {
            if ([[dic objectForKey:@"type"] intValue] == 1) {
                type = @"Landed";
            }else if ([[dic objectForKey:@"type"] intValue] == 2) {
                type = @"High Rise";
            }
        }
        cell.lblType.text = type;
        if ([[dic objectForKey:@"sqft"] intValue] > 0) {
            cell.lblSize.text = [NSString stringWithFormat:@"%d sqft", [[dic objectForKey:@"sqft"] intValue]];
        }else {
            cell.lblSize.text = @"";
        }
        if ([[dic objectForKey:@"rooms"] intValue] == 0) {
            cell.lblRooms.text = @"Studio";
        }else if ([[dic objectForKey:@"rooms"] intValue] == 1) {
            cell.lblRooms.text = @"1 Bedroom";
        }else {
            cell.lblRooms.text = [NSString stringWithFormat:@"%d Bedrooms", [[dic objectForKey:@"rooms"] intValue]];
        }
        cell.lblAvailability.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"availability"]];
        if ([[dic objectForKey:@"like"] intValue] == 1) {
            [cell.btnFavorite setImage:[UIImage imageNamed:@"favorite_btn1.png"] forState:UIControlStateNormal];
        }else {
            [cell.btnFavorite setImage:[UIImage imageNamed:@"favorite_btn.png"] forState:UIControlStateNormal];
        }
        NSArray *imageList = (NSArray *)[dic objectForKey:@"images"];
        if (imageList.count <= 1) {
            [cell.btnNext setHidden:YES];
            [cell.btnPrev setHidden:YES];
        }else {
            [cell.btnNext setHidden:NO];
            [cell.btnPrev setHidden:NO];
        }
        cell.imgView.tag = [[dic objectForKey:@"id"] intValue];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
        [cell.imgView addGestureRecognizer:singleTap];
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = delegate.managedObjectContext;
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@' and propertyid='%d'",delegate.userid,[[dic objectForKey:@"id"] intValue]]]];
        NSEntityDescription *offerEntity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
        [fetchRequest setEntity:offerEntity];
        NSArray *offerObjects = [context executeFetchRequest:fetchRequest error:&error];
        BOOL canOffer = TRUE;
        if (offerObjects.count > 0) {
            Offer *offerObject = [offerObjects objectAtIndex:0];
            if ([offerObject.status isEqualToNumber:[NSNumber numberWithInt:0]] || [offerObject.status isEqualToNumber:[NSNumber numberWithInt:1]]) {
                canOffer = FALSE;
            }
        }
        if (canOffer) {
            [cell.btnOffer setImage:[UIImage imageNamed:@"purchase_btn.png"] forState:UIControlStateNormal];
        }else {
            [cell.btnOffer setImage:[UIImage imageNamed:@"purchase_btn_gold.png"] forState:UIControlStateNormal];
        }
        [cell.btnOffer addTarget:self action:@selector(onOfferBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnOffer.tag = [[dic objectForKey:@"id"] intValue];
        cell.btnFavorite.tag = [[dic objectForKey:@"id"] intValue];
        [cell.btnFavorite addTarget:self action:@selector(onFavoriteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell setPropertyDetail:[[dic objectForKey:@"id"] intValue] pictures:imageList type:0];
        return cell;
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = [curAreaList objectAtIndex:indexPath.row];
        return cell;
    }
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    if ([tblLocation isHidden] == NO) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIScrollView *sender = (UIScrollView *)gesture.view;
    delegate.pid = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    DetailPropertyViewController *detailPropertyViewController = [[DetailPropertyViewController alloc] init];
    [self.navigationController pushViewController:detailPropertyViewController animated:YES];
    
}

- (IBAction)onFavoriteBtnPressed:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIButton *favBtn = (UIButton *)sender;
    delegate.pid = [NSString stringWithFormat:@"%ld",(long)favBtn.tag];
    if (delegate.phone == nil || [delegate.phone isEqualToString:@""]) {
        delegate.forFavorite = @"1";
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.prevViewController = self;
        /*loginViewController.lblError = [[UILabel alloc] initWithFrame:CGRectMake(22,23,251,96)];
        loginViewController.lblView = [[UILabel alloc] initWithFrame:CGRectMake(12,29,296,141)];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            loginViewController.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height - 20)];
            loginViewController.imgBack = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height - 20)];
        }else {
            loginViewController.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
            loginViewController.imgBack = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
        }
        CGRect bounds = [[UIScreen mainScreen] bounds];
        UIView *viewStatus = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 20)];
        viewStatus.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
        
        [loginViewController.imgBack setImage:[UIImage imageNamed:@"phone_bg1.png"]];
        [loginViewController.imgBack setHidden:YES];
        [loginViewController.view addSubview:loginViewController.imgBack];
        [loginViewController.lblView addSubview:loginViewController.lblError];
        [loginViewController.scrollView addSubview:loginViewController.lblView];
        [loginViewController.view addSubview:loginViewController.scrollView];
        [loginViewController.view addSubview:viewStatus];
        loginViewController.lblError.text = @"Ops, you have not registered or sign in to favourite this property. Signing in is quick, just enter your mobile number";
        [loginViewController.lblView setHidden:NO];*/
        delegate.afterControllerName = @"HomeViewController";
        [self.navigationController pushViewController:loginViewController animated:YES];
    }else {
        int fav = 0;
        if ([favBtn.imageView.image isEqual:[UIImage imageNamed:@"favorite_btn.png"]]) {
            [favBtn setImage:[UIImage imageNamed:@"favorite_btn1.png"] forState:UIControlStateNormal];
            fav = 1;
        }else {
            [favBtn setImage:[UIImage imageNamed:@"favorite_btn.png"] forState:UIControlStateNormal];
            fav = 0;
        }
        NSManagedObjectContext *context = delegate.managedObjectContext;
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        //Get Property Data
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid!='%@' and propertyid='%@'",delegate.userid,delegate.pid]]];
        NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
        [fetchRequest setEntity:propEntity];
        NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
        //Get Favorite Data
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@' and propertyid='%@'",delegate.userid,delegate.pid]]];
        NSEntityDescription *favEntity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:context];
        [fetchRequest setEntity:favEntity];
        NSArray *favObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (fav == 0) {
            for (Favorites *favObject in favObjects) {
                [context deleteObject:favObject];
            }
        }else {
            if (favObjects.count == 0) {
                if (propObjects.count > 0) {
                    Property *propObject = (Property *)[propObjects objectAtIndex:0];
                    Favorites *favObject = [NSEntityDescription insertNewObjectForEntityForName:@"Favorites" inManagedObjectContext:context];
                    favObject.userid = [NSNumber numberWithInt:[delegate.userid intValue]];
                    favObject.propertyid = [NSNumber numberWithInt:[delegate.pid intValue]];
                    favObject.propertyInfo = propObject;
                    [delegate saveContext];
                    favObjects = [context executeFetchRequest:fetchRequest error:&error];
                }
            }
        }
        NSDictionary *params = @{@"task":@"like",
                                 @"userid":delegate.userid,
                                 @"propertyid":delegate.pid,
                                 @"fav":[NSString stringWithFormat:@"%d",fav]};
        AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:actionUrl]];
        
        [client
         postPath:@"/json/index.php"
         parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (operation.response.statusCode != 200) {
                 NSLog(@"Failed");
             } else {
                 NSLog(@"Success");
             }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if ([self isViewLoaded]) {
                 NSLog(@"Failed");
             }
        }];
    }
}

- (void) doneLike :(NSString*)data
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Home" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (void) onOfferBtnPressed:(UIButton *)sender {
    if ([sender.imageView.image isEqual:[UIImage imageNamed:@"purchase_btn_gold.png"]]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Home" message:@"You've already offered this property" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.pid = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    if (delegate.phone == nil || [delegate.phone isEqualToString:@""]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [roomView setHidden:YES];
        [typeView setHidden:YES];
        [tblLocation setHidden:YES];
        [moreView setHidden:YES];
        self.tblList.userInteractionEnabled = YES;
        OfferViewController *offerViewController = [[OfferViewController alloc] init];
        [self.navigationController pushViewController:offerViewController animated:YES];
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [roomView setHidden:YES];
    [typeView setHidden:YES];
    [tblLocation setHidden:YES];
    [moreView setHidden:YES];
    self.tblList.userInteractionEnabled = YES;
    OfferViewController *offerViewController = [[OfferViewController alloc] init];
    [self.navigationController pushViewController:offerViewController animated:YES];
}

- (void) doneGetOfferStatus :(NSString*)data
{
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"status"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [roomView setHidden:YES];
        [typeView setHidden:YES];
        [tblLocation setHidden:YES];
        [moreView setHidden:YES];
        self.tblList.userInteractionEnabled = YES;
        OfferViewController *offerViewController = [[OfferViewController alloc] init];
        [self.navigationController pushViewController:offerViewController animated:YES];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Home" message:@"You've already offered this property" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

#pragma ---- UITableView delegate ----------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tblList]) {
        
    }else {
        if ([[curAreaList objectAtIndex:indexPath.row] isEqualToString:@"No Results Found"]) {
            return;
        }
        txtSearch.text = [curAreaList objectAtIndex:indexPath.row];
        [self filterList];
        [tblLocation setHidden:YES];
        [self.condView setHidden:NO];
    }
}
@end
