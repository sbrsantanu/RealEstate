//
//  PostEditViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "PostEditViewController.h"
#import "PostEditSuccessViewController.h"
#import "PostViewController.h"
#import "MyNavigationController.h"

#import "Property.h"
#import "Nationality.h"
#import "Race.h"
#import "Furnish.h"
#import "Facility.h"
#import "Users.h"
#import "PropertyImage.h"
#import "PropertyFacility.h"
#import "PropertyFurnish.h"
#import "Favorites.h"
#import "MetaProperty.h"

#import "AFNetworking.h"

#import "MBProgressHUD.h"

#import "ImageSlide.h"

#import "OutImageSlider.h"

#import "NSString+SBJSON.h"

#import "Constant.h"

#import "AppDelegate.h"


@interface PostEditViewController ()

@end

@implementation PostEditViewController

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
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view from its nib.
    [_dataView setContentSize:CGSizeMake(320,2250)];
    
    //Year Selection
    yearView = [[UITableView alloc] initWithFrame:CGRectMake(self.viewYear.frame.origin.x, self.viewYear.frame.origin.y + self.viewYear.frame.size.height, self.viewYear.frame.size.width, 120)];
    yearView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    yearView.layer.borderWidth = 1.0f;
    yearView.separatorStyle = UITableViewCellSeparatorStyleNone;
    yearView.backgroundColor = [UIColor whiteColor];
    [yearView setHidden:YES];
    [viewPropertyCommon addSubview:yearView];
    
    //Month Selection
    monthView = [[UITableView alloc] initWithFrame:CGRectMake(self.viewMonth.frame.origin.x, self.viewMonth.frame.origin.y + self.viewMonth.frame.size.height, self.viewMonth.frame.size.width, 120)];
    monthView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    monthView.layer.borderWidth = 1.0f;
    monthView.separatorStyle = UITableViewCellSeparatorStyleNone;
    monthView.backgroundColor = [UIColor whiteColor];
    [monthView setHidden:YES];
    [viewPropertyCommon addSubview:monthView];
    
    //Date Selection
    dateView = [[UITableView alloc] initWithFrame:CGRectMake(self.viewDate.frame.origin.x, self.viewDate.frame.origin.y + self.viewDate.frame.size.height, self.viewDate.frame.size.width, 120)];
    dateView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    dateView.layer.borderWidth = 1.0f;
    dateView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dateView.backgroundColor = [UIColor whiteColor];
    [dateView setHidden:YES];
    [viewPropertyCommon addSubview:dateView];
    
    //Age Selection
    criteriaAgeView = [[UITableView alloc] initWithFrame:CGRectMake(self.viewCriteriaAge.frame.origin.x, self.viewCriteriaAge.frame.origin.y + self.viewCriteriaAge.frame.size.height, self.viewCriteriaAge.frame.size.width, 120)];
    criteriaAgeView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    criteriaAgeView.layer.borderWidth = 1.0f;
    criteriaAgeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    criteriaAgeView.backgroundColor = [UIColor whiteColor];
    [criteriaAgeView setHidden:YES];
    [viewFiltering addSubview:criteriaAgeView];
    
    //Race Selection
    criteriaRaceView = [[UITableView alloc] initWithFrame:CGRectMake(self.viewCriteriaRace.frame.origin.x, self.viewCriteriaRace.frame.origin.y + self.viewCriteriaRace.frame.size.height, self.viewCriteriaRace.frame.size.width, 120)];
    criteriaRaceView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    criteriaRaceView.layer.borderWidth = 1.0f;
    criteriaRaceView.separatorStyle = UITableViewCellSeparatorStyleNone;
    criteriaRaceView.backgroundColor = [UIColor whiteColor];
    [criteriaRaceView setHidden:YES];
    [viewFiltering addSubview:criteriaRaceView];
    
    //Nationality Selection
    criteriaNationalityView = [[UITableView alloc] initWithFrame:CGRectMake(self.viewCriteriaNationality.frame.origin.x, self.viewCriteriaNationality.frame.origin.y + self.viewCriteriaNationality.frame.size.height, self.viewCriteriaNationality.frame.size.width, 80)];
    criteriaNationalityView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    criteriaNationalityView.layer.borderWidth = 1.0f;
    criteriaNationalityView.separatorStyle = UITableViewCellSeparatorStyleNone;
    criteriaNationalityView.backgroundColor = [UIColor whiteColor];
    [criteriaNationalityView setHidden:YES];
    [viewFiltering addSubview:criteriaNationalityView];
    
    yearView.delegate = self;
    yearView.dataSource = self;
    monthView.delegate = self;
    monthView.dataSource = self;
    dateView.delegate = self;
    dateView.dataSource = self;
    
    criteriaAgeView.delegate = self;
    criteriaAgeView.dataSource = self;
    criteriaRaceView.delegate = self;
    criteriaRaceView.dataSource = self;
    criteriaNationalityView.delegate = self;
    criteriaNationalityView.dataSource = self;
    
    //Preset Basic Info 2
    propView = [[UITableView alloc] initWithFrame:CGRectMake(self.txtName.frame.origin.x, self.txtName.frame.origin.y + self.viewDate.frame.size.height, self.txtName.frame.size.width, 120)];
    propView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    propView.layer.borderWidth = 1.0f;
    propView.separatorStyle = UITableViewCellSeparatorStyleNone;
    propView.backgroundColor = [UIColor whiteColor];
    [propView setHidden:YES];
    [viewPropertyDetail addSubview:propView];
    
    propView.delegate = self;
    propView.dataSource = self;
    
    self.viewYear.layer.borderColor = [[UIColor grayColor] CGColor];
    self.viewYear.layer.borderWidth = 1.0f;
    self.viewMonth.layer.borderColor = [[UIColor grayColor] CGColor];
    self.viewMonth.layer.borderWidth = 1.0f;
    self.viewDate.layer.borderColor = [[UIColor grayColor] CGColor];
    self.viewDate.layer.borderWidth = 1.0f;
    self.viewCriteriaAge.layer.borderColor = [[UIColor grayColor] CGColor];
    self.viewCriteriaAge.layer.borderWidth = 1.0f;
    self.viewCriteriaNationality.layer.borderColor = [[UIColor grayColor] CGColor];
    self.viewCriteriaNationality.layer.borderWidth = 1.0f;
    self.viewCriteriaRace.layer.borderColor = [[UIColor grayColor] CGColor];
    self.viewCriteriaRace.layer.borderWidth = 1.0f;
    
    self.txtDescription.layer.borderColor = [[UIColor grayColor] CGColor];
    self.txtDescription.layer.borderWidth = 1.0f;
    
    NSDate *now = [NSDate date];
    prefertimestart = now;
    int realRow = 1;
    int newLeft = 0, newTop = 0;
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 8; j++) {
            if (i == 0 && j == 0) {
                newTop += 27;
                continue;
            }
            UIButton *newView = [[UIButton alloc] init];
            if (i > 0) {
                newView.frame = CGRectMake(newLeft, newTop, 58, 24);
            }else {
                newView.frame = CGRectMake(newLeft, newTop, 41, 24);
            }
            if (i == 0 && j > 0) {
                long offsetDay = j - 1;
                NSDate *newDate = [now dateByAddingTimeInterval:offsetDay * 24 * 60 * 60];
                NSDateComponents *newDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:newDate];
                [newDateComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
                NSString *dayStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents day]];
                if ([newDateComponents day] < 10) {
                    dayStr = [NSString stringWithFormat:@"0%@",dayStr];
                }
                NSString *monthStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents month]];
                if ([newDateComponents month] < 10) {
                    monthStr = [NSString stringWithFormat:@"0%@",monthStr];
                }
                if ([delegate getMonth:[NSDate date]] == [monthStr intValue] && [delegate getDay:[NSDate date]] == [dayStr intValue] && [delegate getHour:[NSDate date]] > 20) {
                    [newView setHidden:YES];
                }else {
                    realRow++;
                    [newView setHidden:NO];
                    if (j == 7) {
                        newLeft = 40;
                        newTop = 0;
                    }else {
                        newTop += 27;
                    }
                }
                [newView.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
                [newView setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [newView setTitle:[NSString stringWithFormat:@"%@/%@",dayStr,monthStr] forState:UIControlStateNormal];
            }
            if (i > 0 && j == 0) {
                [newView.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
                [newView setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                if (i == 1) {
                    [newView setTitle:[NSString stringWithFormat:@"0%d-%d", 9 + (i - 1) * 3, 9 + i * 3] forState:UIControlStateNormal];
                }else {
                    [newView setTitle:[NSString stringWithFormat:@"%d-%d", 9 + (i - 1) * 3, 9 + i * 3] forState:UIControlStateNormal];
                }
                newTop += 27;
            }
            newView.backgroundColor = [UIColor whiteColor];
            if (i > 0 && j > 0) {
                long offsetDay = j - 1;
                NSDate *newDate = [ now dateByAddingTimeInterval:offsetDay * 24 * 60 * 60];
                NSDateComponents *newDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:newDate];
                [newDateComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
                NSString *dayStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents day]];
                if ([newDateComponents day] < 10) {
                    dayStr = [NSString stringWithFormat:@"0%@",dayStr];
                }
                NSString *monthStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents month]];
                if ([newDateComponents month] < 10) {
                    monthStr = [NSString stringWithFormat:@"0%@",monthStr];
                }
                if ([delegate getMonth:[NSDate date]] == [monthStr intValue] && [delegate getDay:[NSDate date]] == [dayStr intValue] && [delegate getHour:[NSDate date]] > 20) {
                    [newView setHidden:YES];
                }else {
                    if (j == 7) {
                        newLeft += 61;
                        newTop = 0;
                    }else {
                        newTop += 27;
                    }
                    if ([delegate getMonth:[NSDate date]] == [monthStr intValue] && [delegate getDay:[NSDate date]] == [dayStr intValue] && [delegate getHour:[NSDate date]] >= (i + 3) * 3) {
                        [newView setHidden:YES];
                    }else {
                        [newView setHidden:NO];
                    }
                }
                newView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                newView.layer.borderWidth = 0.5f;
                newView.layer.cornerRadius = 11.0f;
                [newView addTarget:self action:@selector(checkButton:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.timeView addSubview:newView];
        }
    }
    CGRect frame = self.timeView.frame;
    frame.size.width = 40 + 4 * 61;
    frame.size.height = realRow * 27;
    [self.timeView setFrame:frame];
    self.imgAvailable.layer.cornerRadius = 7.0f;
    frame = self.viewAvailable.frame;
    frame.origin.y = self.timeView.frame.origin.y + self.timeView.frame.size.height + 10;
    [self.viewAvailable setFrame:frame];
    
    self.imgUnavailable.layer.borderColor = [[UIColor grayColor] CGColor];
    self.imgUnavailable.layer.borderWidth = 1.0f;
    self.imgUnavailable.layer.cornerRadius = 7.0f;
    frame = self.viewUnavailable.frame;
    frame.origin.y = self.timeView.frame.origin.y + self.timeView.frame.size.height + 10;
    [self.viewUnavailable setFrame:frame];
    
    self.imgArea.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    self.imgArea.layer.borderWidth = 1.0f;
    self.txtDescription.delegate = self;
    self.txtRentals.delegate = self;
    self.txtAddress1.delegate = self;
    self.txtAddress2.delegate = self;
    self.txtSqft.delegate = self;
    self.txtZipcode.delegate = self;
    self.furnishOtherView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.furnishOtherView.layer.borderWidth = 1.0f;
    self.furnishShape.layer.borderColor = [[UIColor grayColor] CGColor];
    self.furnishShape.layer.borderWidth = 1.0f;
    self.lblFurnishOthers.layer.borderColor = [[UIColor grayColor] CGColor];
    self.lblFurnishOthers.layer.borderWidth = 1.0f;
    self.facilityOtherView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.facilityOtherView.layer.borderWidth = 1.0f;
    self.facilityShape.layer.borderColor = [[UIColor grayColor] CGColor];
    self.facilityShape.layer.borderWidth = 1.0f;
    self.lblFacilityOthers.layer.borderColor = [[UIColor grayColor] CGColor];
    self.lblFacilityOthers.layer.borderWidth = 1.0f;
    self.txtAddress1.delegate = self;
    self.txtAddress2.delegate = self;
    self.txtDescription.delegate = self;
    self.txtFacilityOthers.delegate = self;
    self.txtFurnishOthers.delegate = self;
    self.txtRentals.delegate = self;
    self.txtSqft.delegate = self;
    self.txtZipcode.delegate = self;
    
    NSDictionary *segTitleAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor grayColor], NSForegroundColorAttributeName,
                                       nil];
    
    [self.segType setTitleTextAttributes:segTitleAttribute forState:UIControlStateSelected];
    [self.segType setTitleTextAttributes:segTitleAttribute forState:UIControlStateNormal];
    
    [self.segFurnish setTitleTextAttributes:segTitleAttribute forState:UIControlStateSelected];
    [self.segFurnish setTitleTextAttributes:segTitleAttribute forState:UIControlStateNormal];
    
    [self.segParking setTitleTextAttributes:segTitleAttribute forState:UIControlStateSelected];
    [self.segParking setTitleTextAttributes:segTitleAttribute forState:UIControlStateNormal];
    
    [self.segRooms setTitleTextAttributes:segTitleAttribute forState:UIControlStateSelected];
    [self.segRooms setTitleTextAttributes:segTitleAttribute forState:UIControlStateNormal];
    
    [self.segToilets setTitleTextAttributes:segTitleAttribute forState:UIControlStateSelected];
    [self.segToilets setTitleTextAttributes:segTitleAttribute forState:UIControlStateNormal];
    
    UITapGestureRecognizer *yearTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onYearBtnPressed:)];
    [self.viewYear addGestureRecognizer:yearTap];
    
    UITapGestureRecognizer *monthTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMonthBtnPressed:)];
    [self.viewMonth addGestureRecognizer:monthTap];
    
    UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDateBtnPressed:)];
    [self.viewDate addGestureRecognizer:dateTap];
    
    UITapGestureRecognizer *ageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCriteriaAgeBtnPressed:)];
    [self.viewCriteriaAge addGestureRecognizer:ageTap];
    
    UITapGestureRecognizer *nationTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCriteriaNationalityBtnPressed:)];
    [self.viewCriteriaNationality addGestureRecognizer:nationTap];
    
    UITapGestureRecognizer *raceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCriteriaRaceBtnPressed:)];
    [self.viewCriteriaRace addGestureRecognizer:raceTap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [self.labelView setFrame:CGRectMake(0, 44, bounds.size.width, 40)];
        [cameraNavView setFrame:CGRectMake(0,0,bounds.size.width,70)];
        [cameraBtnView setFrame:CGRectMake(0,bounds.size.height - 70,bounds.size.width,70)];
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [self.dataView setFrame:CGRectMake(0, 64, bounds.size.width, 40)];
        [cameraNavView setFrame:CGRectMake(0,0,bounds.size.width,72)];
        [cameraBtnView setFrame:CGRectMake(0,bounds.size.height - 72,bounds.size.width,72)];
    }
    [self.dataView setFrame:CGRectMake(0,0,bounds.size.width,bounds.size.height)];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(84, 0, 0, 0);
    self.dataView.contentInset = contentInsets;
    self.dataView.scrollIndicatorInsets = contentInsets;
    self.dataView.contentOffset = CGPointMake(0, -84);
    [self.view bringSubviewToFront:self.labelView];
    [self.view bringSubviewToFront:self.navView];
    isCameraOn = FALSE;
    
    viewMeetingTime.layer.borderColor = [[UIColor grayColor] CGColor];
    viewMeetingTime.layer.borderWidth = 1.0f;
    
    viewPropertyDescription.layer.borderColor = [[UIColor grayColor] CGColor];
    viewPropertyDescription.layer.borderWidth = 1.0f;
    
    viewPhoto.layer.borderColor = [[UIColor grayColor] CGColor];
    viewPhoto.layer.borderWidth = 1.0f;
    
    viewFurnish.layer.borderColor = [[UIColor grayColor] CGColor];
    viewFurnish.layer.borderWidth = 1.0f;
    
    viewFacility.layer.borderColor = [[UIColor grayColor] CGColor];
    viewFacility.layer.borderWidth = 1.0f;
    
    viewPropertyDetail.layer.borderColor = [[UIColor grayColor] CGColor];
    viewPropertyDetail.layer.borderWidth = 1.0f;
    
    viewFiltering.layer.borderColor = [[UIColor grayColor] CGColor];
    viewFiltering.layer.borderWidth = 1.0f;
    [self getPostInfo];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (isCameraOn) {
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [self refreshLayout];
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.dataView.contentInset = contentInsets;
    self.dataView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    /*CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (activeField != nil) {
        CGPoint tPoint = activeField.frame.origin;
        tPoint.y += activeField.superview.frame.origin.y;
        tPoint.y = tPoint.y - self.dataView.contentOffset.y + activeField.frame.size.height;
        if ([activeField isEqual:self.txtFacilityOthers] || [activeField isEqual:self.txtFurnishOthers] || [activeField isEqual:self.txtSqft] || [activeField isEqual:self.txtRentals] || [activeField isEqual:self.txtAddress1] || [activeField isEqual:self.txtAddress2] || [activeField isEqual:self.txtZipcode]) {
            tPoint.x += activeField.superview.superview.frame.origin.x;
            tPoint.y += activeField.superview.superview.frame.origin.y;
        }
        if (!CGRectContainsPoint(aRect, tPoint)) {
            [self.dataView setContentOffset:CGPointMake(0.0, self.dataView.contentOffset.y + tPoint.y - aRect.size.height) animated:YES];
        }
    }else if (activeView != nil) {
        CGPoint tPoint = activeView.frame.origin;
        tPoint.y += activeView.superview.frame.origin.y;
        tPoint.y = tPoint.y - self.dataView.contentOffset.y + activeView.frame.size.height;
        if (!CGRectContainsPoint(aRect, tPoint)) {
            [self.dataView setContentOffset:CGPointMake(0.0, self.dataView.contentOffset.y + tPoint.y - aRect.size.height) animated:YES];
        }
    }*/
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (![scrollView isEqual:self.dataView]) {
        return;
    }
    if (!decelerate) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4f];
        [UIView setAnimationDelegate:self];
        CGRect rect = self.navView.frame;
        if (rect.origin.y < -(self.labelView.frame.size.height + rect.size.height) / 2) {
            lastScrollOffset = scrollView.contentOffset.y;
            [scrollView setContentOffset:CGPointMake(0,lastScrollOffset + (self.labelView.frame.size.height + rect.size.height + rect.origin.y))];
            rect.origin.y = -(self.labelView.frame.size.height + rect.size.height);
        }else {
            rect.origin.y = 0;
        }
        [self.navView setFrame:rect];
        rect = self.labelView.frame;
        rect.origin.y = self.navView.frame.origin.y + self.navView.frame.size.height;
        [self.labelView setFrame:rect];
        [UIView commitAnimations];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (![scrollView isEqual:self.dataView]) {
        return;
    }
    if (scrollView.contentOffset.y < 0) {
        return;
    }
    CGRect rect = self.navView.frame;
    if (scrollView.contentInset.top + scrollView.contentOffset.y < 0 && rect.origin.y >= 0) {
        return;
    }
    rect.origin.y -= (scrollView.contentOffset.y - lastScrollOffset);
    if (rect.origin.y >= 0) {
        rect.origin.y = 0;
    }
    if (rect.origin.y < -(self.labelView.frame.size.height + rect.size.height)) {
        rect.origin.y = -(self.labelView.frame.size.height + rect.size.height);
    }
    [self.navView setFrame:rect];
    rect = self.labelView.frame;
    rect.origin.y = self.navView.frame.origin.y + self.navView.frame.size.height;
    [self.labelView setFrame:rect];
    
    lastScrollOffset = scrollView.contentOffset.y;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.navView.frame.size.height + self.labelView.frame.size.height, 0, 0, 0);
    self.dataView.contentInset = contentInsets;
    self.dataView.scrollIndicatorInsets = contentInsets;
}

