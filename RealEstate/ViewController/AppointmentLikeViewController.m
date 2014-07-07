//
//  AppointmentLikeViewController.m
//  RealEstate
//
//  Created by Sol.S on 4/14/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "AppointmentLikeViewController.h"
#import "RateViewController.h"

@interface AppointmentLikeViewController ()

@end

@implementation AppointmentLikeViewController

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
    self.btnAgree.layer.cornerRadius = 15.0f;
    self.btnDisagree.layer.cornerRadius = 15.0f;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [self.scrollView setFrame:CGRectMake(0,44,bounds.size.width,bounds.size.height - 64)];
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [self.scrollView setFrame:CGRectMake(0,64,bounds.size.width,bounds.size.height - 64)];
    }
    [self.scrollView setContentSize:CGSizeMake(bounds.size.width,504)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAgreeBtnPressed:(id)sender {
    RateViewController *rateViewController = [[RateViewController alloc] init];
    [self.navigationController pushViewController:rateViewController animated:YES];
}

- (IBAction)onDisagreeBtnPressed:(id)sender {
}
@end
