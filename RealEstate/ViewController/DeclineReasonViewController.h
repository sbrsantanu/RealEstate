//
//  DeclineReasonViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/16/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeclineReasonViewController : UIViewController <UITextViewDelegate> {
    UITextView *activeView;
}

@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UILabel *lblPropertyName;
@property (strong, nonatomic) IBOutlet UILabel *lblQuestion;
@property (strong, nonatomic) IBOutlet UITextView *txtAnswer;
@property (strong, nonatomic) IBOutlet UIButton *btnDecline;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)onBackBtnPressed:(id)sender;
- (IBAction)onDeclineBtnPressed:(id)sender;

@end
