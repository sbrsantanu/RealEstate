//
//  ProfileEditViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "HomeViewController.h"
#import "MenuViewController.h"
#import "PostViewController.h"
#import "OfferListViewController.h"
#import "MyNavigationController.h"
#import "AppointmentViewController.h"
#import "FavoritesViewController.h"
#import "ProfileImproveViewController.h"
#import "PostEditSuccessViewController.h"
#import "OfferViewController.h"

#import "HomeViewController.h"
#import "PostNewViewController.h"

#import "AFNetworking.h"

#import "MBProgressHUD.h"

#import "Users.h"
#import "Nationality.h"
#import "Race.h"

#import "NSString+SBJSON.h"

#import "AppDelegate.h"
#import "Constant.h"

#import "ProfileViewController.h"


@interface ProfileEditViewController ()

@end

@implementation ProfileEditViewController

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
    [self.mainView setContentSize:CGSizeMake(320,460)];
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageGestureCaptured:)];
    [self.imgPhoto addGestureRecognizer:imageTap];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.lblPhone.text = delegate.phone;
    //Year Selection
    yearView = [[UITableView alloc] initWithFrame:CGRectMake(self.viewYear.frame.origin.x, self.viewYear.frame.origin.y + self.viewYear.frame.size.height, self.viewYear.frame.size.width, 120)];
    yearView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    yearView.layer.borderWidth = 1.0f;
    yearView.separatorStyle = UITableViewCellSeparatorStyleNone;
    yearView.backgroundColor = [UIColor whiteColor];
    yearView.delegate = self;
    yearView.dataSource = self;
    [yearView setHidden:YES];
    [self.mainView addSubview:yearView];
    
    //Month Selection
    monthView = [[UITableView alloc] initWithFrame:CGRectMake(self.viewMonth.frame.origin.x, self.viewMonth.frame.origin.y + self.viewMonth.frame.size.height, self.viewMonth.frame.size.width, 120)];
    monthView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    monthView.layer.borderWidth = 1.0f;
    monthView.separatorStyle = UITableViewCellSeparatorStyleNone;
    monthView.backgroundColor = [UIColor whiteColor];
    monthView.delegate = self;
    monthView.dataSource = self;
    [monthView setHidden:YES];
    [self.mainView addSubview:monthView];
    
    //Date Selection
    dateView = [[UITableView alloc] initWithFrame:CGRectMake(self.viewDate.frame.origin.x, self.viewDate.frame.origin.y + self.viewDate.frame.size.height, self.viewDate.frame.size.width, 120)];
    dateView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    dateView.layer.borderWidth = 1.0f;
    dateView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dateView.backgroundColor = [UIColor whiteColor];
    dateView.delegate = self;
    dateView.dataSource = self;
    [dateView setHidden:YES];
    [self.mainView addSubview:dateView];
    
    //Nation
    nationView = [[UITableView alloc] initWithFrame:CGRectMake(self.lblNationality.frame.origin.x, self.lblNationality.frame.origin.y + self.lblNationality.frame.size.height, self.lblNationality.frame.size.width, 120)];
    nationView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    nationView.layer.borderWidth = 1.0f;
    nationView.separatorStyle = UITableViewCellSeparatorStyleNone;
    nationView.backgroundColor = [UIColor whiteColor];
    nationView.delegate = self;
    nationView.dataSource = self;
    [nationView setHidden:YES];
    [self.mainView addSubview:nationView];
    
    //Race
    raceView = [[UITableView alloc] initWithFrame:CGRectMake(self.lblRace.frame.origin.x, self.lblRace.frame.origin.y + self.lblRace.frame.size.height, self.lblRace.frame.size.width, 120)];
    raceView.layer.borderColor = [[UIColor colorWithRed:209 / 255.0 green:211 / 255.0 blue:212 / 255.0 alpha:1.0] CGColor];
    raceView.layer.borderWidth = 1.0f;
    raceView.separatorStyle = UITableViewCellSeparatorStyleNone;
    raceView.backgroundColor = [UIColor whiteColor];
    raceView.delegate = self;
    raceView.dataSource = self;
    [raceView setHidden:YES];
    [self.mainView addSubview:raceView];
    
    self.txtEmail.delegate = self;
    self.txtName.delegate = self;
    self.txtLocation.delegate = self;
    self.txtOccupation.delegate = self;
    
    CALayer *imageLayer = self.imgPhoto.layer;
    [imageLayer setCornerRadius:30];
    [imageLayer setBorderColor:[[UIColor clearColor] CGColor]];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *yearLblTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onYearBtnPressed:)];
    [yearLblTap setCancelsTouchesInView:NO];
    [self.viewYear addGestureRecognizer:yearLblTap];
    
    UITapGestureRecognizer *monthLblTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMonthBtnPressed:)];
    [monthLblTap setCancelsTouchesInView:NO];
    [self.viewMonth addGestureRecognizer:monthLblTap];
    
    UITapGestureRecognizer *dateLblTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDateBtnPressed:)];
    [dateLblTap setCancelsTouchesInView:NO];
    [self.viewDate addGestureRecognizer:dateLblTap];
    
    UITapGestureRecognizer *nationLblTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onNationBtnPressed:)];
    [nationLblTap setCancelsTouchesInView:NO];
    [self.lblNationality addGestureRecognizer:nationLblTap];
    
    UITapGestureRecognizer *raceLblTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRaceBtnPressed:)];
    [raceLblTap setCancelsTouchesInView:NO];
    [self.lblRace addGestureRecognizer:raceLblTap];
    
    point = 0;
    
    if ([self.prevViewController isKindOfClass:[MenuViewController class]]) {
        MenuViewController *menuViewController = (MenuViewController *)self.prevViewController;
        menuViewController.prevViewController = self;
    }
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [self.labelView setFrame:CGRectMake(0,44,bounds.size.width,40)];
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [self.labelView setFrame:CGRectMake(0,64,bounds.size.width,40)];
    }
    [self.mainView setFrame:CGRectMake(0,0,bounds.size.width,bounds.size.height)];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(84, 0, 0, 0);
    self.mainView.contentInset = contentInsets;
    self.mainView.scrollIndicatorInsets = contentInsets;
    self.mainView.contentOffset = CGPointMake(0, -84);
    [self.view bringSubviewToFront:self.labelView];
    [self.view bringSubviewToFront:self.navView];
    
    //post_count = 0;
    
    isChanged = NO;
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.mainView.contentInset = contentInsets;
    self.mainView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    CGPoint tPoint = activeField.frame.origin;
    tPoint.y = tPoint.y - self.mainView.contentOffset.y + self.mainView.frame.origin.y + activeField.frame.size.height;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, tPoint)) {
        [self.mainView setContentOffset:CGPointMake(0.0, self.mainView.contentOffset.y + tPoint.y - aRect.size.height) animated:YES];
    }
    [self.navView setHidden:YES];
    [self.labelView setHidden:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.navView.frame.size.height + self.labelView.frame.size.height, 0.0,0.0, 0.0);
    self.mainView.contentInset = contentInsets;
    self.mainView.scrollIndicatorInsets = contentInsets;
    self.mainView.contentOffset = CGPointMake(0, -self.navView.frame.size.height - self.labelView.frame.size.height);
    [self.navView setHidden:NO];
    [self.labelView setHidden:NO];
}

