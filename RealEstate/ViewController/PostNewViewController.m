//
//  PostNewViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/12/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "PostNewViewController.h"
#import "PostPhotoViewController.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "PostSuccessViewController.h"
#import "LoginViewController.h"
#import "VerifyViewController.h"
#import "MyNavigationController.h"
#import "PostEditViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <AddressBook/AddressBook.h>

#import "AFNetworking.h"

#import "MetaProperty.h"

#import "Property.h"
#import "PropertyImage.h"

#import "MBProgressHUD.h"

#import "NSString+SBJSON.h"

#import "NSObject+SBJSON.h"

@interface PostNewViewController ()

@end

@implementation PostNewViewController

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
    // Do any additional setup after loading the view from its nib.
    CALayer *imageLayer = self.imgGroupPhoto.layer;
    [imageLayer setBorderColor:[[UIColor clearColor] CGColor]];
    [imageLayer setCornerRadius:28];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [mainView1 setFrame:CGRectMake(0,44,bounds.size.width,bounds.size.height - 64)];
        [mainView2 setFrame:CGRectMake(bounds.size.width,44,bounds.size.width,bounds.size.height - 64)];
        [mainView3 setFrame:CGRectMake(bounds.size.width * 3,44,bounds.size.width,bounds.size.height - 64)];
        [cameraNavView setFrame:CGRectMake(0,0,bounds.size.width,70)];
        [cameraBtnView setFrame:CGRectMake(0,bounds.size.height - 72,bounds.size.width,72)];
    }else {
        [navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [mainView1 setFrame:CGRectMake(0,64,bounds.size.width,bounds.size.height - 64)];
        [mainView2 setFrame:CGRectMake(bounds.size.width,64,bounds.size.width,bounds.size.height - 64)];
        [mainView3 setFrame:CGRectMake(bounds.size.width * 3,64,bounds.size.width,bounds.size.height - 64)];
        [cameraNavView setFrame:CGRectMake(0,0,bounds.size.width,90)];
        [cameraBtnView setFrame:CGRectMake(0,bounds.size.height - 72,bounds.size.width,72)];
    }
    [mainView1 setContentSize:CGSizeMake(bounds.size.width,285)];
    [mainView2 setContentSize:CGSizeMake(bounds.size.width,289)];
    [mainView3 setContentSize:CGSizeMake(bounds.size.width,bounds.size.height - 64)];
    [self.view addSubview:mainView1];
    [self.view addSubview:mainView2];
    [self.view addSubview:mainView3];
    
    NSDictionary *segTitleAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor colorWithRed:109 / 255.0 green:110 / 255.0 blue:113 / 255.0 alpha:1.0], NSForegroundColorAttributeName,
                                       nil];
    
    //Preset Basic Info
    //Type Color
    [segType setTitleTextAttributes:segTitleAttribute forState:UIControlStateSelected];
    [segType setTitleTextAttributes:segTitleAttribute forState:UIControlStateNormal];
    [segType setTintColor:[UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0]];
    
    //Rental Border
    txtRental.layer.borderColor = [[UIColor colorWithRed:147 / 255.0 green:149 / 255.0 blue:152 / 255.0 alpha:1.0] CGColor];
    txtRental.layer.borderWidth = 1.0f;
    
    //Finally Set Basic Info
    viewYear.layer.borderColor = [[UIColor colorWithRed:147 / 255.0 green:149 / 255.0 blue:152 / 255.0 alpha:1.0f] CGColor];
    viewYear.layer.borderWidth = 0.5f;
    viewMonth.layer.borderColor = [[UIColor colorWithRed:147 / 255.0 green:149 / 255.0 blue:152 / 255.0 alpha:1.0f] CGColor];
    viewMonth.layer.borderWidth = 0.5f;
    viewDate.layer.borderColor = [[UIColor colorWithRed:147 / 255.0 green:149 / 255.0 blue:152 / 255.0 alpha:1.0f] CGColor];
    viewDate.layer.borderWidth = 0.5f;
    
    //Year Selection
    yearView = [[UITableView alloc] initWithFrame:CGRectMake(viewYear.frame.origin.x, viewYear.frame.origin.y + viewYear.frame.size.height, viewYear.frame.size.width, 120)];
    yearView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    yearView.layer.borderWidth = 1.0f;
    yearView.separatorStyle = UITableViewCellSeparatorStyleNone;
    yearView.backgroundColor = [UIColor whiteColor];
    [yearView setHidden:YES];
    [mainView1 addSubview:yearView];
    
    //Month Selection
    monthView = [[UITableView alloc] initWithFrame:CGRectMake(viewMonth.frame.origin.x, viewMonth.frame.origin.y + viewMonth.frame.size.height, viewMonth.frame.size.width, 120)];
    monthView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    monthView.layer.borderWidth = 1.0f;
    monthView.separatorStyle = UITableViewCellSeparatorStyleNone;
    monthView.backgroundColor = [UIColor whiteColor];
    [monthView setHidden:YES];
    [mainView1 addSubview:monthView];
    
    //Date Selection
    dateView = [[UITableView alloc] initWithFrame:CGRectMake(viewDate.frame.origin.x, viewDate.frame.origin.y + viewDate.frame.size.height, viewDate.frame.size.width, 120)];
    dateView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    dateView.layer.borderWidth = 1.0f;
    dateView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dateView.backgroundColor = [UIColor whiteColor];
    [dateView setHidden:YES];
    [mainView1 addSubview:dateView];
    
    //Furnish Color
    [segFurnish setTitleTextAttributes:segTitleAttribute forState:UIControlStateSelected];
    [segFurnish setTitleTextAttributes:segTitleAttribute forState:UIControlStateNormal];
    [segFurnish setTintColor:[UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0]];
    
    yearView.delegate = self;
    yearView.dataSource = self;
    monthView.delegate = self;
    monthView.dataSource = self;
    dateView.delegate = self;
    dateView.dataSource = self;
    
    txtName.delegate = self;
    txtRental.delegate = self;
    txtUnit.delegate = self;
    txtAddress1.delegate = self;
    txtAddress2.delegate = self;
    txtZipcode.delegate = self;
    
    UITapGestureRecognizer *yearTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onYearBtnPressed:)];
    [viewYear addGestureRecognizer:yearTap];
    
    UITapGestureRecognizer *monthTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMonthBtnPressed:)];
    [viewMonth addGestureRecognizer:monthTap];
    
    UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDateBtnPressed:)];
    [viewDate addGestureRecognizer:dateTap];
    
    //Preset Basic Info 2
    propView = [[UITableView alloc] initWithFrame:CGRectMake(txtName.frame.origin.x, txtName.frame.origin.y + viewDate.frame.size.height, txtName.frame.size.width, 120)];
    propView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    propView.layer.borderWidth = 1.0f;
    propView.separatorStyle = UITableViewCellSeparatorStyleNone;
    propView.backgroundColor = [UIColor whiteColor];
    [propView setHidden:YES];
    [mainView2 addSubview:propView];
    
    propView.delegate = self;
    propView.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    roomNumber = 1;
    toiletNumber = 0;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDate *curDate = [NSDate date];
    long firstYear = [delegate getYear:curDate];
    NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    NSString *firstMonth = [months objectAtIndex:[delegate getMonth:curDate] - 1];
    long firstDate = [delegate getDay:curDate];
    lblYear.text = [NSString stringWithFormat:@"%ld",firstYear];
    lblMonth.text = [NSString stringWithFormat:@"%@",firstMonth];
    lblDate.text = [NSString stringWithFormat:@"%ld",firstDate];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    numPhoto = 0;
    [self getListInfo];
    delegate.pid = @"";
}

