//
//  MessageTableViewCell.m
//  PushChatStarter
//
//  Created by Kauserali on 28/03/13.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "Message.h"
#import "SpeechBubbleView.h"
#import "AsyncImageView.h"
#import "Constant.h"

#import "NSData+Base64.h"

static UIColor* ownerColor = nil;
static UIColor* userColor = nil;

@interface MessageTableViewCell() {
    SpeechBubbleView *_bubbleView;
    AsyncImageView *imgPhoto;
    UIImageView *imgThumb;
	UILabel *_label;
    UILabel *lblName;
}
@end

@implementation MessageTableViewCell

+ (void)initialize
{
	if (self == [MessageTableViewCell class])
	{
		userColor = [UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0];
        ownerColor = [UIColor colorWithRed:212 / 255.0 green:228 / 255.0 blue:152 / 255.0 alpha:1.0];
	}
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgPhoto = [[AsyncImageView alloc] initWithFrame:CGRectMake(10,10,50,50)];
        imgPhoto.layer.cornerRadius = 25.0f;
        imgPhoto.clipsToBounds = YES;
        [self.contentView addSubview:imgPhoto];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, 60,70, 30)];
        lblName.textAlignment = NSTextAlignmentCenter;
        lblName.numberOfLines = 2;
        [self.contentView addSubview:lblName];
        
        imgThumb = [[UIImageView alloc] initWithFrame:CGRectMake(68,20,12,12)];
        [self.contentView addSubview:imgThumb];
        
		// Create the speech bubble view
		_bubbleView = [[SpeechBubbleView alloc] initWithFrame:CGRectZero];
		_bubbleView.backgroundColor = userColor;
		_bubbleView.opaque = YES;
		_bubbleView.clearsContextBeforeDrawing = NO;
		_bubbleView.contentMode = UIViewContentModeRedraw;
		_bubbleView.autoresizingMask = 0;
        _bubbleView.layer.cornerRadius = 2.0f;
        _bubbleView.clipsToBounds = YES;
		[self.contentView addSubview:_bubbleView];
	}
	return self;
}

- (void)layoutSubviews
{
	// This is a little trick to set the background color of a table view cell.
	[super layoutSubviews];
	self.backgroundColor = [UIColor clearColor];
}

- (void)setMessage:(Message*)message
{
	CGPoint point = CGPointMake(80,10);

	// We display messages that are sent by the user on the right-hand side of
	// the screen. Incoming messages are displayed on the left-hand side.
	NSString* senderName;
	BubbleType bubbleType;
	if ([message isSentByUser])
	{
		bubbleType = BubbleTypeLefthand;
		senderName = NSLocalizedString(@"You", nil);
		_label.textAlignment = NSTextAlignmentLeft;
        if (message.senderPhoto != nil && ![message.senderPhoto isEqualToString:@""]) {
            NSData *imgData = [NSData dataFromBase64String:message.senderPhoto];
            [imgPhoto setImage:[UIImage imageWithData:imgData]];
        }else {
            [imgPhoto setImage:[UIImage imageNamed:@"default_user.png"]];
        }
        if ([message.userType isEqualToString:@"2"]) {
            [imgThumb setImage:[UIImage imageNamed:@"BubbleArrow2.png"]];
            [_bubbleView setBackgroundColor:ownerColor];
        }else {
            [imgThumb setImage:[UIImage imageNamed:@"BubbleArrow1.png"]];
        }
	}
	else
	{
        if (message.senderPhoto != nil && ![message.senderPhoto isEqualToString:@""]) {
            if ([message.urlPhotoType isEqualToString:@"1"]) {
                [imgPhoto setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",profilePhotoUrl, message.senderPhoto]]];
            }else {
                NSData *imgData = [NSData dataFromBase64String:message.senderPhoto];
                [imgPhoto setImage:[UIImage imageWithData:imgData]];
            }
        }else {
            [imgPhoto setImage:[UIImage imageNamed:@"default_user.png"]];
        }
        if ([message.userType isEqualToString:@"1"]) {
            bubbleType = BubbleTypeLefthand;
            senderName = message.senderName;
            _label.textAlignment = NSTextAlignmentLeft;
            [_bubbleView setBackgroundColor:userColor];
            [imgThumb setImage:[UIImage imageNamed:@"BubbleArrow1.png"]];
        }else {
            bubbleType = BubbleTypeLefthand;
            senderName = @"Owner";
            [_bubbleView setBackgroundColor:ownerColor];
            [imgThumb setImage:[UIImage imageNamed:@"BubbleArrow2.png"]];
        }
	}

	// Resize the bubble view and tell it to display the message text
	CGRect rect;
    CGRect bounds = [[UIScreen mainScreen] bounds];
	rect.origin = point;
	rect.size = message.bubbleSize;
    rect.size.width = bounds.size.width - 90;
	_bubbleView.frame = rect;
	[_bubbleView setText:message.text bubbleType:bubbleType];
    
    lblName.text = senderName;
}

@end