// Called when the UIKeyboardDidShowNotification is sent.

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [yearView setHidden:YES];
    [monthView setHidden:YES];
    [dateView setHidden:YES];
    [nationView setHidden:YES];
    [raceView setHidden: YES];
    activeField = textField;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    isChanged = YES;
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    //[self hideNavBar:NO];
}

- (IBAction)onNextBtnPressed:(id)sender {
    if ([activeField isEqual:self.txtName]) {
        [self.txtOccupation becomeFirstResponder];
    }else if ([activeField isEqual:self.txtOccupation]) {
        [self.txtLocation becomeFirstResponder];
    }else if ([activeField isEqual:self.txtLocation]) {
        [self.txtEmail becomeFirstResponder];
    }
}

- (void)dismissKeyboard {
    [yearView setHidden:YES];
    [monthView setHidden:YES];
    [dateView setHidden:YES];
    [nationView setHidden:YES];
    [raceView setHidden:YES];
    [self.view endEditing:YES];
    //[self hideNavBar:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getProfileInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0)
        {
            isChanged = NO;
            [self onBackBtnPressed:nil];
        }else if (buttonIndex == 1)
        {
            /*[self.view endEditing:YES];
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if (self.txtName.text == nil || [[self.txtName.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Name must be entered. It's essential." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
                return;
            }
            if (self.txtEmail.text != nil && ![[self.txtEmail.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] && ![delegate emailValidation:self.txtEmail.text]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Invalid Email Address" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
                return;
            }
            if (self.txtOccupation.text != nil && ![[self.txtOccupation.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] && ![delegate validateAlpha:[self.txtOccupation.text stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Invalid Occupation(Must be Alphabets)" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
                return;
            }
            
            if (self.txtLocation.text != nil && ![[self.txtLocation.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] && ![delegate validateAlpha:[self.txtLocation.text stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Invalid Location(Must be Alphabets)" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
                return;
            }
            if (self.lblYear.text != nil && ![self.lblYear.text isEqualToString:@"-"]) {
                NSDate *now = [NSDate date];
                long curYear = [delegate getYear:now];
                if (curYear - [self.lblYear.text integerValue] < 18) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"You couldn't use this app. Because your age is under 18." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alertView show];
                    return;
                }
            }
            NSString *name = self.txtName.text;
            if (name == nil) {
                name = @"";
            }
            int month = 0;
            NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
            for (int i = 0; i < months.count; i++) {
                if ([[months objectAtIndex:i] isEqualToString:self.lblMonth.text]) {
                    month = i + 1;
                    break;
                }
            }
            NSString *birthday = [NSString stringWithFormat:@"%@-%d-%@",self.lblYear.text, month, self.lblDate.text];
            NSString *nationality = self.lblNationality.text;
            NSString *race = self.lblRace.text;
            NSString *occupation = self.txtOccupation.text;
            NSString *location = self.txtLocation.text;
            NSString *email = self.txtEmail.text;
            NSInteger privacy = (self.segPrivacy.selectedSegmentIndex + 1) % 2;
            if (nationality == nil) {
                nationality = @"";
            }
            if (email == nil) {
                email = @"";
            }
            if (race == nil) {
                race = @"";
            }
            if (occupation == nil) {
                occupation = @"";
            }
            if (location == nil) {
                location = @"";
            }
            point = 0;
            NSData *imageData = UIImagePNGRepresentation(self.imgPhoto.image);
            NSData *defaultImageData = UIImagePNGRepresentation([UIImage imageNamed:@"default_user.png"]);
            if (![imageData isEqual:defaultImageData]) {
                point += 5;
            }
            
            if (![email isEqualToString:@""]) {
                point += 2;
            }
            
            if (![name isEqualToString:@""]) {
                point += 2;
            }
            
            if (![self.lblYear.text isEqualToString:@"-"] && ![self.lblMonth.text isEqualToString:@"-"] && ![self.lblDate.text isEqualToString:@"-"]) {
                point++;
            }
            
            if (![nationality isEqualToString:@""]) {
                point++;
            }
            
            if (![race isEqualToString:@""]) {
                point++;
            }
            
            if (![occupation isEqualToString:@""]) {
                point++;
            }
            delegate.afterPoint = point;
            delegate.quality = [NSString stringWithFormat:@"%d",point];
            NSManagedObjectContext *context = delegate.managedObjectContext;
            NSError *error;
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            
            //Get User Data
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"user_id='%@'",delegate.userid]]];
            NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
            [fetchRequest setEntity:userEntity];
            NSArray *userObjects = [context executeFetchRequest:fetchRequest error:&error];
            if (userObjects.count > 0) {
                Users *userObject =(Users *)[userObjects objectAtIndex:0];
                //NSLog(@"%@",userObject.user_id);
                userObject.name = name;
                userObject.phone = delegate.phone;
                userObject.nationality = nationality;
                userObject.race = race;
                userObject.occupation = occupation;
                userObject.location = location;
                userObject.privacy = [NSNumber numberWithInteger:privacy];
                userObject.email = email;
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"YYYY-M-d"];
                userObject.birthday = [dateFormat dateFromString:birthday];
                userObject.quality = [NSNumber numberWithInt:point];
                userObject.photo = UIImagePNGRepresentation(self.imgPhoto.image);
                [delegate saveContext];
                delegate.username = name;
                delegate.quality = [NSString stringWithFormat:@"%d",point];
                NSString *imgString;
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                    imgString = [UIImagePNGRepresentation(self.imgPhoto.image) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
                }else {
                    imgString = [UIImagePNGRepresentation(self.imgPhoto.image) base64Encoding];
                }
                NSDictionary *params = @{@"task":@"profilesave",
                                         @"id":delegate.userid,
                                         @"name":name,
                                         @"birthday":birthday,
                                         @"nationality":nationality,
                                         @"race": race,
                                         @"occupation":occupation,
                                         @"location":location,
                                         @"privacy":[NSString stringWithFormat:@"%d",privacy],
                                         @"email":email,
                                         @"quality":[NSString stringWithFormat:@"%d",point],
                                         @"photo":imgString};
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
                isChanged = NO;
                [self onBackBtnPressed:nil];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"Failed to Save Your Profile" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
                return;
            }*/
            return;
        }
    }
}