-(void)viewWillAppear:(BOOL)animated
{
    if (photoPicker != nil && photoPicker.view.frame.origin.x == -320 && self.prevViewController != nil && [self.prevViewController isKindOfClass:[LoginViewController class]]) {
        CGRect frame = photoPicker.view.frame;
        frame.origin.x = -320;
        frame.origin.y = 0;
        [photoPicker.view setFrame:frame];
        CGRect bounds = [[UIScreen mainScreen] bounds];
        [self presentViewController:photoPicker animated:NO completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            mainView1.transform = CGAffineTransformMakeTranslation( -bounds.size.width * 2, 0 );
            mainView2.transform = CGAffineTransformMakeTranslation( -bounds.size.width * 2, 0 );
            mainView3.transform = CGAffineTransformMakeTranslation( -bounds.size.width * 2, 0 );
            photoPicker.view.transform = CGAffineTransformMakeTranslation( 0, 0 );
        }];
    }else if (self.prevViewController != nil && [self.prevViewController isKindOfClass:[VerifyViewController class]]) {
        [self onSaveBtnPressed:nil];
    }
}

- (void) getListInfo
{
    /*[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?task=metalist", actionUrl]];
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        
        [self performSelectorOnMainThread:@selector(doneGetListInfo:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [propView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });*/
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
}

- (void) doneGetListInfo :(NSString*)data
{
    
    NSDictionary  *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        propList = [NSMutableArray arrayWithArray:[dataDict objectForKey:@"properties"]];
        curPropList = [NSMutableArray arrayWithArray:[dataDict objectForKey:@"properties"]];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
    [yearView setHidden:YES];
    [monthView setHidden:YES];
    [dateView setHidden:YES];
    [propView setHidden:YES];
}

- (void)checkButton : (UIButton *)sender
{
    if (sender.backgroundColor == [UIColor whiteColor]) {
        [sender setBackgroundColor:[UIColor colorWithRed:190 / 255.0 green:237 / 255.0 blue:114 / 255.0 alpha:1.0]];
    }else {
        sender.backgroundColor = [UIColor whiteColor];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

- (void)monthGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UILabel *sender = (UILabel *)gesture.view;
    NSString *prevMonth = lblMonth.text;
    lblMonth.text = [NSString stringWithFormat:@"%@",sender.text];
    if (![lblMonth.text isEqualToString:prevMonth]) {
        [self refreshDate];
    }
    [monthView setHidden:YES];
}

- (void)dateGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UILabel *sender = (UILabel *)gesture.view;
    lblDate.text = [NSString stringWithFormat:@"%@",sender.text];
    [dateView setHidden:YES];
}

- (void) refreshDate
{
    NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    int curYear = [lblYear.text intValue];
    int curMonth = 1;
    NSString *curMonthStr = lblMonth.text;
    for (int i = 0; i < months.count; i++) {
        if ([[months objectAtIndex:i] isEqualToString:curMonthStr]) {
            curMonth = i + 1;
            break;
        }
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    int maxDate = [delegate getMaxDate:curYear month:curMonth];
    if (maxDate == dateView.subviews.count) {
        lblDate.text = @"1";
        return;
    }
    NSArray *viewsToRemove = [dateView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    [dateView reloadData];
    [dateView setContentSize:CGSizeMake(viewDate.frame.size.width, 20 * maxDate)];
    for (int i = 0; i < maxDate; i++) {
        NSString *dateStr = [NSString stringWithFormat:@"%d", i + 1];
        UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(5,i * 20,viewDate.frame.size.width - 5,20)];
        [labelDate setText:dateStr];
        [labelDate setTextColor:[UIColor grayColor]];
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:10.0f];
        [labelDate setFont:font];
        labelDate.userInteractionEnabled = YES;
        UITapGestureRecognizer *dateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateGestureCaptured:)];
        [labelDate addGestureRecognizer:dateTap];
        [dateView addSubview:labelDate];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeField = textField;
    [dateView setHidden:YES];
    [yearView setHidden:YES];
    [monthView setHidden:YES];
    [propView setHidden:YES];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    if ([textField isEqual:txtName] || [textField isEqual:txtUnit] || [textField isEqual:txtAddress1] || [textField isEqual:txtAddress2]) {
        [keyboardToolBar setItems: [NSArray arrayWithObjects:
            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
            [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(onKeyboardNextBtnPressed:)],
            [[UIBarButtonItem alloc]initWithTitle:@"Go" style:UIBarButtonItemStyleDone target:self action:@selector(onNextBtnPressed:)],
        nil]];
    }else if ([textField isEqual:txtRental] || [textField isEqual:txtZipcode]) {
        [keyboardToolBar setItems: [NSArray arrayWithObjects:
            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
            [[UIBarButtonItem alloc]initWithTitle:@"Go" style:UIBarButtonItemStyleDone target:self action:@selector(onNextBtnPressed:)],
        nil]];
    }
    textField.inputAccessoryView = keyboardToolBar;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:txtName]) {
        for (int i = 0; i < propList.count; i++) {
            NSString *compareStr = [[propList objectAtIndex:i] valueForKey:@"name"];
            if ([compareStr isEqualToString:textField.text]) {
                txtAddress1.text = [[propList objectAtIndex:i] valueForKey:@"address1"];
                txtAddress2.text = [[propList objectAtIndex:i] valueForKey:@"address2"];
                txtZipcode.text = [[propList objectAtIndex:i] valueForKey:@"zipcode"];
                txtUnit.text = [NSString stringWithFormat:@"%@",[[propList objectAtIndex:i] valueForKey:@"unit"]];
                segType.selectedSegmentIndex = [[[propList objectAtIndex:i] valueForKey:@"type"] intValue] - 1;
                break;
            }
        }
    }
    [propView setHidden:YES];
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackBtnPressed:(id)sender {
    if (photoPicker != nil && photoPicker.view.frame.origin.x == 0 && photoPicker.view.frame.origin.y == 0) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect frame = photoPicker.view.frame;
            mainView1.transform = CGAffineTransformMakeTranslation( -320, 0 );
            mainView2.transform = CGAffineTransformMakeTranslation( -320, 0 );
            mainView3.transform = CGAffineTransformMakeTranslation( -320, 0 );
            frame.origin.x = 320;
            [photoPicker.view setFrame:frame];
        } completion:^(BOOL finished) {
            [photoPicker dismissViewControllerAnimated:YES completion:nil];
        }];
    }else if (mainView2.frame.origin.x == 0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        mainView1.transform = CGAffineTransformMakeTranslation( 0, 0 );
        mainView2.transform = CGAffineTransformMakeTranslation( 0, 0 );
        mainView3.transform = CGAffineTransformMakeTranslation( 0, 0 );
        [UIView commitAnimations];
        [self.btnNext setHidden:NO];
    }else if (mainView1.frame.origin.x == 0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}