-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField
{
    activeField = textField;
    [dateView setHidden:YES];
    [yearView setHidden:YES];
    [monthView setHidden:YES];
    [criteriaAgeView setHidden:YES];
    [criteriaNationalityView setHidden:YES];
    [criteriaRaceView setHidden:YES];
    [propView setHidden:YES];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    if ([textField isEqual:self.txtZipcode]) {
        [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Go" style:UIBarButtonItemStyleDone target:self action:@selector(onSaveBtnPressed:)],
                                nil]];
    }else {
        [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                    [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(onNextBtnPressed:)],
                                    [[UIBarButtonItem alloc]initWithTitle:@"Go" style:UIBarButtonItemStyleDone target:self action:@selector(onSaveBtnPressed:)],
                                    nil]];
    }
    textField.inputAccessoryView = keyboardToolBar;
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    activeView = textView;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(onNextBtnPressed:)],
                                [[UIBarButtonItem alloc]initWithTitle:@"Go" style:UIBarButtonItemStyleDone target:self action:@selector(onSaveBtnPressed:)],
                                nil]];
    textView.inputAccessoryView = keyboardToolBar;
    return YES;
}
// Called when the UIKeyboardDidShowNotification is sent.

-(void)textFieldDidBeginEditing: (UITextField *)textField
{
    activeField = textField;
}

-(void)textViewDidBeginEditing: (UITextView *)textView
{
    activeView = textView;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    activeField = nil;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    activeView = nil;
    return YES;
}

- (void)dismissKeyboard {
    [yearView setHidden:YES];
    [monthView setHidden:YES];
    [dateView setHidden:YES];
    [criteriaAgeView setHidden:YES];
    [criteriaRaceView setHidden:YES];
    [criteriaNationalityView setHidden:YES];
    [propView setHidden:YES];
    [self.view endEditing:YES];
}

- (IBAction)onNextBtnPressed:(id)sender {
    if ([activeView isEqual:self.txtDescription]) {
        [self.txtFurnishOthers becomeFirstResponder];
    }else if ([activeField isEqual:self.txtFurnishOthers]) {
        [self.txtFacilityOthers becomeFirstResponder];
    }else if ([activeField isEqual:self.txtFacilityOthers]) {
        if (self.segType.selectedSegmentIndex == 0) {
            [self.txtSqft becomeFirstResponder];
        }else {
            [self.txtName becomeFirstResponder];
        }
    }else if ([activeField isEqual:self.txtName]) {
        [self.txtUnit becomeFirstResponder];
    }else if ([activeField isEqual:self.txtUnit]) {
        [self.txtSqft becomeFirstResponder];
    }else if ([activeField isEqual:self.txtSqft]) {
        [self.txtRentals becomeFirstResponder];
    }else if ([activeField isEqual:self.txtRentals]) {
        [self.txtAddress1 becomeFirstResponder];
    }else if ([activeField isEqual:self.txtAddress1]) {
        [self.txtAddress2 becomeFirstResponder];
    }else if ([activeField isEqual:self.txtAddress2]) {
        [self.txtZipcode becomeFirstResponder];
    }
}