- (IBAction)onDoneBtnPressed:(id)sender {
    [self.view endEditing:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.txtName.text == nil || [[self.txtName.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Name must be entered. It's essential." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    if (self.txtEmail.text != nil && ![[self.txtEmail.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] && ![delegate emailValidation:self.txtEmail.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Invalid Email Address" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    if (self.txtOccupation.text != nil && ![[self.txtOccupation.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] && ![delegate validateAlpha:[self.txtOccupation.text stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Invalid Occupation(Must be Alphabets)" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    if (self.txtLocation.text != nil && ![[self.txtLocation.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] && ![delegate validateAlpha:[self.txtLocation.text stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Invalid Location(Must be Alphabets)" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    if (self.lblYear.text != nil && ![self.lblYear.text isEqualToString:@"-"]) {
        NSDate *now = [NSDate date];
        long curYear = [delegate getYear:now];
        if (curYear - [self.lblYear.text integerValue] < 18) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"You couldn't use this app. Because your age is under 18." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
    }
    NSString *name = self.txtName.text;
    if (name == nil) {
        name = @"";
    }
    int month = 0;
    NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    for (int i = 0; i < months.count; i++) {
        if ([[months objectAtIndex:i] isEqualToString:self.lblMonth.text]) {
            month = i + 1;
            break;
        }
    }
    NSString *birthday = [NSString stringWithFormat:@"%@-%d-%@",self.lblYear.text, month, self.lblDate.text];
    NSString *nationality = self.lblNationality.text;
    NSString *race = self.lblRace.text;
    NSString *occupation = self.txtOccupation.text;
    NSString *location = self.txtLocation.text;
    NSString *email = self.txtEmail.text;
    NSInteger privacy = (self.segPrivacy.selectedSegmentIndex + 1) % 2;
    if (nationality == nil) {
        nationality = @"";
    }
    if (email == nil) {
        email = @"";
    }
    if (race == nil) {
        race = @"";
    }
    if (occupation == nil) {
        occupation = @"";
    }
    if (location == nil) {
        location = @"";
    }
    point = 0;
    NSData *imageData = UIImageJPEGRepresentation(self.imgPhoto.image,1);
    NSData *defaultImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"default_user.png"],1);
    if (![imageData isEqual:defaultImageData]) {
        point += 5;
    }
    
    if (![email isEqualToString:@""]) {
        point += 2;
    }
    
    if (![name isEqualToString:@""]) {
        point += 2;
    }
    
    if (![self.lblYear.text isEqualToString:@"-"] && ![self.lblMonth.text isEqualToString:@"-"] && ![self.lblDate.text isEqualToString:@"-"]) {
        point++;
    }
    
    if (![nationality isEqualToString:@""]) {
        point++;
    }
    
    if (![race isEqualToString:@""]) {
        point++;
    }
    
    if (![occupation isEqualToString:@""]) {
        point++;
    }
    delegate.afterPoint = point;
    delegate.quality = [NSString stringWithFormat:@"%d",point];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Get User Data
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"user_id='%@'",delegate.userid]]];
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    [fetchRequest setEntity:userEntity];
    NSArray *userObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (userObjects.count > 0) {
        Users *userObject =(Users *)[userObjects objectAtIndex:0];
        //NSLog(@"%@",userObject.user_id);
        userObject.name = name;
        userObject.phone = delegate.phone;
        userObject.nationality = nationality;
        userObject.race = race;
        userObject.occupation = occupation;
        userObject.location = location;
        userObject.privacy = [NSNumber numberWithInteger:privacy];
        userObject.email = email;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-M-d"];
        userObject.birthday = [dateFormat dateFromString:birthday];
        userObject.quality = [NSNumber numberWithInt:point];
        userObject.photo = UIImageJPEGRepresentation(self.imgPhoto.image,1);
        [delegate saveContext];
        delegate.username = name;
        delegate.quality = [NSString stringWithFormat:@"%d",point];
        NSDictionary *params = @{@"task":@"profilesave",
                                 @"id":delegate.userid,
                                 @"name":name,
                                 @"birthday":birthday,
                                 @"nationality":nationality,
                                 @"race": race,
                                 @"occupation":occupation,
                                 @"location":location,
                                 @"privacy":[NSString stringWithFormat:@"%ld",(long)privacy],
                                 @"email":email,
                                 @"quality":[NSString stringWithFormat:@"%d",point]};
        NSURL *url = [NSURL URLWithString:actionUrl];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/json/index.php" parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            NSData *imgData = UIImageJPEGRepresentation(self.imgPhoto.image,1);
            [formData appendPartWithFileData:imgData name:@"photo" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        }];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        }];
        [httpClient enqueueHTTPRequestOperation:operation];
        
        if (post_count == 0 || delegate.beforePoint >= point) {
            MyNavigationController *navController = (MyNavigationController *)self.navigationController;
            int i = 0;
            for (i = 0; i < navController.viewControllers.count; i++) {
                if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[PostViewController class]]) {
                    [self.navigationController popToViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
                    break;
                }
            }
            if (i == navController.viewControllers.count) {
                PostViewController *postViewController = [[PostViewController alloc] init];
                [self.navigationController pushViewController:postViewController animated:YES];
            }
        }else {
            if ([self.prevViewController isKindOfClass:[PostEditSuccessViewController class]]) {
                ProfileImproveViewController *profileImproveViewController = [[ProfileImproveViewController alloc] init];
                profileImproveViewController.afterViewController = self.prevViewController;
                profileImproveViewController.prevViewController = self;
                [self.navigationController pushViewController:profileImproveViewController animated:YES];
            }else if ([self.prevViewController isKindOfClass:[OfferViewController class]]) {
                MyNavigationController *navController = (MyNavigationController *)self.navigationController;
                int i = 0;
                for (i = 0; i < navController.viewControllers.count; i++) {
                    if ([[navController.viewControllers objectAtIndex:i] isKindOfClass:[HomeViewController class]]) {
                        [self.navigationController popToViewController:[navController.viewControllers objectAtIndex:i] animated:YES];
                        break;
                    }
                }
                if (i == navController.viewControllers.count) {
                    HomeViewController *homeViewController = [[HomeViewController alloc] init];
                    homeViewController.prevViewController = self;
                    [self.navigationController pushViewController:homeViewController animated:YES];
                }
            }else {
                MenuViewController *menuViewController = [[MenuViewController alloc] init];
                menuViewController.prevViewController = self;
                MyNavigationController *n = [[MyNavigationController alloc] initWithRootViewController:menuViewController];
                n.navigationBarHidden = YES;
                [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionLeft withOffset:0 animated:TRUE];
            }
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"Failed to Save Your Profile" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString* data = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.userid = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"id"]];
        delegate.username = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"name"]];
        delegate.quality = [NSString stringWithFormat:@"%d",point];
        if (post_count > 0) {
            ProfileImproveViewController *profileImproveViewController = [[ProfileImproveViewController alloc] init];
            profileImproveViewController.afterViewController = self.prevViewController;
            profileImproveViewController.prevViewController = self;
            [self.navigationController pushViewController:profileImproveViewController animated:YES];
        }else {
            MenuViewController *menuViewController = [[MenuViewController alloc] init];
            menuViewController.prevViewController = self;
            MyNavigationController *n = [[MyNavigationController alloc] initWithRootViewController:menuViewController];
            n.navigationBarHidden = YES;
            [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionLeft withOffset:0 animated:TRUE];
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (IBAction)onBackBtnPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (isChanged) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Are you sure want to leave this screen without saving the current changes?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alertView.tag = 1;
        [alertView show];
        return;
    }
    if ([self.prevViewController isKindOfClass:[MenuViewController class]]) {
        MenuViewController *menuViewController = [[MenuViewController alloc] init];
        menuViewController.prevViewController = self;
        MyNavigationController *n = [[MyNavigationController alloc] initWithRootViewController:menuViewController];
        n.navigationBarHidden = YES;
        [self.revealSideViewController pushViewController:n onDirection:PPRevealSideDirectionLeft withOffset:0 animated:TRUE];
    }else {
        if ([self.prevViewController isKindOfClass:[PostViewController class]]) {
            PostViewController *postViewController = (PostViewController *)self.prevViewController;
            postViewController.prevViewController = self;
        }else if ([self.prevViewController isKindOfClass:[OfferListViewController class]]) {
            OfferListViewController *offerListViewController = (OfferListViewController *)self.prevViewController;
            offerListViewController.prevViewController = self;
        }else if ([self.prevViewController isKindOfClass:[AppointmentViewController class]]) {
            AppointmentViewController *appointmentViewController = (AppointmentViewController *)self.prevViewController;
            appointmentViewController.prevViewController = self;
        }else if ([self.prevViewController isKindOfClass:[FavoritesViewController class]]) {
            FavoritesViewController *favoritesViewController = (FavoritesViewController *)self.prevViewController;
            favoritesViewController.prevViewController = self;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)onSkipBtnPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([self.prevViewController isKindOfClass:[PostViewController class]]) {
        PostViewController *postViewController = (PostViewController *)self.prevViewController;
        postViewController.prevViewController = self;
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([self.prevViewController isKindOfClass:[OfferListViewController class]]) {
        OfferListViewController *offerListViewController = (OfferListViewController *)self.prevViewController;
        offerListViewController.prevViewController = self;
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([self.prevViewController isKindOfClass:[AppointmentViewController class]]) {
        AppointmentViewController *appointmentViewController = (AppointmentViewController *)self.prevViewController;
        appointmentViewController.prevViewController = self;
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([self.prevViewController isKindOfClass:[FavoritesViewController class]]) {
        FavoritesViewController *favoritesViewController = (FavoritesViewController *)self.prevViewController;
        favoritesViewController.prevViewController = self;
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([self.prevViewController isKindOfClass:[MenuViewController class]]) {
        [self.revealSideViewController popViewControllerAnimated:YES];
    }
}

- (void) setEnable:(BOOL)enable
{
    [self.view setUserInteractionEnabled:enable];
}

- (IBAction)onYearBtnPressed:(id)sender {
    if ([yearView isHidden]) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        int firstYear = 1900;
        long curYear;
        if ([self.lblYear.text isEqualToString:@"-"]) {
            curYear = firstYear;
        }else {
            curYear = [self.lblYear.text intValue];
        }
        if (curYear > [delegate getYear:[NSDate date]] - 7) {
            curYear = [delegate getYear:[NSDate date]] - 6;
        }
        [yearView setContentOffset:CGPointMake(0,(curYear - firstYear) * 20)];
        [yearView setHidden:NO];
        [nationView setHidden:YES];
        [raceView setHidden:YES];
        [monthView setHidden:YES];
        [dateView setHidden:YES];
        [self.view endEditing:YES];
        //[self hideNavBar:YES];
    }else {
        [yearView setHidden:YES];
        //[self hideNavBar:NO];
    }
}

- (IBAction)onMonthBtnPressed:(id)sender {
    if ([monthView isHidden]) {
        NSString *curMonthStr = self.lblMonth.text;
        int curMonth = 0;
        NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
        for (int i = 0; i < 12; i++) {
            if ([[months objectAtIndex:i] isEqualToString:curMonthStr]) {
                curMonth = i;
                break;
            }
        }
        if (curMonth > 5) {
            curMonth = 6;
        }
        [monthView setContentOffset:CGPointMake(0,curMonth * 20)];
        [monthView setHidden:NO];
        [nationView setHidden:YES];
        [yearView setHidden:YES];
        [raceView setHidden:YES];
        [dateView setHidden:YES];
        [self.view endEditing:YES];
        //[self hideNavBar:YES];
    }else {
        [monthView setHidden:YES];
        //[self hideNavBar:NO];
    }
}

- (IBAction)onDateBtnPressed:(id)sender {
    if ([dateView isHidden]) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        int curDate;
        if ([self.lblDate.text isEqualToString:@"-"]) {
            curDate = 1;
        }else {
            curDate = [self.lblDate.text intValue];
        }
        if (curDate > [delegate getMaxDate:[self.lblYear.text intValue] month:[self.lblMonth.text intValue]] - 6) {
            curDate = [delegate getMaxDate:[self.lblYear.text intValue] month:[self.lblMonth.text intValue]] - 5;
        }
        [dateView setContentOffset:CGPointMake(0,(curDate - 1) * 20)];
        [dateView setHidden:NO];
        [nationView setHidden:YES];
        [yearView setHidden:YES];
        [monthView setHidden:YES];
        [raceView setHidden:YES];
        [self.view endEditing:YES];
        //[self hideNavBar:YES];
    }else {
        [dateView setHidden:YES];
        //[self hideNavBar:NO];
    }
}

- (IBAction)onNationBtnPressed:(id)sender {
    if ([nationView isHidden]) {
        if (nationList.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"No nationality datas found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        if (nationView.contentSize.height > 120) {
            for (int i = 0; i < nationList.count; i++) {
                if ([[nationList objectAtIndex:i] isEqualToString: self.lblNationality.text]) {
                    [nationView setContentOffset:CGPointMake(0, i * 20)];
                    break;
                }
            }
        }
        [self.view endEditing:YES];
        [nationView setHidden:NO];
        [raceView setHidden:YES];
        [yearView setHidden:YES];
        [monthView setHidden:YES];
        [dateView setHidden:YES];
        //[self hideNavBar:YES];
    }else {
        [nationView setHidden:YES];
        //[self hideNavBar:NO];
    }
}

- (IBAction)onRaceBtnPressed:(id)sender {
    if ([raceView isHidden]) {
        if (nationList.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"No race datas found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        if (raceView.contentSize.height > 120) {
            for (int i = 0; i < raceList.count; i++) {
                if ([[raceList objectAtIndex:i] isEqualToString: self.lblRace.text]) {
                    [raceView setContentOffset:CGPointMake(0, i * 20)];
                    break;
                }
            }
        }
        [self.view endEditing:YES];
        [raceView setHidden:NO];
        [nationView setHidden:YES];
        [yearView setHidden:YES];
        [monthView setHidden:YES];
        [dateView setHidden:YES];
        //[self hideNavBar:YES];
    }else {
        [raceView setHidden:YES];
        //[self hideNavBar:NO];
    }
}

- (IBAction)onLibraryBtnPressed:(id)sender {
    [photoPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)onTakeBtnPressed:(id)sender {
    [photoPicker takePicture];
}

- (IBAction)onCameraBackBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onPrivacyChanged:(id)sender {
    isChanged = YES;
}

- (void)hideNavBar:(BOOL)hidden
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    CGRect frame = self.mainView.frame;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if (hidden) {
        frame.origin.y = 0;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            frame.size.height = bounds.size.height - 20;
        }else {
            frame.size.height = bounds.size.height;
        }
    }else {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            frame.origin.y = self.navView.frame.size.height + self.labelView.frame.size.height - 20;
        }else {
            frame.origin.y = self.navView.frame.size.height + self.labelView.frame.size.height;
        }
        frame.size.height = bounds.size.height - self.labelView.frame.size.height - self.navView.frame.size.height;
    }
    [self.mainView setFrame:frame];
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeField = textField;
    [dateView setHidden:YES];
    [yearView setHidden:YES];
    [monthView setHidden:YES];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    if ([textField isEqual:self.txtEmail]) {
        [keyboardToolBar setItems: [NSArray arrayWithObjects:
            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
            [[UIBarButtonItem alloc]initWithTitle:@"Go" style:UIBarButtonItemStyleDone target:self action:@selector(onDoneBtnPressed:)],
        nil]];
    }else {
        [keyboardToolBar setItems: [NSArray arrayWithObjects:
            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
            [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(onNextBtnPressed:)],
            [[UIBarButtonItem alloc]initWithTitle:@"Go" style:UIBarButtonItemStyleDone target:self action:@selector(onDoneBtnPressed:)],
        nil]];
    }
    textField.inputAccessoryView = keyboardToolBar;
    //[self hideNavBar:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) refreshDate
{
    NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    int curYear = [self.lblYear.text intValue];
    int curMonth = 0;
    NSString *curMonthStr = self.lblMonth.text;
    for (int i = 0; i < months.count; i++) {
        if ([[months objectAtIndex:i] isEqualToString:curMonthStr]) {
            curMonth = i + 1;
            break;
        }
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    int maxDate = [delegate getMaxDate:curYear month:curMonth];
    if (maxDate == dateView.subviews.count) {
        self.lblDate.text = @"1";
        return;
    }
    NSArray *viewsToRemove = [dateView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    [dateView setContentSize:CGSizeMake(self.viewDate.frame.size.width, 20 * maxDate)];
    for (int i = 0; i < maxDate; i++) {
        NSString *dateStr = [NSString stringWithFormat:@"%d", i + 1];
        UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(5,i * 20,self.viewDate.frame.size.width - 5,20)];
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

- (void)yearGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UILabel *sender = (UILabel *)gesture.view;
    NSString *prevYear = self.lblYear.text;
    self.lblYear.text = [NSString stringWithFormat:@"%@",sender.text];
    if (![self.lblYear.text isEqualToString:prevYear]) {
        [self refreshDate];
    }
    [yearView setHidden:YES];
    //[self hideNavBar:NO];
}

- (void)imageGestureCaptured:(UITapGestureRecognizer *)gesture
{
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
    photoPicker.cameraOverlayView = cameraOverlayView;
    photoPicker.delegate = self;
    [photoPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [self presentViewController:photoPicker animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (void)monthGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UILabel *sender = (UILabel *)gesture.view;
    NSString *prevMonth = self.lblMonth.text;
    self.lblMonth.text = [NSString stringWithFormat:@"%@",sender.text];
    if (![self.lblMonth.text isEqualToString:prevMonth]) {
        [self refreshDate];
    }
    [monthView setHidden:YES];
    //[self hideNavBar:NO];
}

- (void)nationGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UILabel *sender = (UILabel *)gesture.view;
    self.lblNationality.text = [NSString stringWithFormat:@"%@",sender.text];
    [nationView setHidden:YES];
    //[self hideNavBar:NO];
}

- (void)raceGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UILabel *sender = (UILabel *)gesture.view;
    self.lblRace.text = [NSString stringWithFormat:@"%@",sender.text];
    [raceView setHidden:YES];
    //[self hideNavBar:NO];
}

- (void)dateGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UILabel *sender = (UILabel *)gesture.view;
    self.lblDate.text = [NSString stringWithFormat:@"%@",sender.text];
    [dateView setHidden:YES];
    //[self hideNavBar:NO];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([info objectForKey:@"UIImagePickerControllerEditedImage"] != nil) {
        [self.imgPhoto setImage:(UIImage *)[info objectForKey:@"UIImagePickerControllerEditedImage"]];
    }else if ([info objectForKey:@"UIImagePickerControllerOriginalImage"] != nil) {
        [self.imgPhoto setImage:(UIImage *)[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) getProfileInfo
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Get Property Data
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"user_id='%@'",delegate.userid]]];
    
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    [fetchRequest setEntity:userEntity];
    NSArray *userObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    if (userObjects.count > 0) {
        Users *userObject = (Users *)[userObjects objectAtIndex:0];
        point = [userObject.quality intValue];
        delegate.quality = [NSString stringWithFormat:@"%d",point];
        delegate.beforePoint = point;
        post_count = (int)userObject.propertyInfo.count;
        offer_count = (int)userObject.offerInfo.count;
        _txtName.text = userObject.name;
        _lblPhone.text = userObject.phone;
        _lblNationality.text = userObject.nationality;
        _lblRace.text = userObject.race;
        _txtOccupation.text = userObject.occupation;
        _txtLocation.text = userObject.location;
        if (userObject.photo != nil) {
            //[_imgPhoto setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",profilePhotoUrl, [profileInfo objectForKey:@"photo"]]]];
            [_imgPhoto setImage:[UIImage imageWithData:userObject.photo]];
        }else {
            _imgPhoto.image = [UIImage imageNamed:@"default_user.png"];
        }
        _txtEmail.text = userObject.email;
        _segPrivacy.selectedSegmentIndex = ([userObject.privacy intValue] + 1) % 2;
        if (userObject.birthday != nil) {
            //NSLog(@"%@",userObject.birthday);
            _lblYear.text = [NSString stringWithFormat:@"%ld",[delegate getYear:userObject.birthday]];
            _lblMonth.text = months[[delegate getMonth:userObject.birthday] - 1];
            _lblDate.text = [NSString stringWithFormat:@"%ld",[delegate getDay:userObject.birthday]];
        }
        
    }
    //Get Nationality Data
    [fetchRequest setPredicate:nil];
    NSEntityDescription *nationEntity = [NSEntityDescription entityForName:@"Nationality" inManagedObjectContext:context];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
    [fetchRequest setEntity:nationEntity];
    NSArray *nationObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    nationList = [[NSMutableArray alloc] init];
    
    for (Nationality *nationInfo in nationObjects) {
        [nationList addObject:nationInfo.name];
    }
    [nationView reloadData];
    
    //Get Race Data
    NSEntityDescription *raceEntity = [NSEntityDescription entityForName:@"Race" inManagedObjectContext:context];
    [fetchRequest setEntity:raceEntity];
    NSArray *raceObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    raceList = [[NSMutableArray alloc] init];
    
    for (Race *raceInfo in raceObjects) {
        [raceList addObject:raceInfo.name];
    }
    [raceView reloadData];
}

