//
//  AskOwnerViewController.h
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AFHTTPClient;
@class DataModel;
@class Message;

@interface AskOwnerViewController : UIViewController <UITextFieldDelegate> {
    int option;
}
@property (strong,nonatomic) NSMutableArray *currentMessages;
@property (strong,nonatomic) NSString *imgPath;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *labelView;
@property (strong, nonatomic) IBOutlet UIView *navView;
@property (strong, nonatomic) IBOutlet UILabel *lblPropertyName;
@property (nonatomic, assign) DataModel* dataModel;
@property (nonatomic, assign) AFHTTPClient *client;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *txtMessage;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UIView *viewSend;

@property (strong, nonatomic) UIViewController *prevViewController;

- (void)didSaveMessage:(Message*)message atIndex:(int)index;

- (void)getCurrentMessages;

-(void)setPropertyLabel:(NSString *)string;
- (IBAction)onSendBtnPressed:(id)sender;
- (IBAction)onBackBtnPressed:(id)sender;
- (void)setOption:(int)opt;
@end
