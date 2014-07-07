//
//  AskOwnerViewController.m
//  RealEstate
//
//  Created by Sol.S on 3/10/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import "AskOwnerViewController.h"
#import "AFNetworking.h"
#import "DataModel.h"
#import "MessageTableViewCell.h"
#import "MBProgressHUD.h"

#import "Message.h"
#import "SpeechBubbleView.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "Users.h"

#import "NSString+SBJSON.h"

@interface AskOwnerViewController ()

@end

@implementation AskOwnerViewController

@synthesize currentMessages;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        /*_client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:PushServerApiUrl]];
        _dataModel = [[DataModel alloc] init];
        [_dataModel loadMessages];*/
    }
    return self;
}

- (void)scrollToNewestMessage
{
	// The newest message is at the bottom of the table
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(currentMessages.count - 1) inSection:0];
	[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)setPropertyLabel:(NSString *)string
{
    self.lblPropertyName.text = string;
}

- (IBAction)onSendBtnPressed:(id)sender {
    if (self.txtMessage.text != nil && ![self.txtMessage.text isEqualToString:@""]) {
        [self postMessageRequest];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Q&A" message:@"Please Enter Your Message" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 44)];
        [self.labelView setFrame:CGRectMake(0, 44, bounds.size.width, 40)];
        [self.tableView setFrame:CGRectMake(0,84,bounds.size.width,bounds.size.height - 154)];
        //[self.bottomView setFrame:CGRectMake(0,bounds.size.height - 50,bounds.size.width,50)];
    }else {
        [self.navView setFrame:CGRectMake(0, 0, bounds.size.width, 64)];
        [self.labelView setFrame:CGRectMake(0, 64, bounds.size.width, 40)];
        [self.tableView setFrame:CGRectMake(0,104,bounds.size.width,bounds.size.height - 154)];
        //[self.bottomView setFrame:CGRectMake(0,bounds.size.height - 50,bounds.size.width,50)];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSendBtnPressed:)];
    [singleTap setCancelsTouchesInView:NO];
    [self.viewSend addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.dataModel = delegate.dataModel;
    self.client = delegate.client;
    self.lblPropertyName.text = delegate.pname;
    [self.btnSend setUserInteractionEnabled:YES];
    self.txtMessage.delegate = self;
    [self.dataModel loadMessages];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text == nil || [[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Q&A" message:@"Please Enter Your Message" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return NO;
    }
    [self postMessageRequest];
    return YES;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    CGRect frame = self.bottomView.frame;
    frame.origin.y -= kbSize.height;
    [self.bottomView setFrame:frame];
    [UIView commitAnimations];
        
}

- (void)postMessageRequest
{
    [self.view endEditing:YES];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.labelText = NSLocalizedString(@"Sending", nil);
    
    NSString* text = self.txtMessage.text;
    
    NSDictionary *params = @{@"cmd":@"message",
                             @"user_id":[_dataModel userId],
                             @"message_type":@"Chat",
                             @"user_type":delegate.userType,
                             @"text":text};
    
    self.txtMessage.text = @"";
    Message* message = [[Message alloc] init];
    message.senderName = nil;
    message.urlPhotoType = @"0";
    message.userType = delegate.userType;
    message.propertyId = delegate.pid;
    message.messageType = @"Chat";
    message.date = [NSDate date];
    message.text = text;
    
    NSError *error;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"user_id='%@'",delegate.userid]]];
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    [fetchRequest setEntity:userEntity];
    NSArray *userObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (userObjects.count > 0) {
        Users *userObject = (Users *)[userObjects objectAtIndex:0];
        if (userObject.photo != nil) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
                message.senderPhoto = [userObject.photo base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
            }else {
                message.senderPhoto = [userObject.photo base64Encoding];
            }
        }else {
            message.senderPhoto = @"";
        }
    }else {
        message.senderPhoto = @"";
    }
    
    
    // Add the Message to the data model's list of messages
    [_dataModel addMessage:message];
    [self getCurrentMessages];
    long index = currentMessages.count - 1;
    NSLog(@"%lu",(unsigned long)_dataModel.messages.count);
    
    // Add a row for the Message to ChatViewController's table view.
    // Of course, ComposeViewController doesn't really know that the
    // delegate is the ChatViewController.
    [self didSaveMessage:message atIndex:index];
    NSLog(@"%@",params);
    [_client
     postPath:@"/api.php"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         //[MBProgressHUD hideHUDForView:self.view animated:YES];
         if (operation.response.statusCode != 200) {
             //ShowErrorAlert(NSLocalizedString(@"Could not send the message to the server", nil));
         } else {
             // Create a new Message object
             
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if ([self isViewLoaded]) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             //ShowErrorAlert([error localizedDescription]);
         }
     }];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return currentMessages.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString* CellIdentifier = @"MessageCellIdentifier";
	MessageTableViewCell* cell = (MessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	Message* message = (currentMessages)[indexPath.row];
	[cell setMessage:message];
	return cell;
}

