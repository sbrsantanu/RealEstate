//
//  ProfileViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "ProfileViewController.h"

#import "MBProgressHUD.h"
#import "ProfileEditViewController.h"

#import "Constant.h"
#import "Property.h"

#import "Users.h"

#import "NSString+SBJSON.h"

#import "AppDelegate.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    
    CALayer *imageLayer = self.imgPhoto.layer;
    [imageLayer setCornerRadius:30];
    [imageLayer setBorderColor:[[UIColor clearColor] CGColor]];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getProfileInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setEnable:(BOOL)enable
{
    [self.view setUserInteractionEnabled:enable];
}

- (IBAction)onBackBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) getProfileInfo
{
    /*[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
    dispatch_async(myqueue, ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?task=profile&userid=%@", actionUrl,delegate.otheruserid]];
    
        NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
        [self performSelectorOnMainThread:@selector(doneGetProfileInfo:) withObject:strData waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });*/
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Get User Data
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userid!='%@' and propertyid='%@'",delegate.userid, delegate.pid]]];
    NSEntityDescription *propEntity = [NSEntityDescription entityForName:@"Property" inManagedObjectContext:[delegate managedObjectContext]];
    [fetchRequest setEntity:propEntity];
    NSArray *propObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (propObjects.count > 0) {
        Property *propObject = (Property *)[propObjects objectAtIndex:0];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_queue_t myqueue = dispatch_queue_create("queue", NULL);
        dispatch_async(myqueue, ^{
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?task=profile&userid=%@", actionUrl,propObject.userid]];
            
            NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            
            [self performSelectorOnMainThread:@selector(doneGetProfileInfo:) withObject:strData waitUntilDone:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Property" message:@"Failed to Get Landlord's Profile" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (void) doneGetProfileInfo :(NSString*)data
{    
    NSDictionary  *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        NSDictionary *profileInfo = (NSDictionary *)[dataDict objectForKey:@"profile"];
        if (profileInfo.count > 0) {
            _lblName.text = [profileInfo objectForKey:@"name"];
            NSString *phoneNumber = [profileInfo objectForKey:@"phone"];
            if (phoneNumber != nil && phoneNumber.length > 4) {
                phoneNumber = [NSString stringWithFormat:@"%@xxxx",[phoneNumber substringToIndex:phoneNumber.length - 4]];
            }
            _lblPhone.text = phoneNumber;
            if ([[profileInfo objectForKey:@"age"] intValue] > 0) {
                _lblAge.text = [NSString stringWithFormat:@"%d",[[profileInfo objectForKey:@"age"] intValue]];
            }
            _lblNationality.text = [profileInfo objectForKey:@"nationality"];
            _lblRace.text = [profileInfo objectForKey:@"race"];
            _lblOccupation.text = [profileInfo objectForKey:@"occupation"];
            _lblLocation.text = [profileInfo objectForKey:@"location"];
            if (![[profileInfo objectForKey:@"photo"] isEqualToString:@""]) {
                [_imgPhoto setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",profilePhotoUrl, [profileInfo objectForKey:@"photo"]]]];
            }else {
                _imgPhoto.image = [UIImage imageNamed:@"default_user.png"];
            }
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (IBAction)onEditBtnPressed:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.phone == nil || [delegate.phone isEqualToString:@""]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        ProfileEditViewController *profileEditViewController = [[ProfileEditViewController alloc] init];
        [self.navigationController pushViewController:profileEditViewController animated:YES];
    }
}
@end
