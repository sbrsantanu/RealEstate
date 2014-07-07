//
//  OfferSuccessViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "OfferSuccessViewController.h"
#import "PostViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

@interface OfferSuccessViewController ()

@end

@implementation OfferSuccessViewController

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
    [self.mainView setContentSize:CGSizeMake(320, 504)];
    
    CALayer *imageLayer = self.imgGroupPhoto.layer;
    [imageLayer setBorderColor:[[UIColor clearColor] CGColor]];
    [imageLayer setCornerRadius:25];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSearchMoreBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setEnable:(BOOL)enable
{
    [self.view setUserInteractionEnabled:enable];
}

- (IBAction)onBackBtnPressed:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([delegate.postViewController isKindOfClass:[PostViewController class]]) {
        PostViewController *postViewController = (PostViewController *)[delegate postViewController];
        [self.navigationController popToViewController:postViewController animated:YES];
    }else if ([delegate.postViewController isKindOfClass:[HomeViewController class]]) {
        UINavigationController *navController = self.navigationController;
        HomeViewController *postViewController = (HomeViewController *)[delegate postViewController];
        [self.navigationController popToViewController:postViewController animated:YES];
    }
}
@end