- (IBAction)onKeyboardNextBtnPressed:(id)sender {
    if ([activeField isEqual:txtName]) {
        [txtUnit becomeFirstResponder];
    }else if ([activeField isEqual:txtUnit]) {
        [txtAddress1 becomeFirstResponder];
    }else if ([activeField isEqual:txtAddress1]) {
        [txtAddress2 becomeFirstResponder];
    }else if ([activeField isEqual:txtAddress2]) {
        [txtZipcode becomeFirstResponder];
    }
}

- (IBAction)onNextBtnPressed:(id)sender {
    [self.view endEditing:YES];
    if (mainView1.frame.origin.x == 0) {
        if (segType.selectedSegmentIndex == -1) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Post" message:@"Please Select Property Type" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        if (txtRental.text == nil || [[txtRental.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Post" message:@"Please Enter Rental" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        if ([[txtRental.text substringToIndex:1] isEqualToString:@"0"] || [txtRental.text intValue] <= 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Post" message:@"Invalid Rentals" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        if (txtRental.text.length > 15) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Post" message:@"Rental is out of limit." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        if (segFurnish.selectedSegmentIndex == -1) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Post" message:@"Please Select Furnishing Type" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        if (segType.selectedSegmentIndex == 0) {
            [txtName setHidden:YES];
            [lblName setHidden:YES];
            [lblUnit setHidden:YES];
            [txtUnit setHidden:YES];
            [lblAddress setFrame:CGRectMake(27, 109, 70, 21)];
            [txtAddress1 setFrame:CGRectMake(136, 105, 172, 30)];
            [txtAddress2 setFrame:CGRectMake(136, 145, 172, 30)];
            [lblZipcode setFrame:CGRectMake(27, 189, 70, 21)];
            [txtZipcode setFrame:CGRectMake(136, 185, 172, 30)];
            [lblType setText:@"Landed"];
        }else {
            [txtName setHidden:NO];
            [lblName setHidden:NO];
            [txtUnit setHidden:NO];
            [lblUnit setHidden:NO];
            [lblName setFrame:CGRectMake(27, 109, 101, 21)];
            [txtName setFrame:CGRectMake(136, 105, 172, 30)];
            [lblUnit setFrame:CGRectMake(27, 149, 101, 21)];
            [txtUnit setFrame:CGRectMake(136, 145, 172, 30)];
            [lblAddress setFrame:CGRectMake(27, 189, 70, 21)];
            [txtAddress1 setFrame:CGRectMake(136, 185, 172, 30)];
            [txtAddress2 setFrame:CGRectMake(136, 225, 172, 30)];
            [lblZipcode setFrame:CGRectMake(27, 269, 70, 21)];
            [txtZipcode setFrame:CGRectMake(136, 265, 172, 30)];
            [lblType setText:@"High Rise"];
        }
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        mainView1.transform = CGAffineTransformMakeTranslation( -320, 0 );
        mainView2.transform = CGAffineTransformMakeTranslation( -320, 0 );
        mainView3.transform = CGAffineTransformMakeTranslation( -320, 0 );
        [UIView commitAnimations];
    }else if (mainView2.frame.origin.x == 0) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = delegate.managedObjectContext;
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        if ([lblType.text isEqualToString:@"High Rise"] && (txtName.text == nil || [[txtName.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Post" message:@"Please Enter Building Name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        
        if ([lblType.text isEqualToString:@"High Rise"] && (txtUnit.text == nil || [[txtUnit.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Post" message:@"Please Enter Unit" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        if (txtAddress1.text == nil || [[txtAddress1.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Post" message:@"Please Enter Address" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        if (txtZipcode.text == nil || [[txtZipcode.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Post" message:@"Please Enter Zipcode" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }else if (![delegate isValidPinCode:txtZipcode.text]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Post" message:@"Invalid Zipcode" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        
        if ([lblType.text isEqualToString:@"High Rise"]) {
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@' and name='%@' and type='%d'",delegate.userid,txtName.text,segType.selectedSegmentIndex + 1]]];
        }else {
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@' and address1='%@' and address2='%@' and type='%d'",delegate.userid,txtAddress1.text,txtAddress2.text,segType.selectedSegmentIndex + 1]]];
        }
        
        NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
        [fetchRequest setEntity:propEntity];
        NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (propObjects.count > 0) {
            if (segType.selectedSegmentIndex == 1) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Post" message:@"Duplicate Property Name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
                return;
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Post" message:@"Duplicate Address" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
                return;
            }
        }
        
        photoPicker = [[UIImagePickerController alloc] init];
            
        photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        photoPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        photoPicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        CGRect rect = [[UIScreen mainScreen] bounds];
        [photoPicker.view setFrame:CGRectMake(rect.size.width, 0, rect.size.width, rect.size.height)];
        photoPicker.showsCameraControls = NO;
        photoPicker.navigationBarHidden = YES;
        photoPicker.toolbarHidden = YES;
        //photoPicker.wantsFullScreenLayout = YES;
        CGAffineTransform cameraLocTransform = CGAffineTransformMakeTranslation(0, 70);
        photoPicker.cameraViewTransform = cameraLocTransform;
        photoPicker.cameraOverlayView = cameraView;
        photoPicker.delegate = self;
        [photoPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        CGRect picFrame = photoPicker.view.frame;
        picFrame.origin.x = 320;
        [photoPicker.view setFrame:picFrame];
        
        [self presentViewController:photoPicker animated:NO completion:^{
            CGRect picFrame = photoPicker.view.frame;
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationDelegate:self];
            CGRect bounds = [[UIScreen mainScreen] bounds];
            mainView1.transform = CGAffineTransformMakeTranslation( -bounds.size.width * 2, 0 );
            mainView2.transform = CGAffineTransformMakeTranslation( -bounds.size.width * 2, 0 );
            mainView3.transform = CGAffineTransformMakeTranslation( -bounds.size.width * 2, 0 );
            picFrame.origin.x = 0;
            [photoPicker.view setFrame:picFrame];
            [UIView commitAnimations];
        }];
    }
}

- (IBAction)onSaveBtnPressed:(id)sender {
    NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    int month = 0;
    for (int i = 0; i < months.count; i++) {
        if ([[months objectAtIndex:i] isEqualToString:lblMonth.text]) {
            month = i + 1;
            break;
        }
    }
    NSString *availability = [NSString stringWithFormat:@"%@-%d-%@",lblYear.text,month,lblDate.text];
    int quality = 0;
    if (self.imgCameraView.subviews.count >=3) {
        quality++;
    }else if (self.imgCameraView.subviews.count >= 5) {
        quality += 2;
    }else if (self.imgCameraView.subviews.count >= 8) {
        quality += 5;
    }
    
    NSString *name = txtName.text;
    if (name == nil) {
        name = @"";
    }
    NSString *unit = txtUnit.text;
    if (unit == nil) {
        unit = @"";
    }
    NSInteger type = segType.selectedSegmentIndex + 1;
    if (type == 1) {
        name = @"";
        unit = @"";
    }
    int rooms = 0, toilets = 0;
    for (int i = 0; i < self.imgCameraView.subviews.count; i++) {
        UIImageView *imgPhoto = (UIImageView *)[self.imgCameraView.subviews objectAtIndex:i];
        if (imgPhoto.tag == 1) {
            rooms++;
        }else if (imgPhoto.tag == 2) {
            toilets++;
        }
    }
    NSString *rentals = txtRental.text;
    if (rentals == nil) {
        rentals = @"";
    }
    NSInteger furnish_type = 3 - segFurnish.selectedSegmentIndex;
    NSString *address1 = txtAddress1.text;
    if (address1 == nil) {
        address1 = @"";
    }
    NSString *address2 = txtAddress2.text;
    if (address2 == nil) {
        address2 = @"";
    }
    NSString *zipcode = txtZipcode.text;
    if (zipcode == nil) {
        zipcode = @"";
    }
    
    NSString *timeStr = @"[";
    for (int i = 0; i < 7; i++) {
        if (i > 0) {
            timeStr = [NSString stringWithFormat:@"%@,",timeStr];
        }
        timeStr = [NSString stringWithFormat:@"%@[",timeStr];
        for (int j = 0; j < 4; j++) {
            if (j > 0) {
                timeStr = [NSString stringWithFormat:@"%@,",timeStr];
            }
            timeStr = [NSString stringWithFormat:@"%@1",timeStr];
        }
        timeStr = [NSString stringWithFormat:@"%@]",timeStr];
    }
    timeStr = [NSString stringWithFormat:@"%@]",timeStr];
    if (![availability isEqualToString:@""]) {
        quality++;
    }
    if (![txtRental.text isEqualToString:@""]) {
        quality++;
    }
    if (![address1 isEqualToString:@""]) {
        quality++;
    }
    if (![address2 isEqualToString:@""]) {
        quality++;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Get User Data
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"user_id='%@' ",delegate.userid]]];
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    [fetchRequest setEntity:userEntity];
    NSArray *userObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (type == 2) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@' and name='%@' and type='%d'",delegate.userid,name,type]]];
    }else {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid='%@' and address1='%@' and address2='%@' and type='%d'",delegate.userid,address1,address2,type]]];
    }
    NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:context];
    [fetchRequest setEntity:propEntity];
    NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (propObjects.count == 0) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect frame = photoPicker.view.frame;
            frame.origin.x = -320;
            [photoPicker.view setFrame:frame];
        } completion:^(BOOL finished) {
            [photoPicker dismissViewControllerAnimated:YES completion:nil];
        }];
        Property *propObject = [NSEntityDescription insertNewObjectForEntityForName:@"Property" inManagedObjectContext:context];
        /*[fetchRequest setPredicate:nil];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"propertyid" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
        propObjects = [context executeFetchRequest:fetchRequest error:nil];
        if (propObjects.count > 0) {
            Property *maxObject = (Property *)[propObjects objectAtIndex:0];
            propObject.propertyid = [NSNumber numberWithInt:[maxObject.propertyid intValue] + 1];
        }else {
            propObject.propertyid = [NSNumber numberWithInt:1];
        }*/
        propObject.userid = [NSNumber numberWithInt:[delegate.userid intValue]];
        propObject.name = name;
        propObject.quality = [NSNumber numberWithInt:quality];
        propObject.type = [NSNumber numberWithLong:type];
        propObject.rooms = [NSNumber numberWithInt:rooms];
        propObject.unit = unit;
        propObject.toilets = [NSNumber numberWithInt:toilets];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-M-d"];
        propObject.availability = [dateFormat dateFromString:availability];
        NSLog(@"%@",propObject.availability);
        propObject.rental = [NSString stringWithFormat:@"%@",rentals];
        propObject.furnish_type = [NSNumber numberWithInt:furnish_type];
        propObject.address1 = address1;
        propObject.address2 = address2;
        propObject.zipcode = zipcode;
        if (address1 != nil && ![address1 isEqualToString:@""]) {
            NSDictionary *geoloc = [delegate getGeolocation:[NSString stringWithFormat:@"%@ Malaysia",address1]];
            if (geoloc != nil) {
                propObject.latitude = [geoloc objectForKey:@"lat"];
                propObject.longitude = [geoloc objectForKey:@"lng"];
            }
        }
        delegate.pid = [NSString stringWithFormat:@"%@",propObject.propertyid];
        propObject.time = timeStr;
        propObject.prefertimestart = [NSDate date];
        propObject.status = [NSNumber numberWithInt:1];
        propObject.datecreated = [NSDate date];
        for (int i = 0; i < self.imgCameraView.subviews.count; i++) {
            UIImageView *imgView = (UIImageView *)[self.imgCameraView.subviews objectAtIndex:i];
            NSData *imgData = UIImageJPEGRepresentation(imgView.image,1);
            PropertyImage *imageObject = [NSEntityDescription insertNewObjectForEntityForName:@"PropertyImage" inManagedObjectContext:context];
            imageObject.data = imgData;
            imageObject.propertyid = [NSNumber numberWithInt:[delegate.pid intValue]];
            imageObject.datecreated = [NSDate date];
            imageObject.propertyInfo = propObject;
        }
        if (userObjects.count > 0) {
            propObject.userInfo = (Users *)[userObjects objectAtIndex:0];
        }
        [delegate saveContext];
        [self.btnNext setHidden:YES];
        [self.btnBack setHidden:YES];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        CGRect bounds = [[UIScreen mainScreen] bounds];
        mainView1.transform = CGAffineTransformMakeTranslation( -bounds.size.width * 3, 0 );
        mainView2.transform = CGAffineTransformMakeTranslation( -bounds.size.width * 3, 0 );
        mainView3.transform = CGAffineTransformMakeTranslation( -bounds.size.width * 3, 0 );
        [UIView commitAnimations];
        
        NSDictionary *params = @{@"task":@"postsave",
                                 @"userid":delegate.userid,
                                 @"type":[NSString stringWithFormat:@"%ld",(long)type],
                                 @"rentals":rentals,
                                 @"availability":availability,
                                 @"furnish_type":[NSString stringWithFormat:@"%ld",(long)furnish_type],
                                 @"name":name,
                                 @"unit":unit,
                                 @"address1":address1,
                                 @"address2":address2,
                                 @"zipcode":zipcode,
                                 @"rooms":[NSString stringWithFormat:@"%d",[propObject.rooms intValue]],
                                 @"toilets":[NSString stringWithFormat:@"%d",[propObject.toilets intValue]],
                                 @"time":timeStr,
                                 @"prefertimestart":[NSDate date],
                                 };
        NSURL *url = [NSURL URLWithString:actionUrl];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/json/index.php" parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            NSLog(@"%ld",self.imgCameraView.subviews.count);
            for (int i = 0; i < self.imgCameraView.subviews.count; i++) {
                UIImageView *imgView = (UIImageView *)[self.imgCameraView.subviews objectAtIndex:i];
                NSData *imgData = UIImageJPEGRepresentation(imgView.image,1);
                [formData appendPartWithFileData:imgData name:@"photo[]" fileName:[NSString stringWithFormat:@"photo%d.jpg",i] mimeType:@"image/jpeg"];
            }
        }];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        }];
        [httpClient enqueueBatchOfHTTPRequestOperations:@[operation] progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
            
        } completionBlock:^(NSArray *operations) {
            NSDictionary *dataDict = (NSDictionary*)[operation.responseString JSONValue];
            if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithBool:true]]) {
                propObject.propertyid = [NSNumber numberWithInt:[[dataDict objectForKey:@"id"] intValue]];
                delegate.pid = [NSString stringWithFormat:@"%d",[propObject.propertyid intValue]];
            }
        }];
        //[httpClient enqueueHTTPRequestOperation:operation];
        
        /*imgString = [imgString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        
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
                     delegate.pid = [NSString stringWithFormat:@"%d",[[dataDict objectForKey:@"id"] intValue]];
                     [delegate saveContext];
                 }
                 NSLog(@"Success");
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if ([self isViewLoaded]) {
                 NSLog(@"Failed");
             }
         }];*/
    
    }else {
        if (type == 1) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"Duplicate Property Name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"Duplicate Address" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
        return;
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    resData = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [resData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* data = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    kbSize.height += 44;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    if (activeField != nil && [activeField isEqual:txtRental]) {
        mainView1.contentInset = contentInsets;
        mainView1.scrollIndicatorInsets = contentInsets;
    }else if (activeField != nil && ([activeField isEqual:txtName] || [activeField isEqual:txtUnit] || [activeField isEqual:txtAddress1] || [activeField isEqual:txtAddress2] || [activeField isEqual:txtZipcode])) {
        mainView2.contentInset = contentInsets;
        mainView2.scrollIndicatorInsets = contentInsets;
    }
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (activeField != nil && [activeField isEqual:txtRental]) {
        CGPoint tPoint = activeField.frame.origin;
        tPoint.y = tPoint.y - mainView1.contentOffset.y + mainView1.frame.origin.y + activeField.frame.size.height;
        if (!CGRectContainsPoint(aRect, tPoint)) {
            [mainView1 setContentOffset:CGPointMake(0.0, mainView1.contentOffset.y + tPoint.y - aRect.size.height) animated:YES];
        }
    }else if (activeField != nil && ([activeField isEqual:txtName] || [activeField isEqual:txtAddress1] || [activeField isEqual:txtAddress2] || [activeField isEqual:txtUnit] || [activeField isEqual:txtZipcode])) {
        CGPoint tPoint = activeField.frame.origin;
        tPoint.y = tPoint.y - mainView2.contentOffset.y + mainView2.frame.origin.y + activeField.frame.size.height;
        if (!CGRectContainsPoint(aRect, tPoint)) {
            [mainView2 setContentOffset:CGPointMake(0.0, mainView2.contentOffset.y + tPoint.y - aRect.size.height) animated:YES];
        }
    }
}

-(void)textFieldDidBeginEditing: (UITextField *)textField
{
    activeField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:txtName]) {
        for (int i = 0; i < propList.count; i++) {
            NSString *compareStr = [[propList objectAtIndex:i] valueForKey:@"name"];
            if ([compareStr isEqualToString:textField.text]) {
                txtAddress1.text = [[propList objectAtIndex:i] valueForKey:@"address1"];
                txtAddress2.text = [[propList objectAtIndex:i] valueForKey:@"address2"];
                txtZipcode.text = [[propList objectAtIndex:i] valueForKey:@"zipcode"];
                txtUnit.text = [NSString stringWithFormat:@"%@",[[propList objectAtIndex:i] valueForKey:@"unit"]];
                segType.selectedSegmentIndex = [[[propList objectAtIndex:i] valueForKey:@"type"] intValue] - 1;
                break;
            }
        }
    }
    activeField = nil;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if (activeField != nil && [activeField isEqual:txtRental]) {
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        mainView1.contentInset = contentInsets;
        mainView1.scrollIndicatorInsets = contentInsets;
    }else if (activeField != nil && ([activeField isEqual:txtName] || [activeField isEqual:txtUnit] || [activeField isEqual:txtAddress1] || [activeField isEqual:txtAddress2] || [activeField isEqual:txtZipcode])) {
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        mainView2.contentInset = contentInsets;
        mainView2.scrollIndicatorInsets = contentInsets;
    }
    
}