#pragma mark -
#pragma mark UITableView Delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	// This function is called before cellForRowAtIndexPath, once for each cell.
	// We calculate the size of the speech bubble here and then cache it in the
	// Message object, so we don't have to repeat those calculations every time
	// we draw the cell. We add 16px for the label that sits under the bubble.
	Message* message = (currentMessages)[indexPath.row];
	message.bubbleSize = [SpeechBubbleView sizeForText:message.text];
    if (message.bubbleSize.height > 60) {
        return message.bubbleSize.height + 50;
    }else {
        return 110;
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    CGRect frame = self.bottomView.frame;
    frame.origin.y += kbSize.height;
    [self.bottomView setFrame:frame];
    [UIView commitAnimations];
}

- (void)getCurrentMessages
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    currentMessages = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataModel.messages.count; i++) {
        Message *message = (Message *)[self.dataModel.messages objectAtIndex:i];
        if (message.propertyId == nil || [message.propertyId isEqualToString:delegate.pid]) {
            [currentMessages addObject:message];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self getCurrentMessages];
    
	self.title = [_dataModel secretCode];
    
	// Show a label in the table's footer if there are no messages
	if (currentMessages.count == 0)
	{
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
        label.lineBreakMode = NSLineBreakByWordWrapping;
		label.text = NSLocalizedString(@"You have no messages", nil);
		label.font = [UIFont boldSystemFontOfSize:16.0f];
		label.textAlignment = NSTextAlignmentCenter;
		label.textColor = [UIColor colorWithRed:76.0f/255.0f green:86.0f/255.0f blue:108.0f/255.0f alpha:1.0f];
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		self.tableView.tableFooterView = label;
	}
	else
	{
		[self scrollToNewestMessage];
	}
}

#pragma mark -
#pragma mark ComposeDelegate

- (void)didSaveMessage:(Message*)message atIndex:(int)index
{
	// This method is called when the user presses Save in the Compose screen,
	// but also when a push notification is received. We remove the "There are
	// no messages" label from the table view's footer if it is present, and
	// add a new row to the table view with a nice animation.
	if ([self isViewLoaded])
	{
		self.tableView.tableFooterView = nil;
		[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
		[self scrollToNewestMessage];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setOption:(int)opt
{
    option = opt;
}

- (IBAction)onBackBtnPressed:(id)sender {
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:serverActionUrl]];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *params = @{@"task":@"leaveChat",
                             @"deviceToken":[delegate.dataModel deviceToken]};
    [client postPath:@"index.php"
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 if ([self isViewLoaded]) {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     if([operation.response statusCode] != 200) {
                         //ShowErrorAlert(NSLocalizedString(@"There was an error communicating with the server", nil));
                     } else {
                         NSDictionary *dataDict = (NSDictionary *)[operation.responseString JSONValue];
                         if ([[dataDict objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                             
                         }else {
                             
                         }
                         //[self userDidJoin];
                     }
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 if ([self isViewLoaded]) {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     //NSLog(@"%@",[error description]);
                     //ShowErrorAlert([error localizedDescription]);
                 }
             }];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