- (void) doneGetProfileInfo :(NSString*)data
{
    NSDictionary  *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        NSDictionary *profileInfo = (NSDictionary *)[dataDict objectForKey:@"profile"];
        NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
        
        if (profileInfo.count > 0) {
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            point = [[profileInfo objectForKey:@"quality"] intValue];
            delegate.quality = [NSString stringWithFormat:@"%d",point];
            delegate.beforePoint = point;
            //post_count = [[profileInfo objectForKey:@"post_count"] intValue];
            _txtName.text = [profileInfo objectForKey:@"name"];
            _lblPhone.text = [profileInfo objectForKey:@"phone"];
            _lblNationality.text = [profileInfo objectForKey:@"nationality"];
            _lblRace.text = [profileInfo objectForKey:@"race"];
            _txtOccupation.text = [profileInfo objectForKey:@"occupation"];
            _txtLocation.text = [profileInfo objectForKey:@"location"];
            if (![[profileInfo objectForKey:@"photo"] isEqualToString:@""]) {
                [_imgPhoto setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",profilePhotoUrl, [profileInfo objectForKey:@"photo"]]]];
            }else {
                _imgPhoto.image = [UIImage imageNamed:@"default_user.png"];
            }
            _txtEmail.text = [profileInfo objectForKey:@"email"];
            _segPrivacy.selectedSegmentIndex = ([[profileInfo objectForKey:@"privacy"] intValue] + 1) % 2;
            NSString *birthday_str = [profileInfo objectForKey:@"birthday"];
            if (![birthday_str isEqualToString:@"0000-00-00"]) {
                _lblYear.text = [birthday_str substringWithRange:NSMakeRange(0,4)];
                _lblMonth.text = months[[[birthday_str substringWithRange:NSMakeRange(5,2)] intValue] - 1];
                _lblDate.text = [birthday_str substringWithRange:NSMakeRange(8,2)];
            }
            
        }
        nationList = (NSMutableArray *)[dataDict objectForKey:@"nationality"];
        raceList = (NSMutableArray *)[dataDict objectForKey:@"race"];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([tableView isEqual:yearView]) {
        NSDate *curDate = [NSDate date];
        long curYear = [delegate getYear:curDate];
        return curYear - 1900;
    }else if ([tableView isEqual:monthView]) {
        return 12;
    }else if ([tableView isEqual:dateView]) {
        NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
        int curYear = [self.lblYear.text intValue];
        int curMonth = 0;
        NSString *curMonthStr = self.lblMonth.text;
        for (int i = 0; i < months.count; i++) {
            if ([[months objectAtIndex:i] isEqualToString:curMonthStr]) {
                curMonth = i + 1;
                break;
            }
        }
        if ([self.lblDate.text intValue] > [delegate getMaxDate:curYear month:curMonth]) {
            self.lblDate.text = @"1";
        }
        return [delegate getMaxDate:curYear month:curMonth];
    }else if ([tableView isEqual:nationView]) {
        return [nationList count];
    }else if ([tableView isEqual:raceView]) {
        return [raceList count];
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
    }else if ([tableView isEqual:nationView]) {
        return 20.0f;
    }else if ([tableView isEqual:raceView]) {
        return 20.0f;
    }else {
        return 0.0f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:yearView]) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.textLabel setFont:[UIFont systemFontOfSize:10.0f]];
        cell.textLabel.text = [NSString stringWithFormat:@"%d", 1900 + indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapGesture:)];
        [cellTap setCancelsTouchesInView:NO];
        [cell addGestureRecognizer:cellTap];
        return cell;
    }else if ([tableView isEqual:monthView]) {
        NSArray *months = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.textLabel setFont:[UIFont systemFontOfSize:10.0f]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [months objectAtIndex:indexPath.row]];
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapGesture:)];
        [cellTap setCancelsTouchesInView:NO];
        [cell addGestureRecognizer:cellTap];
        return cell;
    }else if ([tableView isEqual:dateView]) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.textLabel setFont:[UIFont systemFontOfSize:10.0f]];
        cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapGesture:)];
        [cellTap setCancelsTouchesInView:NO];
        [cell addGestureRecognizer:cellTap];
        return cell;
    }else if ([tableView isEqual:nationView]) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.textLabel setFont:[UIFont systemFontOfSize:10.0f]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [nationList objectAtIndex:indexPath.row]];
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapGesture:)];
        [cellTap setCancelsTouchesInView:NO];
        [cell addGestureRecognizer:cellTap];
        return cell;
    }else if ([tableView isEqual:raceView]) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.textLabel setFont:[UIFont systemFontOfSize:10.0f]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [raceList objectAtIndex:indexPath.row]];
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
    isChanged = YES;
    UITableViewCell *cell = (UITableViewCell *)gesture.view;
    if (!yearView.isHidden) {
        self.lblYear.text = cell.textLabel.text;
        [yearView setHidden:YES];
        [dateView reloadData];
        //[self hideNavBar:NO];
    }else if (!monthView.isHidden) {
        self.lblMonth.text = cell.textLabel.text;
        [monthView setHidden:YES];
        [dateView reloadData];
        //[self hideNavBar:NO];
    }else if (!dateView.isHidden) {
        self.lblDate.text = cell.textLabel.text;
        [dateView setHidden:YES];
        //[self hideNavBar:NO];
    }else if (!nationView.isHidden) {
        self.lblNationality.text = cell.textLabel.text;
        [nationView setHidden:YES];
        //[self hideNavBar:NO];
    }else if (!raceView.isHidden) {
        self.lblRace.text = cell.textLabel.text;
        [raceView setHidden:YES];
        //[self hideNavBar:NO];
    }
}
/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:yearView]) {
        self.lblYear.text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [yearView setHidden:YES];
    }else if ([tableView isEqual:monthView]) {
        self.lblMonth.text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [monthView setHidden:YES];
    }else if ([tableView isEqual:dateView]) {
        self.lblDate.text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [dateView setHidden:YES];
    }else if ([tableView isEqual:nationView]) {
        self.lblNationality.text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [nationView setHidden:YES];
    }else if ([tableView isEqual:raceView]) {
        self.lblRace.text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [raceView setHidden:YES];
    }
}*/

@end
