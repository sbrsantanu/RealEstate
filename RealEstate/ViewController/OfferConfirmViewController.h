//
//  OfferConfirmViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OfferSuccessViewController;

@interface OfferConfirmViewController : UIViewController {
    OfferSuccessViewController *offerSuccessViewController;
}

@property (strong, nonatomic) IBOutlet UILabel *lblOffer;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIView *timeView;
@property (strong, nonatomic) IBOutlet UIScrollView *offerView;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;

- (void) setEnable:(BOOL)enable;
- (IBAction)onBackBtnPressed:(id)sender;
- (IBAction)onConfirmBtnPressed:(id)sender;

@end