- (IBAction)onTakeBtnPressed:(id)sender {
    [photoPicker takePicture];
}

- (IBAction)onLibraryBtnPressed:(id)sender {
    [photoPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIImageView *imgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height - 162)];
    UIImage *image = (UIImage *)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        image = [delegate scaleImage:image toSize:CGSizeMake(320,240)];
    }else {
        image = [delegate scaleImage:image toSize:CGSizeMake(320,240)];
    }
    //image = [delegate cropImage:image];
    [tempCameraView setImage:image];
    [imgPhoto setImage:image];
    [self.imgCameraView addSubview:imgPhoto];
    numPhoto++;
    if ([self.lblRoomNumber.text hasPrefix:@"Room"]) {
        imgPhoto.tag = 1;
    }else if ([self.lblRoomNumber.text hasPrefix:@"Toilet"]) {
        imgPhoto.tag = 2;
    }else if ([self.lblRoomNumber.text isEqualToString:@"Living hall"]) {
        imgPhoto.tag = 3;
    }else if ([self.lblRoomNumber.text isEqualToString:@"Kitchen"]) {
        imgPhoto.tag = 4;
    }else if ([self.lblRoomNumber.text isEqualToString:@"Balcony"]) {
        imgPhoto.tag = 5;
    }
    if (numPhoto == 5 && [self.lblRoomNumber.text hasPrefix:@"Room"]) {
        toiletNumber++;
        self.lblRoomNumber.text = [NSString stringWithFormat:@"Toilet %d",toiletNumber];
        numPhoto = 0;
    }else if (numPhoto == 5 && [self.lblRoomNumber.text hasPrefix:@"Toilet"]) {
        if (roomNumber == 1 && self.imgCameraView.subviews.count == 5) {
            self.lblRoomNumber.text = @"Living hall";
        }else {
            roomNumber++;
            self.lblRoomNumber.text = [NSString stringWithFormat:@"Room %d",roomNumber];
        }
        numPhoto = 0;
    }else if (numPhoto == 5 && [self.lblRoomNumber.text isEqualToString:@"Living hall"]) {
        numPhoto = 0;
        self.lblRoomNumber.text = @"Kitchen";
    }else if (numPhoto == 5 && [self.lblRoomNumber.text isEqualToString:@"Kitchen"]) {
        numPhoto = 0;
        self.lblRoomNumber.text = @"Balcony";
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else if (numPhoto == 5 && [self.lblRoomNumber.text isEqualToString:@"Balcony"]) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect frame = photoPicker.view.frame;
            frame.origin.x = -320;
            [photoPicker.view setFrame:frame];
        } completion:^(BOOL finished) {
            [photoPicker dismissViewControllerAnimated:YES completion:nil];
        }];
        NSArray *images = self.imgCameraView.subviews;
        int numRoom = 0;
        int numToilet = 0;
        for (int i = 0; i < images.count; i++) {
            UIImageView *imgView = (UIImageView *)[images objectAtIndex:i];
            if (imgView.tag == 1) {
                numRoom++;
            }else if (imgView.tag == 2) {
                numToilet++;
            }
        }
        segRooms.selectedSegmentIndex = MIN(4,numRoom);
        if (toiletNumber > 0) {
            segToilets.selectedSegmentIndex = MIN(4,numToilet - 1);
        }
        if (delegate.phone == nil || [delegate.phone isEqualToString:@""]) {
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            loginViewController.prevViewController = self;
            loginViewController.lblError = [[UILabel alloc] initWithFrame:CGRectMake(22,23,251,96)];
            loginViewController.lblView = [[UILabel alloc] initWithFrame:CGRectMake(12,29,296,141)];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                loginViewController.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height - 20)];
                loginViewController.imgBack = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height - 20)];
            }else {
                loginViewController.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
                loginViewController.imgBack = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)];
            }
            
            UIView *viewStatus = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 20)];
            viewStatus.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                [viewStatus setHidden:YES];
            }else {
                [viewStatus setHidden:NO];
            }
            [loginViewController.imgBack setImage:[UIImage imageNamed:@"phone_bg1.png"]];
            [loginViewController.imgBack setHidden:YES];
            [loginViewController.view addSubview:loginViewController.imgBack];
            [loginViewController.lblView addSubview:loginViewController.lblError];
            [loginViewController.scrollView addSubview:loginViewController.lblView];
            [loginViewController.view addSubview:loginViewController.scrollView];
            [loginViewController.view addSubview:viewStatus];
            loginViewController.lblError.text = @"Ops, you have not registered or sign in to post this property. Signing in is quick, just enter your mobile number";
            [loginViewController.lblView setHidden:NO];
            delegate.afterControllerName = @"PostNewViewController";
            [self.navigationController pushViewController:loginViewController animated:YES];
            return;
        }else {
            [self onSaveBtnPressed:nil];
            /*mainView1.transform = CGAffineTransformMakeTranslation( -960, 0 );
            mainView2.transform = CGAffineTransformMakeTranslation( -960, 0 );
            mainView3.transform = CGAffineTransformMakeTranslation( -960, 0 );*/
        }
    }
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    /*[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = photoPicker.view.frame;
        frame.origin.x = -320;
        [photoPicker.view setFrame:frame];
    } completion:^(BOOL finished) {
        [photoPicker dismissViewControllerAnimated:YES completion:nil];
    }];*/
    [photoPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onYearBtnPressed:(id)sender {
    [self.view endEditing:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([yearView isHidden]) {
        long curYear;
        NSDate *curDate = [NSDate date];
        long firstYear = [delegate getYear:curDate];
        if ([lblYear.text isEqualToString:@"-"]) {
            curYear = firstYear;
        }else {
            curYear = [lblYear.text intValue];
        }
        if (curYear - firstYear > 13) {
            curYear = firstYear + 13;
        }
        [yearView setContentOffset:CGPointMake(0,(curYear - firstYear) * 20)];
        [yearView setHidden:NO];
        [monthView setHidden:YES];
        [dateView setHidden:YES];
        [propView setHidden:YES];
    }else {
        [yearView setHidden:YES];
    }
}

- (IBAction)onMonthBtnPressed:(id)sender {
    [self.view endEditing:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([monthView isHidden]) {
        NSString *curMonthStr = lblMonth.text;
        NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
        long curMonth = 0;
        long startMonth = 0;
        if ([lblYear.text intValue] == [delegate getYear:[NSDate date]]) {
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
        [propView setHidden:YES];
    }else {
        [monthView setHidden:YES];
    }
}

- (IBAction)onDateBtnPressed:(id)sender {
    [self.view endEditing:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([dateView isHidden]) {
        long curDate;
        if ([lblDate.text isEqualToString:@"-"]) {
            curDate = 1;
        }else {
            curDate = [lblDate.text intValue];
        }
        long startDate = 1;
        if ([lblYear.text intValue] == [delegate getYear:[NSDate date]]) {
            NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
            int curMonth = 1;
            for (int i = 0; i < months.count; i++) {
                if ([[months objectAtIndex:i] isEqualToString:lblMonth.text]) {
                    curMonth = i + 1;
                    break;
                }
            }
            if (curMonth == [delegate getMonth:[NSDate date]]) {
                startDate = [delegate getDay:[NSDate date]];
            }
        }
        if (curDate > [delegate getMaxDate:[lblYear.text intValue] month:[lblMonth.text intValue]] - 6) {
            if (startDate > [delegate getMaxDate:[lblYear.text intValue] month:[lblMonth.text intValue]] - 6) {
                curDate = startDate;
            }else {
                curDate = [delegate getMaxDate:[lblYear.text intValue] month:[lblMonth.text intValue]] - 5;
            }
        }
        [dateView setContentOffset:CGPointMake(0,(curDate - startDate) * 20)];
        [dateView setHidden:NO];
        [monthView setHidden:YES];
        [yearView setHidden:YES];
        [propView setHidden:YES];
    }else {
        [dateView setHidden:YES];
    }
}

- (IBAction)onAttractBtnPressed:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([delegate.pid isEqualToString:@""]) {
        /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"You must import at least one photo of toilets." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];*/
        return;
    }
    PostEditViewController *postEditViewController = [[PostEditViewController alloc] init];
    postEditViewController.prevViewController = self;
    [self.navigationController pushViewController:postEditViewController animated:YES];
    /*[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    mainView1.transform = CGAffineTransformMakeTranslation( -1280, 0 );
    mainView2.transform = CGAffineTransformMakeTranslation( -1280, 0 );
    mainView3.transform = CGAffineTransformMakeTranslation( -1280, 0 );
    mainView4.transform = CGAffineTransformMakeTranslation( -1280, 0 );
    [UIView commitAnimations];*/
}

- (IBAction)onOkBtnPressed:(id)sender {
    [viewTerms setHidden:YES];
}

- (IBAction)onTypeSelected:(id)sender {
    if (segType.selectedSegmentIndex == 0) {
        segFurnish.selectedSegmentIndex = 2;
    }else if (segType.selectedSegmentIndex == 1) {
        segFurnish.selectedSegmentIndex = 1;
    }
}

- (void) setEnable:(BOOL)enable
{
    [self.view setUserInteractionEnabled:enable];
}

- (IBAction)onFacebookBtnPressed:(id)sender {
    // Check if the Facebook app is installed and we can present the share dialog
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    params.name = @"RealEstate";
    params.caption = @"Love Your Home And Garden.";
    params.picture = [NSURL URLWithString:@"http://i.imgur.com/g3Qc1HN.png"];
    params.description = SHARE_MESSAGE;
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:params.description];
        [self presentViewController:controller animated:YES completion:Nil];
    }else {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        {
            SLComposeViewController *facebookSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeFacebook];
            [facebookSheet setInitialText:SHARE_MESSAGE];
            
            [self presentViewController:facebookSheet animated:YES completion:nil];
            
            //inform the user that no account is configured with alarm view.
        }
    }
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        /*[FBDialogs presentShareDialogWithLink:params.link
         name:params.name
         caption:params.caption
         description:params.description
         picture:params.picture
         clientState:nil
         handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
         if(error) {
         // An error occurred, we need to handle the error
         // See: https://developers.facebook.com/docs/ios/errors
         NSLog(@"Error publishing story: %@", error.description);
         } else {
         // Success
         NSLog(@"result %@", results);
         }
         }];*/
    } else {
        // Present the feed dialog
        // Put together the dialog parameters
        /*NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
         @"RealEstate", @"name",
         @"Love Your Home And Garden.", @"caption",
         [NSString stringWithFormat:@"%@ thinks SAYWA mobile app for property rental is wonderful. You can download it at dl.saywa.my",username], @"description",
         @"https://developers.facebook.com/docs/ios/share/", @"link",
         @"http://i.imgur.com/g3Qc1HN.png", @"picture",
         nil];
         
         // Show the feed dialog
         [FBWebDialogs presentFeedDialogModallyWithSession:nil
         parameters:params
         handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
         // An error occurred, we need to handle the error
         // See: https://developers.facebook.com/docs/ios/errors
         NSLog(@"Error publishing story: %@", error.description);
         } else {
         if (result == FBWebDialogResultDialogNotCompleted) {
         // User cancelled.
         NSLog(@"User cancelled.");
         } else {
         // Handle the publish feed callback
         NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
         
         if (![urlParams valueForKey:@"post_id"]) {
         // User cancelled.
         NSLog(@"User cancelled.");
         
         } else {
         // User clicked the Share button
         NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
         NSLog(@"result %@", result);
         }
         }
         }
         }];*/
    }
    
    // Put together the dialog parameters
    /*NSString *username = @"Anonymous Person";
     if (delegate.username != nil && ![delegate.username isEqualToString:@""]) {
     username = delegate.username;
     }
     NSString *description = [NSString stringWithFormat:@"%@ thinks SAYWA mobile app for property rental is wonderful. You can download it at dl.saywa.my",username];
     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"RealEstate", @"name",
     @"Love Your Home And Garden", @"caption",
     description, @"description",
     @"https://developers.facebook.com/docs/ios/share/", @"link",
     @"http://i.imgur.com/g3Qc1HN.png", @"picture",
     nil];
     
     // Make the request
     [FBRequestConnection startWithGraphPath:@"/me/feed"
     parameters:params
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
     if (!error) {
     // Link posted successfully to Facebook
     NSLog(@"result: %@", result);
     } else {
     // An error occurred, we need to handle the error
     // See: https://developers.facebook.com/docs/ios/errors
     NSLog(@"%@", error.description);
     }
     }];*/
}

