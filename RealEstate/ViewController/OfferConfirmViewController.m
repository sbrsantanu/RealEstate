//
//  OfferConfirmViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "OfferConfirmViewController.h"
#import "OfferSuccessViewController.h"

#import "AppDelegate.h"

#import "Constant.h"

#import "MBProgressHUD.h"

#import "NSString+SBJSON.h"

@interface OfferConfirmViewController ()

@end

@implementation OfferConfirmViewController

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
    
    offerSuccessViewController = [[OfferSuccessViewController alloc] init];
    CGRect frm = offerSuccessViewController.view.frame;
    frm.origin.x = 320;
    [offerSuccessViewController.view setFrame:frm];
    [self.view addSubview:offerSuccessViewController.view];
    
    [self.offerView setContentSize:CGSizeMake(320, 464)];
    
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
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    self.view.transform = CGAffineTransformMakeTranslation( 0, 0 );
    [self setEnable:NO];
    
    [UIView commitAnimations];
}

- (IBAction)onConfirmBtnPressed:(id)sender {
    UIColor *selColor = [[UIColor alloc] initWithRed:242 / 255.0 green:70 / 255.0 blue:127 / 255.0 alpha:1.0];
    NSString *curName = @"";
    NSString *prevName = @"";
    NSArray *times = self.timeView.subviews;
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < times.count; i++) {
        if (i % 4 == 0) {
            UILabel *weekLabel = (UILabel *)[times objectAtIndex:i];
            if (![weekLabel.text isEqualToString:@""]) {
                curName = weekLabel.text;
            }
        }else {
            UIButton *timeBtn = (UIButton *)[times objectAtIndex:i];
            if ([timeBtn.backgroundColor isEqual:selColor]) {
                int curWeek = -1;
                if ([curName isEqualToString:@"MONDAY"]) {
                    curWeek = 0;
                }else if ([curName isEqualToString:@"TUESDAY"]) {
                    curWeek = 1;
                }else if ([curName isEqualToString:@"WEDNESDAY"]) {
                    curWeek = 2;
                }else if ([curName isEqualToString:@"THURSDAY"]) {
                    curWeek = 3;
                }else if ([curName isEqualToString:@"FRIDAY"]) {
                    curWeek = 4;
                }else if ([curName isEqualToString:@"SATURDAY"]) {
                    curWeek = 5;
                }else if ([curName isEqualToString:@"SUNDAY"]) {
                    curWeek = 6;
                }
                NSString *timeStr = [timeBtn titleForState:UIControlStateNormal];
                timeStr = [timeStr substringToIndex:[timeStr length] - 3];
                NSDictionary *time = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",curWeek],@"weekday",timeStr,@"time", nil];
                [timeArray addObject:time];
            }
        }
        prevName = curName;
    }
    NSString *offerTimeStr = @"[";
    for (int i = 0; i < timeArray.count; i++) {
        if (i > 0) {
            offerTimeStr = [NSString stringWithFormat:@"%@,",offerTimeStr];
        }
        NSDictionary *timeDict = (NSDictionary *)[timeArray objectAtIndex:i];
        offerTimeStr = [NSString stringWithFormat:@"%@[%@,%@]",offerTimeStr,[timeDict objectForKey:@"weekday"],[timeDict objectForKey:@"time"]];
    }
    offerTimeStr = [NSString stringWithFormat:@"%@]",offerTimeStr];
    if (timeArray.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Offer Error" message:@"Please Select At least One Time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *reqString = [NSString stringWithFormat:@"%@?task=offersave&userid=%@&term=%@&price=%@&propertyid=%@&status=1&time=%@", actionUrl, delegate.userid, delegate.term,delegate.offerPrice,delegate.pid,offerTimeStr];
    NSLog(@"%@",reqString);
    reqString = [reqString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:reqString];
    NSString *strData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    [self performSelector:@selector(doneSaveOfferInfo:) withObject:strData];
}

- (void) doneSaveOfferInfo :(NSString*)data
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSDictionary *dataDict = (NSDictionary*)[data JSONValue];
    if([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        /*[UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        int point = [delegate.quality intValue];
        if (point == 13) {
            [offerSuccessViewController.btnSearchMore setHidden:NO];
        }else {
            [offerSuccessViewController.btnSearchMore setHidden:YES];
        }
        offerSuccessViewController.lblPropertyName.text = self.lblTitle.text;
        offerSuccessViewController.view.transform = CGAffineTransformMakeTranslation( -320, 0 );
        [offerSuccessViewController setEnable:YES];*/
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Home" message:@"Network Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

@end