- (void) onFurnishBtnPressed:(UIButton *)sender {
    NSArray *furnishSubViews = self.furnishView.subviews;
    UIColor *selColor = [[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
    if ([sender.backgroundColor isEqual:selColor]) {
        sender.backgroundColor = [UIColor clearColor];
        sender.layer.borderWidth = 1.0f;
    }else {
        sender.backgroundColor = selColor;
        sender.layer.borderWidth = 0.0f;
    }
    BOOL isFull = true;
    BOOL isEmpty = true;
    for (int i = 0; i < furnishSubViews.count; i += 2) {
        UIButton *furnishButton = (UIButton *)[furnishSubViews objectAtIndex:i];
        if (![furnishButton.backgroundColor isEqual:selColor]) {
            isFull = false;
        }
        if ([furnishButton.backgroundColor isEqual:selColor]) {
            isEmpty = false;
        }
    }
    if (isFull) {
        self.segFurnish.selectedSegmentIndex = 0;
    }else if (isEmpty) {
        self.segFurnish.selectedSegmentIndex = 2;
    }else {
        self.segFurnish.selectedSegmentIndex = 1;
    }
}

- (void) onFacilityBtnPressed:(UIButton *)sender {
    //NSArray *facilitySubViews = self.facilityView.subviews;
    UIColor *selColor = [[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
    if ([sender.backgroundColor isEqual:selColor]) {
        sender.backgroundColor = [UIColor clearColor];
        sender.layer.borderWidth = 1.0f;
    }else {
        sender.backgroundColor = selColor;
        sender.layer.borderWidth = 0.0f;
    }
    /*for (int i = 0; i < facilitySubViews.count; i++) {
        if ([[facilitySubViews objectAtIndex:i]  isEqual:sender]) {
            UILabel *facilityNameLabel = (UILabel *)[facilitySubViews objectAtIndex:i + 1];
            if ([sender.backgroundColor isEqual:selColor]) {
                facilityNameLabel.textColor = selColor;
            }else {
                facilityNameLabel.textColor = [UIColor grayColor];
            }
        }
    }*/
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [propView setHidden:YES];
    [textField resignFirstResponder];
    return YES;
}

- (void)checkButton : (UIButton *)sender
{
    if (sender.backgroundColor == [UIColor whiteColor]) {
        [sender setBackgroundColor:[UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0]];
    }else {
        sender.backgroundColor = [UIColor whiteColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAddOtherFurnishBtnPressed:(id)sender {
    if (self.txtFurnishOthers.text == nil || [[self.txtFurnishOthers.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"Please Enter Furnish Name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    NSArray *furnishSubViews = self.furnishView.subviews;
    for (int i = 1; i < furnishSubViews.count; i += 2) {
        UILabel *furnishLabel = (UILabel *)[furnishSubViews objectAtIndex:i];
        if ([furnishLabel.text isEqualToString:self.txtFurnishOthers.text]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"Duplicate Furnish Name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
    }
    UIButton *selBtn = [[UIButton alloc] initWithFrame:CGRectMake(((furnishSubViews.count  / 2) % 2) * 135,(furnishSubViews.count / 4) * 30,26,26)];
    selBtn.layer.cornerRadius = 13.0f;
    selBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    selBtn.layer.borderWidth = 0.0f;
    selBtn.backgroundColor = [[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
    [selBtn addTarget:self action:@selector(onFurnishBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.furnishView addSubview:selBtn];
    UILabel *selLabel = [[UILabel alloc] initWithFrame:CGRectMake(35 + ((furnishSubViews.count / 2) % 2) * 135, (furnishSubViews.count / 4) * 30,100,26)];
    [selLabel setFont:[UIFont systemFontOfSize:10.0f]];
    selLabel.textColor = [UIColor grayColor]; //[[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
    selLabel.text = self.txtFurnishOthers.text;
    selLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelFurnishTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(furnishGestureCaptured:)];
    [selLabel addGestureRecognizer:labelFurnishTap];
    self.txtFurnishOthers.text = @"";
    [self.furnishView addSubview:selLabel];
    CGRect frame = self.furnishView.frame;
    frame.size.height = (furnishSubViews.count / 4 + 1) * 30;
    [self.furnishView setFrame:frame];
    [self refreshLayout];
}

- (IBAction)onAddOtherFacilityBtnPressed:(id)sender {
    if (self.txtFacilityOthers.text == nil || [[self.txtFacilityOthers.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"Please Enter Facility Name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    NSArray *facilitySubViews = self.facilityView.subviews;
    for (int i = 1; i < facilitySubViews.count; i += 2) {
        UILabel *facilityLabel = (UILabel *)[facilitySubViews objectAtIndex:i];
        if ([facilityLabel.text isEqualToString:self.txtFacilityOthers.text]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"Duplicate Facility Name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
    }
    UIButton *selBtn = [[UIButton alloc] initWithFrame:CGRectMake(((facilitySubViews.count / 2) % 2) * 135,(facilitySubViews.count / 4) * 30,26,26)];
    selBtn.backgroundColor = [[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
    selBtn.layer.cornerRadius = 13.0f;
    selBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    selBtn.layer.borderWidth = 0.0f;
    [selBtn addTarget:self action:@selector(onFacilityBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.facilityView addSubview:selBtn];
    UILabel *selLabel = [[UILabel alloc] initWithFrame:CGRectMake(35 + ((facilitySubViews.count / 2) % 2) * 135, (facilitySubViews.count / 4) * 30,100,26)];
    [selLabel setFont:[UIFont systemFontOfSize:10.0f]];
    selLabel.textColor = [UIColor grayColor]; //[[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
    selLabel.text = self.txtFacilityOthers.text;
    selLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelFacilityTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(facilityGestureCaptured:)];
    [selLabel addGestureRecognizer:labelFacilityTap];
    self.txtFacilityOthers.text = @"";
    [self.facilityView addSubview:selLabel];
    CGRect frame = self.furnishView.frame;
    frame.size.height = (facilitySubViews.count / 4 + 1) * 30;
    [self.facilityView setFrame:frame];
    [self refreshLayout];
}

- (void) setEnable:(BOOL)enable
{
    [self.view setUserInteractionEnabled:enable];
}

- (IBAction)onBackBtnPressed:(id)sender {
    if (photoPicker != nil && photoPicker.view.frame.origin.x == 0) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect frame = photoPicker.view.frame;
            frame.origin.x = 320;
            [photoPicker.view setFrame:frame];
        } completion:^(BOOL finished) {
            
            NSMutableArray *curImageList;
            if ([self.imgPhotoView getImageList] != nil) {
                curImageList = [[NSMutableArray alloc] initWithArray:[self.imgPhotoView getImageList]];
            }else {
                curImageList = [[NSMutableArray alloc] init];
            }
            while (curImageList.count > curNumImage) {
                [curImageList removeLastObject];
            }
            [self.imgPhotoView setImageList:curImageList type:1];
            [photoPicker dismissViewControllerAnimated:YES completion:nil];
        }];
    }else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)onSaveBtnPressed:(id)sender {
    [self.view endEditing:YES];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    int month = 0;
    for (int i = 0; i < months.count; i++) {
        if ([[months objectAtIndex:i] isEqualToString:self.lblMonth.text]) {
            month = i + 1;
            break;
        }
    }
    NSString *availability = [NSString stringWithFormat:@"%@-%d-%@",self.lblYear.text,month,self.lblDate.text];
    NSString *timeStr = @"[";
    int quality = 0;
    BOOL isSelected = NO;
    for (int i = 0; i < 7; i++) {
        if (i > 0) {
            timeStr = [NSString stringWithFormat:@"%@,",timeStr];
        }
        timeStr = [NSString stringWithFormat:@"%@[",timeStr];
        for (int j = 0; j < 4; j++) {
            if (j > 0) {
                timeStr = [NSString stringWithFormat:@"%@,",timeStr];
            }
            UIButton *timeBtn = (UIButton *)[self.timeView.subviews objectAtIndex:(j + 1) * 8 + i];
            if ([timeBtn.backgroundColor isEqual:[UIColor whiteColor]]) {
                timeStr = [NSString stringWithFormat:@"%@0",timeStr];
            }else {
                timeStr = [NSString stringWithFormat:@"%@1",timeStr];
                isSelected = YES;
                quality = 1;
            }
        }
        timeStr = [NSString stringWithFormat:@"%@]",timeStr];
    }
    if (!isSelected) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Edit Post" message:@"Please Select At Least One Time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    /*if (self.imgCameraView.subviews.count >=3) {
        quality++;
    }else if (self.imgCameraView.subviews.count >= 5) {
        quality += 2;
    }else if (self.imgCameraView.subviews.count >= 8) {
        quality += 5;
    }*/
    timeStr = [NSString stringWithFormat:@"%@]",timeStr];
    NSMutableArray *furnishList = [[NSMutableArray alloc] init];
    NSString *furnishes = @"[";
    int k = 0;
    for (int i = 1; i < self.furnishView.subviews.count ; i += 2) {
        UIButton *btnFurnish = (UIButton *)[self.furnishView.subviews objectAtIndex:i - 1];
        UILabel *lblFurnish = (UILabel *)[self.furnishView.subviews objectAtIndex:i];
        if (![btnFurnish.backgroundColor isEqual:[UIColor clearColor]]) {
            if (k > 0) {
                furnishes = [NSString stringWithFormat:@"%@,",furnishes];
            }
            furnishes = [NSString stringWithFormat:@"%@\"%@\"",furnishes,lblFurnish.text];
            k++;
        }
        [furnishList addObject:lblFurnish.text];
    }
    furnishes = [NSString stringWithFormat:@"%@]",furnishes];
    
    NSMutableArray *facilityList = [[NSMutableArray alloc] init];
    
    NSString *facilities = @"[";
    k = 0;
    for (int i = 1; i < self.facilityView.subviews.count ; i += 2) {
        UILabel *labelFacility = (UILabel *)[self.facilityView.subviews objectAtIndex:i];
        UIButton *btnFacility = (UIButton *)[self.facilityView.subviews objectAtIndex:i - 1];
        if (![btnFacility.backgroundColor isEqual:[UIColor clearColor]]) {
            if (k > 0) {
                facilities = [NSString stringWithFormat:@"%@,",facilities];
            }
            facilities = [NSString stringWithFormat:@"%@\"%@\"",facilities,labelFacility.text];
            k++;
        }
        [facilityList addObject:labelFacility.text];
    }
    facilities = [NSString stringWithFormat:@"%@]",facilities];
    NSString *description = self.txtDescription.text;
    if (description == nil) {
        description = @"";
    }
    description = [description stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *name = self.txtName.text;
    NSString *unit = self.txtUnit.text;
    if (unit == nil) {
        unit = @"";
    }
    NSInteger type = self.segType.selectedSegmentIndex + 1;
    if (type == 2 && (name == nil || [[name stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Edit Post" message:@"Please Enter Building Name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    NSInteger rooms = self.segRooms.selectedSegmentIndex;
    NSInteger toilets = self.segToilets.selectedSegmentIndex + 1;
    NSInteger parkings = self.segParking.selectedSegmentIndex;
    NSString *sqft = self.txtSqft.text;
    if (sqft == nil) {
        sqft = @"";
    }
    NSString *rentals = self.txtRentals.text;
    if (rentals == nil) {
        rentals = @"";
    }
    
    if ([[rentals stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Edit Post" message:@"Please enter rental" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    if ([rentals intValue] <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Edit Post" message:@"Invalid Rental Value" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    NSInteger furnish_type = self.segFurnish.selectedSegmentIndex + 1;
    NSString *address1 = self.txtAddress1.text;
    if (address1 == nil) {
        address1 = @"";
    }
    if ([[address1 stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Edit Post" message:@"Please enter address" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    NSString *address2 = self.txtAddress2.text;
    if (address2 == nil) {
        address2 = @"";
    }
    NSString *zipcode = self.txtZipcode.text;
    if (zipcode == nil) {
        zipcode = @"";
    }
    if ([[zipcode stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Edit Post" message:@"Please enter zipcode" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }else if (![delegate isValidPinCode:zipcode]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Edit Post" message:@"Invalid Zipcode" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    if ([sqft intValue] <= 0 || [sqft intValue] > 32767) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Edit Post" message:@"Size Out of Range" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    if (self.segParking.selectedSegmentIndex > 0) {
        quality++;
    }
    if (![availability isEqualToString:@""]) {
        quality++;
    }
    if (![self.txtRentals.text isEqualToString:@""]) {
        quality++;
    }
    if (![address1 isEqualToString:@""]) {
        quality++;
    }
    if (![address2 isEqualToString:@""]) {
        quality++;
    }
    if (![description isEqualToString:@""]) {
        quality++;
    }
    
    NSString *age = @"";
    if (![self.lblCriteriaAge.text isEqual:@""] && ![self.lblCriteriaAge.text isEqual:@"Any"]) {
        age = [self.lblCriteriaAge.text substringFromIndex:1];
    }
    NSString *nationality = @"";
    if (![self.lblCriteriaNationality.text isEqual:@""] && ![self.lblCriteriaNationality.text isEqual:@"Any"]) {
        nationality = self.lblCriteriaNationality.text;
    }
    NSString *race = @"";
    if (![self.lblCriteriaRace.text isEqual:@""] && ![self.lblCriteriaAge.text isEqual:@"Any"]) {
        race = self.lblCriteriaRace.text;
    }
    /*dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        NSString *reqString = [NSString stringWithFormat:@"%@?task=postsave&time=%@&address1=%@&address2=%@&zipcode=%@&availability=%@&rentals=%@&furnish_type=%ld&description=%@&type=%ld&rooms=%ld&&toilets=%ld&parkings=%ld&sqft=%@&id=%@&furnishes=%@&facilities=%@&quality=%d&age=%@&nationality=%@&race=%@", actionUrl,timeStr,address1,address2, zipcode, availability,rentals,(long)furnish_type,description,(long)type,(long)rooms,(long)toilets,(long)parkings,sqft,pid,furnishes,facilities,quality,age,nationality,race];
        reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:reqString];
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
        [self performSelectorOnMainThread:@selector(doneSavePostInfo:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });*/
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Get Property Data
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(userid=%d) and (propertyid=%d)",[delegate.userid intValue],[delegate.pid intValue]]];
    
    NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
    [fetchRequest setEntity:propEntity];
    NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (propObjects.count > 0) {
        Property *propObject = (Property *)[propObjects objectAtIndex:0];
        propObject.userid = [NSNumber numberWithInt:[delegate.userid intValue]];
        propObject.name = name;
        propObject.unit = unit;
        propObject.quality = [NSNumber numberWithInt:quality];
        propObject.type = [NSNumber numberWithLong:type];
        propObject.rooms = [NSNumber numberWithLong:rooms];
        propObject.toilets = [NSNumber numberWithLong:toilets];
        propObject.sqft = [NSNumber numberWithInt:[sqft intValue]];
        propObject.parkings = [NSNumber numberWithLong:parkings];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-M-d"];
        propObject.availability = [dateFormat dateFromString:availability];
        propObject.rental = [NSString stringWithFormat:@"%@",rentals];
        propObject.furnish_type = [NSNumber numberWithLong:furnish_type];
        propObject.address1 = address1;
        propObject.address2 = address2;
        propObject.zipcode = zipcode;
        propObject.age = age;
        propObject.race = race;
        propObject.prefertimestart = prefertimestart;
        propObject.nationality = nationality;
        if (address1 != nil && ![address1 isEqualToString:@""]) {
            NSDictionary *geoloc = [delegate getGeolocation:[NSString stringWithFormat:@"%@ Malaysia",address1]];
            if (geoloc != nil) {
                propObject.latitude = [geoloc objectForKey:@"lat"];
                propObject.longitude = [geoloc objectForKey:@"lng"];
            }
        }
        propObject.time = timeStr;
        propObject.status = [NSNumber numberWithInt:1];
        propObject.datecreated = [NSDate date];
        [propObject removeImgInfo:propObject.imgInfo];
        for (int i = 0; i < [self.imgPhotoView getImageList].count; i++) {
            NSData *imgData = [[[self.imgPhotoView getImageList] objectAtIndex:i] objectForKey:@"data"];
            NSString *imgStr = [[[self.imgPhotoView getImageList] objectAtIndex:i] objectForKey:@"path"];
            PropertyImage *imageObject = [NSEntityDescription insertNewObjectForEntityForName:@"PropertyImage" inManagedObjectContext:context];
            if (imgData != nil) {
                imageObject.data = imgData;
            }
            imageObject.path = imgStr;
            imageObject.propertyid = [NSNumber numberWithInt:[delegate.pid intValue]];
            imageObject.datecreated = [NSDate date];
            imageObject.propertyInfo = propObject;
        }
        [propObject removeFurnishInfo:propObject.furnishInfo];
        for (int i = 1; i < self.furnishView.subviews.count; i += 2) {
            UILabel *labelFurnish = (UILabel *)[self.furnishView.subviews objectAtIndex:i];
            UIButton *btnFurnish = (UIButton *)[self.furnishView.subviews objectAtIndex:i - 1];
            if (![btnFurnish.backgroundColor isEqual:[UIColor clearColor]]) {
                PropertyFurnish *furnishObject = [NSEntityDescription insertNewObjectForEntityForName:@"PropertyFurnish" inManagedObjectContext:context];
                furnishObject.propertyid = [NSNumber numberWithInt:[delegate.pid intValue]];
                furnishObject.furnish_name = labelFurnish.text;
                furnishObject.propertyInfo = propObject;
            }
        }
        [propObject removeFacilityInfo:propObject.facilityInfo];
        for (int i = 1; i < self.facilityView.subviews.count; i += 2) {
            UILabel *labelFacility = (UILabel *)[self.facilityView.subviews objectAtIndex:i];
            UIButton *btnFacility = (UIButton *)[self.facilityView.subviews objectAtIndex:i - 1];
            if (![btnFacility.backgroundColor isEqual:[UIColor clearColor]]) {
                PropertyFacility *facilityObject = [NSEntityDescription insertNewObjectForEntityForName:@"PropertyFacility" inManagedObjectContext:context];
                facilityObject.propertyid = [NSNumber numberWithInt:[delegate.pid intValue]];
                facilityObject.facility_name = labelFacility.text;
                facilityObject.propertyInfo = propObject;
            }
        }
        for (int i = 0; i < furnishList.count; i++) {
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name='%@'",[furnishList objectAtIndex:i]]]];
            NSEntityDescription *furnishEntity = [NSEntityDescription entityForName:@"Furnish" inManagedObjectContext:context];
            [fetchRequest setEntity:furnishEntity];
            NSArray *furnishObjects = [context executeFetchRequest:fetchRequest error:&error];
            if (furnishObjects.count == 0) {
                Furnish *furnishObject = [NSEntityDescription insertNewObjectForEntityForName:@"Furnish" inManagedObjectContext:context];
                furnishObject.name = [furnishList objectAtIndex:i];
            }
        }
        for (int i = 0; i < facilityList.count; i++) {
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name='%@'",[facilityList objectAtIndex:i]]]];
            NSEntityDescription *facilityEntity = [NSEntityDescription entityForName:@"Facility" inManagedObjectContext:context];
            [fetchRequest setEntity:facilityEntity];
            NSArray *facilityObjects = [context executeFetchRequest:fetchRequest error:&error];
            if (facilityObjects.count == 0) {
                Facility *facilityObject = [NSEntityDescription insertNewObjectForEntityForName:@"Facility" inManagedObjectContext:context];
                facilityObject.name = [facilityList objectAtIndex:i];
            }
        }
        [delegate saveContext];
        NSDictionary *params = @{@"task":@"postsave",
                                 @"time":timeStr,
                                 @"description":description,
                                 @"furnishes":furnishes,
                                 @"facilities":facilities,
                                 @"type":[NSString stringWithFormat:@"%ld",(long)type],
                                 @"rooms":[NSString stringWithFormat:@"%ld",(long)rooms],
                                 @"toilets":[NSString stringWithFormat:@"%ld",(long)toilets],
                                 @"parkings":[NSString stringWithFormat:@"%ld",(long)parkings],
                                 @"sqft":sqft,
                                 @"availability":availability,
                                 @"rentals":rentals,
                                 @"furnish_type":[NSString stringWithFormat:@"%ld",(long)furnish_type],
                                 @"address1":address1,
                                 @"address2":address2,
                                 @"zipcode":zipcode,
                                 @"age":age,
                                 @"race":race,
                                 @"nationality":nationality,
                                 @"id":delegate.pid,
                                 @"name":name,
                                 @"unit":unit,
                                 @"userid":delegate.userid,
                                 @"prefertimestart":prefertimestart,
                                 };
        NSURL *url = [NSURL URLWithString:actionUrl];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/json/index.php" parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            NSMutableArray *imageList = [NSMutableArray arrayWithArray:[self.imgPhotoView getImageList]];
            for (int i = 0; i < imageList.count; i++) {
                NSDictionary *image = (NSDictionary *)[imageList objectAtIndex:i];
                if ([image objectForKey:@"data"] != nil) {
                    NSData *imgData = UIImageJPEGRepresentation([UIImage imageWithData:[image objectForKey:@"data"]],1);
                    [formData appendPartWithFileData:imgData name:@"photo[]" fileName:[NSString stringWithFormat:@"photo%d.jpg",i] mimeType:@"image/jpeg"];
                }
            }
        }];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        }];
        /*[httpClient enqueueBatchOfHTTPRequestOperationsWithRequests:@[operation] progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
            
        } completionBlock:^(NSArray *operations) {
            
        }];*/
        [httpClient enqueueHTTPRequestOperation:operation];
        /*NSString *imgString = @"";
        for (int i = 0; i < [self.imgPhotoView getImageList].count; i++) {
            NSData *imgData = [[self.imgPhotoView getImageList] objectAtIndex:i];
            if (![imgString isEqualToString:@""]) {
                imgString = [NSString stringWithFormat:@"%@,",imgString];
            }
            if ([NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)]) {
                imgString = [NSString stringWithFormat:@"%@%@",imgString,[imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
            } else {
                imgString = [NSString stringWithFormat:@"%@%@",imgString,[imgData base64Encoding]];
            }
        }
        AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:actionUrl]];
        
        [client
         postPath:@"/json/index.php"
         parameters:params
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (operation.response.statusCode != 200) {
                 NSLog(@"Failed");
             } else {
                 NSDictionary *dataDict = (NSDictionary*)[operation.responseString JSONValue];
                 if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                     propObject.propertyid = [NSNumber numberWithInt:[[dataDict objectForKey:@"id"] intValue]];
                     [delegate saveContext];
                 }
                 NSLog(@"Success");
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if ([self isViewLoaded]) {
                 NSLog(@"Failed");
             }
        }];*/
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        if ([propObject.quality intValue] > delegate.beforePoint) {
            PostEditSuccessViewController *postEditSuccessViewController = [[PostEditSuccessViewController alloc] init];
            postEditSuccessViewController.lblPropertyName.text = self.lblPropertyName.text;
            [self.navigationController pushViewController:postEditSuccessViewController animated:YES];
        }else {
            MyNavigationController *navController = (MyNavigationController *)self.navigationController;
            for (int i = 0; i < navController.viewControllers.count; i++) {
                if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[PostViewController class]]) {
                    PostViewController *postViewController = (PostViewController *)[navController.viewControllers objectAtIndex:i];
                    [postViewController getListInfo];
                    [navController popToViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
                    return;
                }
            }
            PostViewController *postViewController = [[PostViewController alloc] init];
            [postViewController getListInfo];
            [navController pushViewController:postViewController animated:YES];
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"Not Found Such Like This Property Name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
}

- (IBAction)onYearBtnPressed:(id)sender {
    [self.view endEditing:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([yearView isHidden]) {
        long curYear;
        NSDate *curDate = [NSDate date];
        long firstYear = [delegate getYear:curDate];
        if ([self.lblYear.text isEqualToString:@"-"]) {
            curYear = firstYear;
        }else {
            curYear = [self.lblYear.text intValue];
        }
        if (curYear - firstYear > 13) {
            curYear = firstYear + 13;
        }
        [yearView setContentOffset:CGPointMake(0,(curYear - firstYear) * 20)];
        [yearView setHidden:NO];
        [monthView setHidden:YES];
        [dateView setHidden:YES];
        [criteriaAgeView setHidden:YES];
        [criteriaRaceView setHidden:YES];
        [criteriaNationalityView setHidden:YES];
        [propView setHidden:YES];
    }else {
        [yearView setHidden:YES];
    }
}

- (IBAction)onMonthBtnPressed:(id)sender {
    [self.view endEditing:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([monthView isHidden]) {
        NSString *curMonthStr = self.lblMonth.text;
        NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
        long curMonth = 0;
        long startMonth = 0;
        if ([self.lblYear.text intValue] == [delegate getYear:[NSDate date]]) {
            startMonth = [delegate getMonth:[NSDate date]] - 1;
        }
        for (long i = startMonth; i < 12; i++) {
            if ([[months objectAtIndex:i] isEqualToString:curMonthStr]) {
                curMonth = i;
                break;
            }
        }
        if (curMonth > 5) {
            if (startMonth > 6) {
                curMonth = startMonth;
            }else {
                curMonth = 6;
            }
        }
        [monthView setContentOffset:CGPointMake(0,(curMonth - startMonth) * 20)];
        [monthView setHidden:NO];
        [yearView setHidden:YES];
        [dateView setHidden:YES];
        [criteriaAgeView setHidden:YES];
        [criteriaRaceView setHidden:YES];
        [criteriaNationalityView setHidden:YES];
        [propView setHidden:YES];
    }else {
        [monthView setHidden:YES];
    }
}

- (IBAction)onFurnishPressed:(id)sender {
    [dateView setHidden:YES];
    [yearView setHidden:YES];
    [monthView setHidden:YES];
    int k = 0;
    for (int i = 1; i < self.furnishView.subviews.count; i += 2) {
        for (int j = 0; j < normalFurnishList.count; j++) {
            UILabel *curLabel = (UILabel *)[self.furnishView.subviews objectAtIndex:i];
            UIButton *curButton = (UIButton *)[self.furnishView.subviews objectAtIndex:i - 1];
            if ([curLabel.text isEqualToString:[normalFurnishList objectAtIndex:j]]) {
                if (self.segFurnish.selectedSegmentIndex == 0) {
                    curLabel.textColor = [UIColor grayColor]; //[UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                    curButton.backgroundColor = [UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                    curButton.layer.borderWidth = 0.0f;
                }else if (self.segFurnish.selectedSegmentIndex == 1 && k < normalFurnishList.count / 2) {
                    curLabel.textColor = [UIColor grayColor]; //[UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                    curButton.backgroundColor = [UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                    curButton.layer.borderWidth = 0.0f;
                }else {
                    curLabel.textColor = [UIColor grayColor];
                    curButton.backgroundColor = [UIColor clearColor];
                    curButton.layer.borderWidth = 1.0f;
                }
                k++;
                break;
            }
        }
    }
    k = 0;
    for (int i = 1; i < self.facilityView.subviews.count; i += 2) {
        for (int j = 0; j < normalFacilityList.count; j++) {
            UILabel *curLabel = (UILabel *)[self.facilityView.subviews objectAtIndex:i];
            UIButton *curButton = (UIButton *)[self.facilityView.subviews objectAtIndex:i - 1];
            if ([curLabel.text isEqualToString:[normalFacilityList objectAtIndex:j]]) {
                if (self.segFurnish.selectedSegmentIndex == 0) {
                    curLabel.textColor = [UIColor grayColor]; //[UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                    curButton.backgroundColor = [UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                    curButton.layer.borderWidth = 0.0f;
                }else if (self.segFurnish.selectedSegmentIndex == 1 && k < normalFacilityList.count / 2) {
                    curLabel.textColor = [UIColor grayColor]; //[UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                    curButton.backgroundColor = [UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                    curButton.layer.borderWidth = 0.0f;
                }else {
                    curLabel.textColor = [UIColor grayColor];
                    curButton.backgroundColor = [UIColor clearColor];
                    curButton.layer.borderWidth = 1.0f;
                }
                k++;
                break;
            }
        }
    }
}

- (IBAction)onSkipBtnPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onCriteriaAgeBtnPressed:(id)sender {
    if ([criteriaAgeView isHidden]) {
        NSArray *ageArray = [[NSArray alloc] initWithObjects:@"Any", @">18",@">25",@">30",@">35",@">40", nil];
        for (int i = 0; i < ageArray.count; i++) {
            if ([self.lblCriteriaAge.text isEqualToString:[ageArray objectAtIndex:i]]) {
                [criteriaAgeView setContentOffset:CGPointMake(0, i * 20)];
                break;
            }
        }
        [self.view endEditing:YES];
        [criteriaAgeView setHidden:NO];
        [criteriaNationalityView setHidden:YES];
        [criteriaRaceView setHidden:YES];
        [yearView setHidden:YES];
        [monthView setHidden:YES];
        [dateView setHidden:YES];
        [propView setHidden:YES];
    }else {
        [criteriaAgeView setHidden:YES];
    }
}

- (IBAction)onCriteriaRaceBtnPressed:(id)sender {
    if ([criteriaRaceView isHidden]) {
        for (int i = 0; i < raceList.count; i++) {
            if ([self.lblCriteriaRace.text isEqualToString:[raceList objectAtIndex:i]]) {
                [criteriaRaceView setContentOffset:CGPointMake(0,i * 20)];
            }
        }
        [self.view endEditing:YES];
        [criteriaRaceView setHidden:NO];
        [criteriaNationalityView setHidden:YES];
        [criteriaAgeView setHidden:YES];
        [yearView setHidden:YES];
        [monthView setHidden:YES];
        [dateView setHidden:YES];
        [propView setHidden:YES];
    }else {
        [criteriaRaceView setHidden:YES];
    }
}

- (IBAction)onCriteriaNationalityBtnPressed:(id)sender {
    if ([criteriaNationalityView isHidden]) {
        for (int i = 0; i < nationalityList.count; i++) {
            if ([self.lblCriteriaNationality.text isEqualToString:[nationalityList objectAtIndex:i]]) {
                [criteriaNationalityView setContentOffset:CGPointMake(0,i * 20)];
            }
        }
        [self.view endEditing:YES];
        [criteriaNationalityView setHidden:NO];
        [criteriaRaceView setHidden:YES];
        [criteriaAgeView setHidden:YES];
        [yearView setHidden:YES];
        [monthView setHidden:YES];
        [dateView setHidden:YES];
        [propView setHidden:YES];
    }else {
        [criteriaNationalityView setHidden:YES];
    }
}

- (IBAction)onMorePhotoBtnPressed:(id)sender {
    photoPicker = [[UIImagePickerController alloc] init];
    
    photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    photoPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    photoPicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    CGRect rect = [[UIScreen mainScreen] bounds];
    [photoPicker.view setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    photoPicker.showsCameraControls = NO;
    photoPicker.navigationBarHidden = YES;
    photoPicker.toolbarHidden = YES;
    //photoPicker.wantsFullScreenLayout = YES;
    CGAffineTransform cameraLocTransform = CGAffineTransformMakeTranslation(0, 70);
    photoPicker.cameraViewTransform = cameraLocTransform;
    photoPicker.allowsEditing = YES;
    photoPicker.cameraOverlayView = cameraView;
    photoPicker.delegate = self;
    [photoPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:photoPicker animated:NO completion:^{
        isCameraOn = TRUE;
        isTaken = FALSE;
        if ([self.imgPhotoView getImageList] != nil) {
            curNumImage = (int)[self.imgPhotoView getImageList].count;
        }else {
            curNumImage = 0;
        }
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (IBAction)onTakeBtnPressed:(id)sender {
    [photoPicker takePicture];
}

- (IBAction)onLibraryBtnPressed:(id)sender {
    [photoPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)onDoneBtnPressed:(id)sender {
    if (isTaken) {
        return;
    }
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = photoPicker.view.frame;
        frame.origin.x = 320;
        [photoPicker.view setFrame:frame];
    } completion:^(BOOL finished) {
        [photoPicker dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)onTypeChanged:(id)sender {
    if (self.segType.selectedSegmentIndex == 0) {
        [self.lblName setHidden:YES];
        [self.txtName setHidden:YES];
        [self.lblUnit setHidden:YES];
        [self.txtUnit setHidden:YES];
    }else {
        [self.lblName setHidden:NO];
        [self.txtName setHidden:NO];
        [self.lblUnit setHidden:NO];
        [self.txtUnit setHidden:NO];
    }
    [self refreshLayout];
}

- (IBAction)onNameChanged:(id)sender {
    if ([sender isEqual:self.txtName]) {
        [propView setFrame:CGRectMake(self.txtName.frame.origin.x, self.txtName.frame.origin.y + self.txtName.frame.size.height, self.txtName.frame.size.width, 120)];
        UITextField *textField = (UITextField *)sender;
        if (textField.text == nil || [textField.text isEqualToString:@""]) {
            [propView setHidden:YES];
            return;
        }
        for (int i = 0; i < propList.count; i++) {
            NSString *compareStr = [[propList objectAtIndex:i] valueForKey:@"name"];
            if ([compareStr isEqualToString:self.txtName.text]) {
                self.txtAddress1.text = [[propList objectAtIndex:i] valueForKey:@"address1"];
                self.txtAddress2.text = [[propList objectAtIndex:i] valueForKey:@"address2"];
                self.txtZipcode.text = [[propList objectAtIndex:i] valueForKey:@"zipcode"];
                self.txtUnit.text = [NSString stringWithFormat:@"%@",[[propList objectAtIndex:i] valueForKey:@"unit"]];
                break;
            }
        }
        [curPropList removeAllObjects];
        for (int i = 0; i < propList.count; i++) {
            NSString *nameStr = [[propList objectAtIndex:i] valueForKey:@"name"];
            if ([[nameStr lowercaseString] hasPrefix:[textField.text lowercaseString]]) {
                [curPropList addObject:[propList objectAtIndex:i]];
            }
        }
        if (curPropList.count == 0) {
            [propView setHidden:YES];
            return;
        }
        if ([sender isEqual:self.txtName] && self.segType.selectedSegmentIndex == 1) {
            [propView setHidden:NO];
            [propView reloadData];
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    //UIImageView *imgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, bounds.size.height - 160)];
    UIImage *image = (UIImage *)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        image = [delegate scaleImage:image toSize:CGSizeMake(bounds.size.width,240)];
    }else {
        image = [delegate scaleImage:image toSize:CGSizeMake(bounds.size.width,240)];
    }
    NSMutableArray *curImageList;
    if ([self.imgPhotoView getImageList] != nil) {
        curImageList = [[NSMutableArray alloc] initWithArray:[self.imgPhotoView getImageList]];
    }else {
        curImageList = [[NSMutableArray alloc] init];
    }
    
    NSData *imgData = UIImageJPEGRepresentation(image,1);
    [curImageList addObject:imgData];
    [self.imgPhotoView setImageList:curImageList type:1];
    //image = [delegate cropImage:image];
    tempCameraView.image = image;
    isTaken = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onDateBtnPressed:(id)sender {
    [self.view endEditing:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([dateView isHidden]) {
        long curDate;
        if ([self.lblDate.text isEqualToString:@"-"]) {
            curDate = 1;
        }else {
            curDate = [self.lblDate.text intValue];
        }
        long startDate = 1;
        int curMonth = 1;
        NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
        for (int i = 0; i < months.count; i++) {
            if ([[months objectAtIndex:i] isEqualToString:self.lblMonth.text]) {
                curMonth = i + 1;
                break;
            }
        }
        if ([self.lblYear.text intValue] == [delegate getYear:[NSDate date]]) {
            if (curMonth == [delegate getMonth:[NSDate date]]) {
                startDate = [delegate getDay:[NSDate date]];
            }
        }
        if (curDate > [delegate getMaxDate:[self.lblYear.text intValue] month:curMonth] - 6) {
            if (startDate > [delegate getMaxDate:[self.lblYear.text intValue] month:curMonth] - 6) {
                curDate = startDate;
            }else {
                curDate = [delegate getMaxDate:[self.lblYear.text intValue] month:curMonth] - 5;
            }
        }
        [dateView setContentOffset:CGPointMake(0,(curDate - startDate) * 20)];
        [dateView setHidden:NO];
        [monthView setHidden:YES];
        [yearView setHidden:YES];
        [criteriaRaceView setHidden:YES];
        [criteriaNationalityView setHidden:YES];
        [criteriaAgeView setHidden:YES];
    }else {
        [dateView setHidden:YES];
    }
}

- (void) doneSavePostInfo :(NSString*)data
{
    
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        PostEditSuccessViewController *postEditSuccessViewController = [[PostEditSuccessViewController alloc] init];
        postEditSuccessViewController.lblPropertyName.text = self.lblPropertyName.text;
        [self.navigationController pushViewController:postEditSuccessViewController animated:YES];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (void)imageGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void) getPostInfo
{
    NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    propList = [[NSMutableArray alloc] init];
    NSError *error;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Get Property Data
    
    NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"MetaProperty" inManagedObjectContext:context];
    [fetchRequest setEntity:propEntity];
    NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (MetaProperty *propInfo in propObjects) {
        NSMutableDictionary *property = [[NSMutableDictionary alloc] init];
        [property setValue:propInfo.propertyid forKey:@"id"];
        [property setValue:propInfo.name forKey:@"name"];
        [property setValue:propInfo.type forKey:@"type"];
        [property setValue:propInfo.land_area forKey:@"land_area"];
        [property setValue:propInfo.built_up forKey:@"built_up"];
        [property setValue:propInfo.unit forKey:@"unit"];
        [property setValue:propInfo.bedrooms forKey:@"bedrooms"];
        [property setValue:propInfo.bathrooms forKey:@"bathrooms"];
        [property setValue:propInfo.address1 forKey:@"address1"];
        [property setValue:propInfo.address2 forKey:@"address2"];
        [property setValue:propInfo.zipcode forKeyPath:@"zipcode"];
        [propList addObject:property];
    }
    curPropList = [[NSMutableArray alloc] initWithArray:propList];
    [propView reloadData];
    
    //Get Nationality Data
    NSEntityDescription *nationEntity = [NSEntityDescription entityForName:@"Nationality" inManagedObjectContext:context];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
    [fetchRequest setEntity:nationEntity];
    NSArray *nationObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    nationalityList = [[NSMutableArray alloc] init];
    [nationalityList addObject:@"Any"];
    for (Nationality *nationInfo in nationObjects) {
        [nationalityList addObject:nationInfo.name];
    }
    [criteriaNationalityView reloadData];
    
    //Get Race Data
    NSEntityDescription *raceEntity = [NSEntityDescription entityForName:@"Race" inManagedObjectContext:context];
    [fetchRequest setEntity:raceEntity];
    NSArray *raceObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    raceList = [[NSMutableArray alloc] init];
    [raceList addObject:@"Any"];
    for (Race *raceInfo in raceObjects) {
        [raceList addObject:raceInfo.name];
    }
    [criteriaRaceView reloadData];
    
    //Get Property Data
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(userid=%d) and (propertyid=%d)",[delegate.userid intValue],[delegate.pid intValue]]];
    [fetchRequest setSortDescriptors:nil];
    
    propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
    [fetchRequest setEntity:propEntity];
    propObjects = [context executeFetchRequest:fetchRequest error:&error];
    //NSDate *curDate = [NSDate date];
    if (propObjects.count > 0) {
        Property *propInfo = (Property *)[propObjects objectAtIndex:0];
        //Get Furnish Data
        NSEntityDescription *furnishEntity = [NSEntityDescription entityForName:@"Furnish" inManagedObjectContext:context];
        [fetchRequest setPredicate:nil];
        [fetchRequest setEntity:furnishEntity];
        NSArray *furnishObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        normalFurnishList = [[NSMutableArray alloc] init];
        
        for (Furnish *furnishInfo in furnishObjects) {
            [normalFurnishList addObject:furnishInfo.name];
        }
        
        for (int i = 0; i < normalFurnishList.count; i++) {
            UIButton *selBtn = [[UIButton alloc] initWithFrame:CGRectMake((i % 2) * 135,(i / 2) * 30,26,26)];
            selBtn.layer.borderColor = [[UIColor grayColor] CGColor];
            if ([propInfo.furnish_type isEqualToNumber:[NSNumber numberWithInt:3]]) {
                selBtn.layer.borderWidth = 0.0f;
                selBtn.backgroundColor = [[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
            }else {
                selBtn.layer.borderWidth = 1.0f;
                selBtn.backgroundColor = [UIColor clearColor];
            }
            selBtn.layer.cornerRadius = 13.0f;
            [selBtn addTarget:self action:@selector(onFurnishBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.furnishView addSubview:selBtn];
            UILabel *selLabel = [[UILabel alloc] initWithFrame:CGRectMake(35 + (i % 2) * 135, (i / 2) * 30,100,26)];
            [selLabel setFont:[UIFont systemFontOfSize:10.0f]];
            selLabel.textColor = [UIColor grayColor];
            selLabel.text = [normalFurnishList objectAtIndex:i];
            selLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *labelFurnishTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(furnishGestureCaptured:)];
            [selLabel addGestureRecognizer:labelFurnishTap];
            [self.furnishView addSubview:selLabel];
        }
        
        //Get Facility Data
        NSEntityDescription *facilityEntity = [NSEntityDescription entityForName:@"Facility" inManagedObjectContext:context];
        [fetchRequest setEntity:facilityEntity];
        NSArray *facilityObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        normalFacilityList = [[NSMutableArray alloc] init];
        
        for (Facility *facilityInfo in facilityObjects) {
            [normalFacilityList addObject:facilityInfo.name];
        }
        
        for (int i = 0; i < normalFacilityList.count; i++) {
            UIButton *selBtn = [[UIButton alloc] initWithFrame:CGRectMake((i % 2) * 135,(i / 2) * 30,26,26)];
            selBtn.layer.borderColor = [[UIColor grayColor] CGColor];
            if ([propInfo.furnish_type isEqualToNumber:[NSNumber numberWithInt:3]]) {
                selBtn.layer.borderWidth = 0.0f;
                selBtn.backgroundColor = [[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
            }else {
                selBtn.layer.borderWidth = 1.0f;
                selBtn.backgroundColor = [UIColor clearColor];
            }
            selBtn.layer.cornerRadius = 13.0f;
            [selBtn addTarget:self action:@selector(onFacilityBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.facilityView addSubview:selBtn];
            UILabel *selLabel = [[UILabel alloc] initWithFrame:CGRectMake(35 + (i % 2) * 135, (i / 2) * 30,100,26)];
            [selLabel setFont:[UIFont systemFontOfSize:10.0f]];
            selLabel.textColor = [UIColor grayColor];
            selLabel.text = [normalFacilityList objectAtIndex:i];
            selLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *labelFacilityTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(facilityGestureCaptured:)];
            [selLabel addGestureRecognizer:labelFacilityTap];
            [self.facilityView addSubview:selLabel];
        }
        //Users *userInfo = propInfo.userInfo;
        /*NSMutableDictionary *property = [[NSMutableDictionary alloc] init];
        [property setValue:propInfo.propertyid forKey:@"id"];
        [property setValue:propInfo.userid forKey:@"userid"];
        [property setValue:propInfo.name forKey:@"name"];
        [property setValue:propInfo.type forKey:@"type"];
        [property setValue:propInfo.furnish_type forKey:@"furnish_type"];
        [property setValue:propInfo.sqft forKey:@"sqft"];
        [property setValue:propInfo.rooms forKey:@"rooms"];
        [property setValue:propInfo.toilets forKey:@"toilets"];
        [property setValue:propInfo.latitude forKey:@"latitude"];
        [property setValue:propInfo.longitude forKey:@"longitude"];
        [property setValue:propInfo.describe forKey:@"description"];
        [property setValue:propInfo.time forKey:@"time"];
        [property setValue:propInfo.availability forKey:@"availability"];
        [property setValue:propInfo.zipcode forKey:@"zipcode"];
        [property setValue:propInfo.nationality forKey:@"nationality"];
        [property setValue:propInfo.race forKey:@"race"];
        [property setValue:propInfo.age forKey:@"age"];
        [property setValue:propInfo.rental forKey:@"rental"];
        [property setValue:propInfo.parkings forKey:@"parkings"];
        [property setValue:propInfo.address1 forKey:@"address1"];
        [property setValue:propInfo.address2 forKey:@"address2"];
        [property setValue:propInfo.zipcode forKey:@"zipcode"];
        if (userInfo.user_id == propInfo.userid) {
            [property setValue:userInfo.name forKey:@"username"];
            [property setValue:userInfo.photo forKey:@"photo"];
        }
        [property setValue:@"0" forKey:@"like"];
        for (Favorites *favoritesInfo in propInfo.favoritesInfo) {
            if (favoritesInfo.propertyid == propInfo.propertyid && favoritesInfo.userid == propInfo.userid) {
                [property setValue:@"1" forKey:@"like"];
            }
        }
        [property setValue:@"0" forKey:@"like"];
        
        if ([propInfo.availability compare:curDate] <= 0) {
            [property setValue:@"Available Now" forKey:@"availability"];
        }else {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"m/d/YY"];
            [property setValue:[NSString stringWithFormat:@"%@ Available",[dateFormat stringFromDate:propInfo.availability]] forKey:@"availability"];
        }*/
        
        delegate.beforePoint = [propInfo.quality intValue];
        
        NSMutableArray *furnishList = [[NSMutableArray alloc] init];
        for (PropertyFurnish *propFurnish in propInfo.furnishInfo) {
            [furnishList addObject:propFurnish.furnish_name];
        }
        if (furnishList.count > 0) {
            int curCount = (int)self.furnishView.subviews.count;
            int k = 0;
            for (int i = 0; i < furnishList.count; i++) {
                int j = 1;
                for (; j < curCount; j += 2) {
                    UILabel *curLabel = (UILabel *)[self.furnishView.subviews objectAtIndex:j];
                    UIButton *curButton = (UIButton *)[self.furnishView.subviews objectAtIndex:j - 1];
                    if ([propInfo.furnish_type isEqualToNumber:[NSNumber numberWithInt:3]] || [curLabel.text isEqualToString:[furnishList objectAtIndex:i]]) {
                        //curLabel.textColor = [[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                        curButton.layer.borderWidth = 0.0f;
                        curButton.backgroundColor = [[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                        break;
                    }
                }
                if ([propInfo.furnish_type isEqualToNumber:[NSNumber numberWithInt:3]] || j == curCount + 1) {
                    UIButton *selBtn = [[UIButton alloc] initWithFrame:CGRectMake(((curCount / 2 + k) % 2) * 135,((curCount / 2 + k) / 2) * 30,26,26)];
                    selBtn.layer.borderColor = [[UIColor grayColor] CGColor];
                    selBtn.layer.borderWidth = 0.0f;
                    selBtn.layer.cornerRadius = 13.0f;
                    selBtn.backgroundColor = [[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                    [selBtn addTarget:self action:@selector(onFurnishBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self.furnishView addSubview:selBtn];
                    UILabel *selLabel = [[UILabel alloc] initWithFrame:CGRectMake(35 + ((curCount / 2 + k) % 2) * 135, ((curCount / 2 + k) / 2) * 30,100,26)];
                    [selLabel setFont:[UIFont systemFontOfSize:10.0f]];
                    selLabel.textColor = [UIColor grayColor]; //[[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                    selLabel.text = [furnishList objectAtIndex:i];
                    [self.furnishView addSubview:selLabel];
                    k++;
                }
            }
        }
        CGRect frame = self.furnishView.frame;
        frame.size.height = ((self.furnishView.subviews.count - 1) / 4 + 1) * 30;
        [self.furnishView setFrame:frame];
        //[property setValue:furnishList forKey:@"furnishes"];
        
        NSMutableArray *facilityList = [[NSMutableArray alloc] init];
        for (PropertyFacility *propFacility in propInfo.facilityInfo) {
            [facilityList addObject:propFacility.facility_name];
        }
        if (facilityList.count > 0) {
            int curCount = (int)self.facilityView.subviews.count;
            int k = 0;
            for (int i = 0; i < facilityList.count; i++) {
                int j = 1;
                for (; j < curCount; j += 2) {
                    UILabel *curLabel = (UILabel *)[self.facilityView.subviews objectAtIndex:j];
                    UIButton *curButton = (UIButton *)[self.facilityView.subviews objectAtIndex:j - 1];
                    if ([propInfo.furnish_type isEqualToNumber:[NSNumber numberWithInt:3]] || [curLabel.text isEqualToString:[facilityList objectAtIndex:i]]) {
                        //curLabel.textColor = [[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                        curButton.layer.borderWidth = 0.0f;
                        curButton.backgroundColor = [[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                        break;
                    }
                }
                if ([propInfo.furnish_type isEqualToNumber:[NSNumber numberWithInt:3]] || j == curCount + 1) {
                    UIButton *selBtn = [[UIButton alloc] initWithFrame:CGRectMake(((curCount / 2 + k) % 2) * 135,((curCount / 2 + k) / 2) * 30,26,26)];
                    selBtn.layer.borderColor = [[UIColor grayColor] CGColor];
                    selBtn.layer.borderWidth = 0.0f;
                    selBtn.layer.cornerRadius = 13.0f;
                    selBtn.backgroundColor = [[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                    [selBtn addTarget:self action:@selector(onFacilityBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self.facilityView addSubview:selBtn];
                    UILabel *selLabel = [[UILabel alloc] initWithFrame:CGRectMake(35 + ((curCount / 2 + k) % 2) * 135, ((curCount / 2 + k) / 2) * 30,100,26)];
                    [selLabel setFont:[UIFont systemFontOfSize:10.0f]];
                    selLabel.textColor = [UIColor grayColor]; //[[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                    selLabel.text = [facilityList objectAtIndex:i];
                    [self.facilityView addSubview:selLabel];
                    k++;
                }
            }
        }
        frame = self.facilityView.frame;
        frame.size.height = ((self.facilityView.subviews.count - 1) / 4 + 1) * 30;
        [self.facilityView setFrame:frame];
        //[property setValue:facilityList forKey:@"facilities"];
        if (![propInfo.time isEqualToString:@""]) {
            NSArray *timeDict = (NSArray *)[propInfo.time JSONValue];
            if (timeDict && timeDict.count > 0) {
                for (int i = 0; i < 7; i++) {
                    UIButton *lblTime = (UIButton *)[self.timeView.subviews objectAtIndex:i];
                    NSArray *times = (NSArray *)[timeDict objectAtIndex:i];
                    for (int j = 0; j < 4; j++) {
                        UIButton *btnTime = (UIButton *)[self.timeView.subviews objectAtIndex:(j + 1) * 8 + i];
                        if (propInfo.prefertimestart != nil) {
                            int k = 0;
                            for (k = 0; k < 7; k++) {
                                NSDate *newDate = [propInfo.prefertimestart dateByAddingTimeInterval:k * 24 * 60 * 60];
                                NSDateComponents *newDateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:newDate];
                                [newDateComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
                                NSString *dayStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents day]];
                                if ([newDateComponents day] < 10) {
                                    dayStr = [NSString stringWithFormat:@"0%@",dayStr];
                                }
                                NSString *monthStr = [NSString stringWithFormat:@"%ld",(long)[newDateComponents month]];
                                if ([newDateComponents month] < 10) {
                                    monthStr = [NSString stringWithFormat:@"0%@",monthStr];
                                }
                                if ([lblTime.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%@/%@",dayStr,monthStr]]) {
                                    if ([[times objectAtIndex:j] intValue] == 1) {
                                        btnTime.backgroundColor = [UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                                    }else {
                                        btnTime.backgroundColor = [UIColor whiteColor];
                                    }
                                    break;
                                }
                                /*if ([[times objectAtIndex:j] intValue] == 1) {
                                    
                                        btnTime.backgroundColor = [UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                                    }else {
                                        btnTime.backgroundColor = [UIColor whiteColor];
                                    }
                                }else {
                                    btnTime.backgroundColor = [UIColor whiteColor];
                                }*/
                            }
                            if (k == 7) {
                                btnTime.backgroundColor = [UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                            }
                        }else {
                            btnTime.backgroundColor = [UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                        }
                    }
                }
            }
        }else {
            if (propInfo.prefertimestart == nil) {
                for (int i = 0; i < 7; i++) {
                    for (int j = 0; j < 4; j++) {
                        UIButton *btnTime = (UIButton *)[self.timeView.subviews objectAtIndex:(j + 1) * 8 + i];
                        btnTime.backgroundColor = [UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                    }
                }
            }
        }
        self.txtName.text = propInfo.name;
        self.txtUnit.text = propInfo.unit;
        if ([propInfo.type isEqualToNumber:[NSNumber numberWithInt:1]]) {
            self.lblPropertyName.text = propInfo.name;
        }else {
            self.lblPropertyName.text = propInfo.address1;
        }
        self.txtDescription.text = propInfo.describe;
        
        NSMutableArray *imageList = [[NSMutableArray alloc] init];
        for (PropertyImage *propImage in propInfo.imgInfo) {
            NSMutableDictionary *image = [[NSMutableDictionary alloc] init];
            if (propImage.path != nil) {
                [image setObject:propImage.path forKey:@"path"];
            }else {
                [image setObject:@"" forKey:@"path"];
            }
            if (propImage.data != nil) {
                [image setObject:propImage.data forKey:@"data"];
            }
            [imageList addObject:image];
        }
        
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"OutImageSlider" owner:self options:nil];
        self.imgPhotoView = (OutImageSlider *)[nibArray objectAtIndex:0];
        [self.imgPhotoView setFrame:CGRectMake(0,0,320,150)];
        [self.imgPhotoView setImageList:imageList type:1];
        self.imgPhotoView.lblName.text =self.lblPropertyName.text;
        [self.imgArea addSubview:self.imgPhotoView];
        
        self.segType.selectedSegmentIndex = [propInfo.type intValue] - 1;
        self.segRooms.selectedSegmentIndex = [propInfo.rooms intValue];
        self.segToilets.selectedSegmentIndex = [propInfo.toilets intValue] - 1;
        self.segParking.selectedSegmentIndex = [propInfo.parkings intValue];
        if ([propInfo.sqft intValue] == 0) {
            self.txtSqft.text = @"";
        }else {
            self.txtSqft.text = [NSString stringWithFormat:@"%@",propInfo.sqft];
        }
        self.txtRentals.text = [NSString stringWithFormat:@"%@",propInfo.rental];
        self.txtAddress1.text = propInfo.address1;
        self.txtAddress2.text = propInfo.address2;
        self.txtZipcode.text = propInfo.zipcode;
        if ([propInfo.age intValue] > 0) {
            self.lblCriteriaAge.text = [NSString stringWithFormat:@">%@",propInfo.age];
        }else {
            self.lblCriteriaAge.text = @"Any";
        }
        if (propInfo.nationality != nil && ![propInfo.nationality isEqualToString:@""]) {
            self.lblCriteriaNationality.text = propInfo.nationality;
        }else {
            self.lblCriteriaNationality.text = @"Any";
        }
        if (propInfo.race != nil && ![propInfo.race isEqualToString:@""]) {
            self.lblCriteriaRace.text = propInfo.race;
        }else {
            self.lblCriteriaRace.text = @"Any";
        }
        self.segFurnish.selectedSegmentIndex = 3 - [propInfo.furnish_type intValue];
        if (propInfo.availability == nil) {
            propInfo.availability = [NSDate date];
        }
        if ([delegate getYear:propInfo.availability] < [delegate getYear:[NSDate date]]) {
            _lblYear.text = [NSString stringWithFormat:@"%ld",[delegate getYear:[NSDate date]]];
            _lblMonth.text = months[[delegate getMonth:[NSDate date]] - 1];
            _lblDate.text = [NSString stringWithFormat:@"%ld",[delegate getDay:[NSDate date]]];
        }else if ([delegate getYear:propInfo.availability] == [delegate getYear:[NSDate date]]) {
            _lblYear.text = [NSString stringWithFormat:@"%ld",[delegate getYear:propInfo.availability]];
            if ([delegate getMonth:propInfo.availability]  < [delegate getMonth:[NSDate date]]) {
                _lblMonth.text = months[[delegate getMonth:[NSDate date]] - 1];
                _lblDate.text = [NSString stringWithFormat:@"%ld",[delegate getDay:[NSDate date]]];
            }else if ([delegate getMonth:propInfo.availability] == [delegate getMonth:[NSDate date]]) {
                _lblMonth.text = [NSString stringWithFormat:@"%@",months[[delegate getMonth:propInfo.availability] - 1]];
                if ([delegate getMonth:propInfo.availability]  < [delegate getMonth:[NSDate date]]) {
                    _lblDate.text = [NSString stringWithFormat:@"%ld",[delegate getDay:[NSDate date]]];
                }else {
                    _lblDate.text = [NSString stringWithFormat:@"%ld",[delegate getDay:propInfo.availability]];
                }
            }else {
                _lblMonth.text = [NSString stringWithFormat:@"%ld",[delegate getMonth:propInfo.availability]];
                _lblDate.text = [NSString stringWithFormat:@"%ld",[delegate getDay:propInfo.availability]];
            }
        }else {
            _lblYear.text = [NSString stringWithFormat:@"%ld",[delegate getYear:propInfo.availability]];
            _lblMonth.text = [NSString stringWithFormat:@"%ld",[delegate getMonth:propInfo.availability]];
            _lblDate.text = [NSString stringWithFormat:@"%ld",[delegate getDay:propInfo.availability]];
        }
    }
}

- (void) doneGetPostInfo :(NSString*)data
{
    NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        NSDictionary *dic = [dataDict objectForKey:@"postinfo"];
        
        if (![[dic objectForKey:@"time"] isEqualToString:@""]) {
            NSArray *timeDict = (NSArray *)[[dic objectForKey:@"time"] JSONValue];
            if (timeDict && timeDict.count > 0) {
                for (int i = 0; i < 7; i++) {
                    NSArray *times = (NSArray *)[timeDict objectAtIndex:i];
                    for (int j = 0; j < 4; j++) {
                        UIButton *btnTime = (UIButton *)[self.timeView.subviews objectAtIndex:(j + 1) * 8 + i];
                        if ([[times objectAtIndex:j] intValue] == 1) {
                            btnTime.backgroundColor = [UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
                        }else {
                            btnTime.backgroundColor = [UIColor whiteColor];
                        }
                    }
                }
            }
        }
        self.lblPropertyName.text = [dic objectForKey:@"name"];
        self.txtDescription.text = [dic objectForKey:@"description"];
        
        NSArray *imageList = (NSArray *)[dic objectForKey:@"images"];
        
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"OutImageSlider" owner:self options:nil];
        self.imgPhotoView = (OutImageSlider *)[nibArray objectAtIndex:0];
        [self.imgPhotoView setFrame:CGRectMake(40,0,240,150)];
        [self.imgPhotoView setImageList:imageList type:1];
        self.imgPhotoView.lblName.text =self.lblPropertyName.text;
        [self.imgArea addSubview:self.imgPhotoView];
        self.segType.selectedSegmentIndex = [[dic objectForKey:@"type"] intValue] - 1;
        self.segRooms.selectedSegmentIndex = [[dic objectForKey:@"rooms"] intValue];
        self.segToilets.selectedSegmentIndex = [[dic objectForKey:@"toilets"] intValue] - 1;
        self.segParking.selectedSegmentIndex = [[dic objectForKey:@"parkings"] intValue];
        self.txtSqft.text = [dic objectForKey:@"sqft"];
        self.txtRentals.text = [dic objectForKey:@"rental"];
        self.txtAddress1.text = [dic objectForKey:@"address1"];
        self.txtAddress2.text = [dic objectForKey:@"address2"];
        self.txtZipcode.text = [dic objectForKey:@"zipcode"];
        if ([[dic objectForKey:@"age"] intValue] > 0) {
            self.lblCriteriaAge.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"age"]];
        }else {
            self.lblCriteriaAge.text = @"Any";
        }
        if ([dic objectForKey:@"nationality"] != nil && ![[dic objectForKey:@"nationality"] isEqualToString:@""]) {
            self.lblCriteriaNationality.text = [dic objectForKey:@"nationality"];
        }else {
            self.lblCriteriaNationality.text = @"Any";
        }
        if ([dic objectForKey:@"race"] != nil && ![[dic objectForKey:@"race"] isEqualToString:@""]) {
            self.lblCriteriaRace.text = [dic objectForKey:@"race"];
        }else {
            self.lblCriteriaRace.text = @"Any";
        }
        self.segFurnish.selectedSegmentIndex = 3 - [[dic objectForKey:@"furnish_type"] intValue];
        NSString *availability_str = [dic objectForKey:@"avail_date"];
        _lblYear.text = [availability_str substringWithRange:NSMakeRange(0,4)];
        _lblMonth.text = months[[[availability_str substringWithRange:NSMakeRange(5,2)] intValue] - 1];
        _lblDate.text = [availability_str substringWithRange:NSMakeRange(8,2)];
        
        normalFurnishList = [[NSMutableArray alloc] initWithArray:(NSArray *)[dataDict objectForKey:@"furnishes"]];
        for (int i = 0; i < normalFurnishList.count; i++) {
            UIButton *selBtn = [[UIButton alloc] initWithFrame:CGRectMake((i % 2) * 135,(i / 2) * 25,26,26)];
            selBtn.layer.borderColor = [[UIColor grayColor] CGColor];
            selBtn.layer.borderWidth = 1.0f;
            selBtn.backgroundColor = [UIColor clearColor];
            [selBtn addTarget:self action:@selector(onFurnishBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.furnishView addSubview:selBtn];
            UILabel *selLabel = [[UILabel alloc] initWithFrame:CGRectMake(25 + (i % 2) * 135, (i / 2) * 25,100,26)];
            [selLabel setFont:[UIFont systemFontOfSize:10.0f]];
            selLabel.textAlignment = NSTextAlignmentCenter;
            selLabel.layer.borderWidth = 1.0f;
            selLabel.layer.borderColor = [[UIColor grayColor] CGColor];
            selLabel.textColor = [UIColor grayColor];
            selLabel.text = [normalFurnishList objectAtIndex:i];
            selLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *labelFurnishTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(furnishGestureCaptured:)];
            [selLabel addGestureRecognizer:labelFurnishTap];
            [self.furnishView addSubview:selLabel];
        }
        normalFacilityList = [[NSMutableArray alloc] initWithArray:(NSArray *)[dataDict objectForKey:@"facilities"]];
        for (int i = 0; i < normalFacilityList.count; i++) {
            UIButton *selBtn = [[UIButton alloc] initWithFrame:CGRectMake((i % 2) * 135,(i / 2) * 25,26,26)];
            selBtn.layer.borderColor = [[UIColor grayColor] CGColor];
            selBtn.layer.borderWidth = 1.0f;
            selBtn.backgroundColor = [UIColor clearColor];
            [selBtn addTarget:self action:@selector(onFacilityBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.facilityView addSubview:selBtn];
            UILabel *selLabel = [[UILabel alloc] initWithFrame:CGRectMake(25 + (i % 2) * 135, (i / 2) * 25,100,26)];
            [selLabel setFont:[UIFont systemFontOfSize:10.0f]];
            selLabel.textAlignment = NSTextAlignmentCenter;
            selLabel.layer.borderWidth = 1.0f;
            selLabel.layer.borderColor = [[UIColor grayColor] CGColor];
            selLabel.textColor = [UIColor grayColor];
            selLabel.text = [normalFacilityList objectAtIndex:i];
            selLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *labelFacilityTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(facilityGestureCaptured:)];
            [selLabel addGestureRecognizer:labelFacilityTap];
            [self.facilityView addSubview:selLabel];
        }
        
        nationalityList = [[NSMutableArray alloc] initWithArray:(NSArray *)[dataDict objectForKey:@"nationality"]];
        [criteriaNationalityView reloadData];
        
        raceList = [[NSMutableArray alloc] initWithArray:(NSArray *)[dataDict objectForKey:@"race"]];
        [criteriaRaceView reloadData];
    }
}

- (void) furnishGestureCaptured:(UIGestureRecognizer *)gesture {
    UILabel *sender = (UILabel *)gesture.view;
    NSArray *furnishSubViews = self.furnishView.subviews;
    UIColor *selColor = [[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
    /*if ([sender.textColor isEqual:selColor]) {
        sender.textColor = [UIColor grayColor];
    }else {
        sender.textColor = selColor;
    }*/
    for (int i = 1; i < furnishSubViews.count; i += 2) {
        if ([[furnishSubViews objectAtIndex:i]  isEqual:sender]) {
            UIButton *furnishNameBtn = (UIButton *)[furnishSubViews objectAtIndex:i - 1];
            if ([furnishNameBtn.backgroundColor isEqual:selColor]) {
                furnishNameBtn.backgroundColor = [UIColor clearColor];
                furnishNameBtn.layer.borderWidth = 1.0f;
            }else {
                furnishNameBtn.backgroundColor = selColor;
                furnishNameBtn.layer.borderWidth = 0.0f;
            }
        }
    }
}

- (void) facilityGestureCaptured:(UIGestureRecognizer *)gesture {
    UILabel *sender = (UILabel *)gesture.view;
    NSArray *facilitySubViews = self.facilityView.subviews;
    UIColor *selColor = [[UIColor alloc] initWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0];
    /*if ([sender.textColor isEqual:selColor]) {
        sender.textColor = [UIColor grayColor];
    }else {
        sender.textColor = selColor;
    }*/
    for (int i = 1; i < facilitySubViews.count; i += 2) {
        if ([[facilitySubViews objectAtIndex:i]  isEqual:sender]) {
            UIButton *facilityNameBtn = (UIButton *)[facilitySubViews objectAtIndex:i - 1];
            if ([facilityNameBtn.backgroundColor isEqual:selColor]) {
                facilityNameBtn.backgroundColor = [UIColor clearColor];
                facilityNameBtn.layer.borderWidth = 1.0f;
            }else {
                facilityNameBtn.backgroundColor = selColor;
                facilityNameBtn.layer.borderWidth = 0.0f;
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([tableView isEqual:yearView]) {
        return 20;
    }else if ([tableView isEqual:monthView]) {
        long year = [delegate getYear:[NSDate date]];
        if (![self.lblYear.text isEqualToString:@"-"]) {
            year = [self.lblYear.text intValue];
        }
        if ([delegate getYear:[NSDate date]] == year) {
            return 13 - [delegate getMonth:[NSDate date]];
        }else {
            return 12;
        }
    }else if ([tableView isEqual:dateView]) {
        long curYear = [delegate getYear:[NSDate date]];
        if (![self.lblYear.text isEqualToString:@"-"]) {
            curYear = [self.lblYear.text intValue];
        }
        if ([self.lblMonth.text isEqualToString:@"-"]) {
            self.lblMonth.text = months[[delegate getMonth:[NSDate date]] - 1];
        }
        int curMonth = 1;
        NSString *curMonthStr = self.lblMonth.text;
        for (int i = 0; i < months.count; i++) {
            if ([[months objectAtIndex:i] isEqualToString:curMonthStr]) {
                curMonth = i + 1;
                break;
            }
        }
        NSDate *now = [NSDate date];
        if ([delegate getYear:now] == curYear && [delegate getMonth:now] == curMonth) {
            return [delegate getMaxDate:curYear month:curMonth] - [delegate getDay:now] + 1;
        }else {
            return [delegate getMaxDate:curYear month:curMonth];
        }
    }else if ([tableView isEqual:criteriaAgeView]) {
        return 6;
    }else if ([tableView isEqual:criteriaRaceView]) {
        return [raceList count];
    }else if ([tableView isEqual:criteriaNationalityView]) {
        return [nationalityList count];
    }else if ([tableView isEqual:propView]){
        return [curPropList count];
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:yearView]) {
        return 20.0f;
    }else if ([tableView isEqual:monthView]) {
        return 20.0f;
    }else if ([tableView isEqual:dateView]) {
        return 20.0f;
    }else if ([tableView isEqual:criteriaAgeView]) {
        return 20.0f;
    }else if ([tableView isEqual:criteriaRaceView]) {
        return 20.0f;
    }else if ([tableView isEqual:criteriaNationalityView]) {
        return 20.0f;
    }else if ([tableView isEqual:propView]) {
        return 30.0f;
    }else {
        return 0.0f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDate *curDate = [NSDate date];
    long curYear = [delegate getYear:curDate];
    long curMonth = [delegate getMonth:curDate];
    long curDay = [delegate getDay:curDate];
    if ([tableView isEqual:yearView]) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.textLabel setFont:[UIFont systemFontOfSize:10.0f]];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld", curYear + indexPath.row];
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapGesture:)];
        [cellTap setCancelsTouchesInView:NO];
        [cell addGestureRecognizer:cellTap];
        return cell;
    }else if ([tableView isEqual:monthView]) {
        NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.textLabel setFont:[UIFont systemFontOfSize:10.0f]];
        long year = curYear;
        if (![self.lblYear.text isEqualToString:@"-"]) {
            year = [self.lblYear.text intValue];
        }
        if (curYear == year) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", [months objectAtIndex:(indexPath.row + curMonth - 1)]];
        }else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", [months objectAtIndex:indexPath.row]];
        }
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapGesture:)];
        [cellTap setCancelsTouchesInView:NO];
        [cell addGestureRecognizer:cellTap];
        return cell;
    }else if ([tableView isEqual:dateView]) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.textLabel setFont:[UIFont systemFontOfSize:10.0f]];
        long year = curYear;
        if (![self.lblYear.text isEqualToString:@"-"]) {
            year = [self.lblYear.text intValue];
        }
        long month = 1;
        NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
        for (int i = 0; i < months.count; i++) {
            if ([[months objectAtIndex:i] isEqualToString:self.lblMonth.text]) {
                month = i + 1;
                break;
            }
        }
        if (year == curYear && month == curMonth) {
            cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + curDay];
        }else {
            cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
        }
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapGesture:)];
        [cellTap setCancelsTouchesInView:NO];
        [cell addGestureRecognizer:cellTap];
        return cell;
    }else if ([tableView isEqual:criteriaAgeView]) {
        NSArray *ageArray = [[NSArray alloc] initWithObjects:@"Any", @">18",@">25",@">30",@">35",@">40", nil];
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.textLabel setFont:[UIFont systemFontOfSize:10.0f]];
        cell.textLabel.text = [ageArray objectAtIndex:indexPath.row];
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapGesture:)];
        [cellTap setCancelsTouchesInView:NO];
        [cell addGestureRecognizer:cellTap];
        return cell;
    }else if ([tableView isEqual:criteriaRaceView]) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.textLabel setFont:[UIFont systemFontOfSize:10.0f]];
        cell.textLabel.text = [raceList objectAtIndex:indexPath.row];
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapGesture:)];
        [cellTap setCancelsTouchesInView:NO];
        [cell addGestureRecognizer:cellTap];
        return cell;
    }else if ([tableView isEqual:criteriaNationalityView]) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.textLabel setFont:[UIFont systemFontOfSize:10.0f]];
        cell.textLabel.text = [nationalityList objectAtIndex:indexPath.row];
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapGesture:)];
        [cellTap setCancelsTouchesInView:NO];
        [cell addGestureRecognizer:cellTap];
        return cell;
    }else if ([tableView isEqual:propView]) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.textLabel setFont:[UIFont systemFontOfSize:12.0f]];
        if (self.segType.selectedSegmentIndex == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", [[curPropList objectAtIndex:indexPath.row] valueForKey:@"address1"]];
        }else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", [[curPropList objectAtIndex:indexPath.row] valueForKey:@"name"]];
        }
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapGesture:)];
        [cellTap setCancelsTouchesInView:NO];
        [cell addGestureRecognizer:cellTap];
        return cell;
    }else {
        return nil;
    }
}

- (void)cellTapGesture:(UIGestureRecognizer *)gesture
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITableViewCell *cell = (UITableViewCell *)gesture.view;
    if (!yearView.isHidden) {
        self.lblYear.text = cell.textLabel.text;
        int firstYear = [delegate getYear:[NSDate date]];
        int curYear = [self.lblYear.text intValue];
        if (curYear == firstYear) {
            NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
            int curMonth = 0;
            for (int i = 0; i < 12; i++) {
                if ([self.lblMonth.text isEqualToString:[months objectAtIndex:i]]) {
                    curMonth = i;
                    break;
                }
            }
            if (curMonth + 1 <= [delegate getMonth:[NSDate date]]) {
                self.lblMonth.text = [months objectAtIndex:[delegate getMonth:[NSDate date]] - 1];
                if ([self.lblDate.text intValue] < [delegate getDay:[NSDate date]]) {
                    self.lblDate.text = [NSString stringWithFormat:@"%ld",[delegate getDay:[NSDate date]]];
                }
            }
        }
        [yearView setHidden:YES];
        [monthView reloadData];
        [dateView reloadData];
    }else if (!monthView.isHidden) {
        self.lblMonth.text = cell.textLabel.text;
        int firstYear = [delegate getYear:[NSDate date]];
        int curYear = [self.lblYear.text intValue];
        if (curYear == firstYear) {
            NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
            int curMonth = 0;
            for (int i = 0; i < 12; i++) {
                if ([self.lblMonth.text isEqualToString:[months objectAtIndex:i]]) {
                    curMonth = i;
                    break;
                }
            }
            if (curMonth + 1 <= [delegate getMonth:[NSDate date]]) {
                self.lblMonth.text = [months objectAtIndex:[delegate getMonth:[NSDate date]] - 1];
                if ([self.lblDate.text intValue] < [delegate getDay:[NSDate date]]) {
                    self.lblDate.text = [NSString stringWithFormat:@"%ld",[delegate getDay:[NSDate date]]];
                }
            }
        }
        [monthView setHidden:YES];
        [dateView reloadData];
    }else if (!dateView.isHidden) {
        self.lblDate.text = cell.textLabel.text;
        [dateView setHidden:YES];
    }else if (!criteriaAgeView.isHidden) {
        self.lblCriteriaAge.text = cell.textLabel.text;
        [criteriaAgeView setHidden:YES];
    }else if (!criteriaRaceView.isHidden) {
        self.lblCriteriaRace.text = cell.textLabel.text;
        [criteriaRaceView setHidden:YES];
    }else if (!criteriaNationalityView.isHidden) {
        self.lblCriteriaNationality.text = cell.textLabel.text;
        [criteriaNationalityView setHidden:YES];
    }else if (!propView.isHidden) {
        self.txtName.text = cell.textLabel.text;
        for (int i = 0; i < propList.count; i++) {
            NSString *compareStr = [[propList objectAtIndex:i] valueForKey:@"name"];
            if ([compareStr isEqualToString:cell.textLabel.text]) {
                self.txtAddress1.text = [[propList objectAtIndex:i] valueForKey:@"address1"];
                self.txtAddress2.text = [[propList objectAtIndex:i] valueForKey:@"address2"];
                self.txtZipcode.text = [[propList objectAtIndex:i] valueForKey:@"zipcode"];
                self.txtUnit.text = [NSString stringWithFormat:@"%@",[[propList objectAtIndex:i] valueForKey:@"unit"]];
                if ([[[propList objectAtIndex:i] valueForKey:@"built_up"] isEqualToString:@"0"]) {
                    self.txtSqft.text = @"";
                }else {
                    self.txtSqft.text = [NSString stringWithFormat:@"%@",[[propList objectAtIndex:i] valueForKey:@"built_up"]];
                }
                self.segType.selectedSegmentIndex = [[[propList objectAtIndex:i] valueForKey:@"type"] intValue] - 1;
                break;
            }
        }
        [propView setHidden:YES];
    }
}

-(void)refreshLayout
{
    CGRect frame = self.viewAvailable.frame;
    frame.origin.y = self.timeView.frame.origin.y + self.timeView.frame.size.height + 10;
    [self.viewAvailable setFrame:frame];
    
    frame = self.viewUnavailable.frame;
    frame.origin.y = self.timeView.frame.origin.y + self.timeView.frame.size.height + 10;
    [self.viewUnavailable setFrame:frame];
    
    frame = viewMeetingTime.frame;
    frame.size.height = self.viewAvailable.frame.origin.y + self.viewAvailable.frame.size.height + 10;
    [viewMeetingTime setFrame:frame];
    frame = viewPropertyDescription.frame;
    frame.origin.y = viewMeetingTime.frame.origin.y + viewMeetingTime.frame.size.height - 1;
    [viewPropertyDescription setFrame:frame];
    frame = viewPhoto.frame;
    frame.origin.y = viewPropertyDescription.frame.origin.y + viewPropertyDescription.frame.size.height - 1;
    [viewPhoto setFrame:frame];
    
    frame = self.furnishOtherView.frame;
    frame.origin.y = self.furnishView.frame.origin.y + self.furnishView.frame.size.height + 20;
    [self.furnishOtherView setFrame:frame];
    frame = viewFurnish.frame;
    frame.origin.y = viewPhoto.frame.origin.y + viewPhoto.frame.size.height - 1;
    frame.size.height = self.furnishOtherView.frame.origin.y + self.furnishOtherView.frame.size.height + 20;
    [viewFurnish setFrame:frame];
    
    frame = self.facilityOtherView.frame;
    frame.origin.y = self.facilityView.frame.origin.y + self.facilityView.frame.size.height + 20;
    [self.facilityOtherView setFrame:frame];
    frame = viewFacility.frame;
    frame.origin.y = viewFurnish.frame.origin.y + viewFurnish.frame.size.height - 1;
    frame.size.height = self.facilityOtherView.frame.origin.y + self.facilityOtherView.frame.size.height + 20;
    [viewFacility setFrame:frame];
    
    frame = viewPropertyCommon.frame;
    if (self.segType.selectedSegmentIndex == 0) {
        frame.origin.y = self.segType.frame.origin.y + self.segType.frame.size.height;
    }else if (self.segType.selectedSegmentIndex == 1) {
        frame.origin.y = self.txtUnit.frame.origin.y + self.txtUnit.frame.size.height;
    }
    frame.size.height = self.txtZipcode.frame.origin.y + self.txtZipcode.frame.size.height + 10;
    [viewPropertyCommon setFrame:frame];
    
    frame = viewPropertyDetail.frame;
    frame.origin.y = viewFacility.frame.origin.y + viewFacility.frame.size.height - 1;
    frame.size.height = viewPropertyCommon.frame.origin.y + viewPropertyCommon.frame.size.height + 10;
    [viewPropertyDetail setFrame:frame];
    
    frame = viewFiltering.frame;
    frame.origin.y = viewPropertyDetail.frame.origin.y + viewPropertyDetail.frame.size.height - 1;
    [viewFiltering setFrame:frame];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    [self.dataView setContentSize:CGSizeMake(bounds.size.width,viewFiltering.frame.origin.y + viewFiltering.frame.size.height)];
    
}
@end