- (IBAction)onTwitterBtnPressed:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:SHARE_MESSAGE];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }else {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeFacebook];
            [tweetSheet setInitialText:SHARE_MESSAGE];
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
            
            //inform the user that no account is configured with alarm view.
        }
    }
}

- (IBAction)onPhoneBtnPressed:(id)sender {
    
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    NSMutableArray *emails = [[NSMutableArray alloc] init];
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,error);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        });
    }
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        
        for(int i = 0; i < numberOfPeople; i++) {
            
            ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
            
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            ABMutableMultiValueRef eMails  = ABRecordCopyValue(person, kABPersonEmailProperty);
            [[UIDevice currentDevice] name];
            
            for (CFIndex j = 0; j < ABMultiValueGetCount(phoneNumbers); j++) {
                NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, j);
                
                [numbers addObject:phoneNumber];
            }
            for (CFIndex j = 0; j < ABMultiValueGetCount(eMails); j++) {
                NSString *email = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(eMails, j);
                
                [emails addObject:email];
            }
        }
    }else {
        // Send an alert telling user to change privacy setting in settings app
        NSLog(@"Unable to Get Phone Contact");
    }
    NSDictionary *params = @{@"phoneNumbers":[numbers JSONRepresentation],
                             @"message":SHARE_MESSAGE
                             };
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:sendSMSUrl]];
    
    [client
     postPath:@"/sendSMS.php"
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
    /*if ([MFMailComposeViewController canSendMail]) {
        // Show the composer
        MFMailComposeViewController* emailController = [[MFMailComposeViewController alloc] init];
        emailController.mailComposeDelegate = self;
        [emailController setSubject:@"RealEstate"];
        [emailController setMessageBody:SHARE_MESSAGE isHTML:NO];
        [emailController setToRecipients:emails];
        if (emailController) {
            [self presentViewController:emailController animated:YES completion:nil];
        }
    }else {
        // Handle the error
        NSLog(@"Unable to Send Email");
    }*/
}

- (IBAction)onSkipBtnPressed:(id)sender {
    if ([self.lblRoomNumber.text hasPrefix:@"Room"]) {
        if (numPhoto > 0) {
            toiletNumber++;
            self.lblRoomNumber.text = [NSString stringWithFormat:@"Toilet %d",toiletNumber];
        }else {
            NSArray *images = self.imgCameraView.subviews;
            if (images.count == 0) {
                toiletNumber++;
                self.lblRoomNumber.text = [NSString stringWithFormat:@"Toilet %d",toiletNumber];
            }else {
                self.lblRoomNumber.text = @"Living hall";
            }
        }
        numPhoto = 0;
    }else if ([self.lblRoomNumber.text hasPrefix:@"Toilet"]) {
        NSArray *images = self.imgCameraView.subviews;
        if (images.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"You must import at least one photo of toilets." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        if (numPhoto == 0) {
            self.lblRoomNumber.text = @"Living hall";
        }else {
            if (roomNumber > 1) {
                roomNumber++;
                self.lblRoomNumber.text = [NSString stringWithFormat:@"Room %d",roomNumber];
            }else {
                BOOL isExistRoom = NO;
                for (int i = 0; i < self.imgCameraView.subviews.count; i++) {
                    UIImageView *imgPhoto = (UIImageView*)[self.imgCameraView.subviews objectAtIndex:i];
                    if (imgPhoto.tag == 1) {
                        isExistRoom = YES;
                        break;
                    }
                }
                if (isExistRoom) {
                    roomNumber++;
                    self.lblRoomNumber.text = [NSString stringWithFormat:@"Room %d",roomNumber];
                }else {
                    self.lblRoomNumber.text = @"Living hall";
                }
            }
        }
        numPhoto = 0;
    }else if ([self.lblRoomNumber.text isEqualToString:@"Living hall"]) {
        numPhoto = 0;
        self.lblRoomNumber.text = @"Kitchen";
    }else if ([self.lblRoomNumber.text isEqualToString:@"Kitchen"]) {
        numPhoto = 0;
        self.lblRoomNumber.text = @"Balcony";
    }else {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSArray *images = self.imgCameraView.subviews;
        int numRoom = 0;
        int numToilet = 0;
        for (int i = 0; i < images.count; i++) {
            UIImageView *imgView = (UIImageView *)[images objectAtIndex:i];
            if (imgView.tag == 1) {
                numRoom++;
            }else if (imgView.tag == 2) {
                numToilet++;
            }
        }
        segRooms.selectedSegmentIndex = MIN(4,numRoom);
        if (numToilet > 0) {
            segToilets.selectedSegmentIndex = MIN(4,numToilet - 1);
        }
        if (delegate.phone == nil || [delegate.phone isEqualToString:@""]) {
            LoginViewController *loginViewController = [[LoginViewController alloc] init];
            loginViewController.prevViewController = self;
            loginViewController.lblError = [[UILabel alloc] initWithFrame:CGRectMake(22,23,251,96)];
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
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                [viewStatus setHidden:YES];
            }else {
                [viewStatus setHidden:NO];
            }
            [loginViewController.imgBack setImage:[UIImage imageNamed:@"phone_bg1.png"]];
            [loginViewController.view addSubview:loginViewController.imgBack];
            [loginViewController.lblView addSubview:loginViewController.lblError];
            [loginViewController.scrollView addSubview:loginViewController.lblView];
            [loginViewController.view addSubview:loginViewController.scrollView];
            [loginViewController.view addSubview:viewStatus];
            
            [loginViewController.lblError setText:@"Ops, you have not registered or sign in to post this property. Signing in is quick, just enter your mobile number"];
            [loginViewController.lblView setHidden:NO];
            delegate.afterControllerName = @"PostNewViewController";
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                CGRect frame = photoPicker.view.frame;
                frame.origin.x = -320;
                [photoPicker.view setFrame:frame];
            } completion:^(BOOL finished) {
                [photoPicker dismissViewControllerAnimated:YES completion:^{
                    [self.navigationController pushViewController:loginViewController animated:YES];
                }];
            }];
        }else {
            //[[NSNotificationCenter defaultCenter] removeObserver:self];
            [self onSaveBtnPressed:sender];
            /*mainView1.transform = CGAffineTransformMakeTranslation( -960, 0 );
            mainView2.transform = CGAffineTransformMakeTranslation( -960, 0 );
            mainView3.transform = CGAffineTransformMakeTranslation( -960, 0 );*/
        }
    }
}

- (void) doneSendSMS :(NSString*)data
{
    [self.view endEditing:YES];
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithBool:true]])
    {
        NSMutableArray *nonSent = (NSMutableArray *)[dataDict objectForKey:@"nonSent"];
        for (int i = 0; i < nonSent.count; i++) {
            //NSLog(@"%@",[nonSent objectAtIndex:i]);
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"We are experiencing high load, and will rectify this as soon as possible. We are aware of this issue." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([tableView isEqual:yearView]) {
        return 20;
    }else if ([tableView isEqual:monthView]) {
        long year = [delegate getYear:[NSDate date]];
        if (![lblYear.text isEqualToString:@"-"]) {
            year = [lblYear.text intValue];
        }
        if ([delegate getYear:[NSDate date]] == year) {
            return 13 - [delegate getMonth:[NSDate date]];
        }else {
            return 12;
        }
    }else if ([tableView isEqual:dateView]) {
        long curYear = [delegate getYear:[NSDate date]];
        if (![lblYear.text isEqualToString:@"-"]) {
            curYear = [lblYear.text intValue];
        }
        if ([lblMonth.text isEqualToString:@"-"]) {
            lblMonth.text = months[[delegate getMonth:[NSDate date]] - 1];
        }
        int curMonth = 1;
        NSString *curMonthStr = lblMonth.text;
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
        long year = [delegate getYear:[NSDate date]];
        if (![lblYear.text isEqualToString:@"-"]) {
            year = [lblYear.text intValue];
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
        cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
        long year = [delegate getYear:[NSDate date]];
        if (![lblYear.text isEqualToString:@"-"]) {
            year = [lblYear.text intValue];
        }
        long month = curMonth;
        NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
        for (int i = 0; i < months.count; i++) {
            if ([[months objectAtIndex:i] isEqualToString:lblMonth.text]) {
                month = i + 1;
                break;
            }
        }
        if (year == curYear && month == curMonth) {
            cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + curDay];
        }else {
            cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
        }
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapGesture:)];
        [cellTap setCancelsTouchesInView:NO];
        [cell addGestureRecognizer:cellTap];
        return cell;
    }else if ([tableView isEqual:propView]) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.textLabel setFont:[UIFont systemFontOfSize:12.0f]];
        if ([lblType.text isEqualToString:@"Landed"]) {
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
        lblYear.text = cell.textLabel.text;
        int firstYear = [delegate getYear:[NSDate date]];
        int curYear = [lblYear.text intValue];
        if (curYear == firstYear) {
            NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
            int curMonth = 0;
            for (int i = 0; i < 12; i++) {
                if ([lblMonth.text isEqualToString:[months objectAtIndex:i]]) {
                    curMonth = i;
                    break;
                }
            }
            if (curMonth + 1 <= [delegate getMonth:[NSDate date]]) {
                lblMonth.text = [months objectAtIndex:[delegate getMonth:[NSDate date]] - 1];
                if ([lblDate.text intValue] < [delegate getDay:[NSDate date]]) {
                    lblDate.text = [NSString stringWithFormat:@"%ld",[delegate getDay:[NSDate date]]];
                }
            }
        }
        [yearView setHidden:YES];
        [monthView reloadData];
        [dateView reloadData];
    }else if (!monthView.isHidden) {
        lblMonth.text = cell.textLabel.text;
        int firstYear = [delegate getYear:[NSDate date]];
        int curYear = [lblYear.text intValue];
        if (curYear == firstYear) {
            NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
            int curMonth = 0;
            for (int i = 0; i < 12; i++) {
                if ([lblMonth.text isEqualToString:[months objectAtIndex:i]]) {
                    curMonth = i;
                    break;
                }
            }
            if (curMonth + 1 <= [delegate getMonth:[NSDate date]]) {
                lblMonth.text = [months objectAtIndex:[delegate getMonth:[NSDate date]] - 1];
                if ([lblDate.text intValue] < [delegate getDay:[NSDate date]]) {
                    lblDate.text = [NSString stringWithFormat:@"%ld",[delegate getDay:[NSDate date]]];
                }
            }
        }
        [monthView setHidden:YES];
        [dateView reloadData];
    }else if (!dateView.isHidden) {
        lblDate.text = cell.textLabel.text;
        [dateView setHidden:YES];
    }else if (!propView.isHidden) {
        txtName.text = cell.textLabel.text;
        for (int i = 0; i < propList.count; i++) {
            NSString *compareStr = [[propList objectAtIndex:i] valueForKey:@"name"];
            if ([compareStr isEqualToString:cell.textLabel.text]) {
                txtAddress1.text = [[propList objectAtIndex:i] valueForKey:@"address1"];
                txtAddress2.text = [[propList objectAtIndex:i] valueForKey:@"address2"];
                txtZipcode.text = [[propList objectAtIndex:i] valueForKey:@"zipcode"];
                txtUnit.text = [NSString stringWithFormat:@"%@",[[propList objectAtIndex:i] valueForKey:@"unit"]];
                segType.selectedSegmentIndex = [[[propList objectAtIndex:i] valueForKey:@"type"] intValue] - 1;
                break;
            }
        }
        [propView setHidden:YES];
    }
}

- (IBAction)onNameChanged:(id)sender {
    if ([sender isEqual:txtName]) {
        [propView setFrame:CGRectMake(txtName.frame.origin.x, txtName.frame.origin.y + txtName.frame.size.height, txtName.frame.size.width, 120)];
        UITextField *textField = (UITextField *)sender;
        if (textField.text == nil || [textField.text isEqualToString:@""]) {
            [propView setHidden:YES];
            return;
        }
        for (int i = 0; i < propList.count; i++) {
            NSString *compareStr = [[propList objectAtIndex:i] valueForKey:@"name"];
            if ([compareStr isEqualToString:txtName.text]) {
                txtAddress1.text = [[propList objectAtIndex:i] valueForKey:@"address1"];
                txtAddress2.text = [[propList objectAtIndex:i] valueForKey:@"address2"];
                txtZipcode.text = [[propList objectAtIndex:i] valueForKey:@"zipcode"];
                txtUnit.text = [NSString stringWithFormat:@"%@",[[propList objectAtIndex:i] valueForKey:@"unit"]];
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
        if ([sender isEqual:txtName] && segType.selectedSegmentIndex == 1) {
            [propView setHidden:NO];
            [propView reloadData];
        }
    }
}
@end
