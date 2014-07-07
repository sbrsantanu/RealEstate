//
//  Message.m
//  PushChatStarter
//
//  Created by Kauserali on 28/03/13.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//

#import "Message.h"

static NSString* const SenderNameKey = @"SenderName";
static NSString* const DateKey = @"Date";
static NSString* const TextKey = @"Text";
static NSString* const PropertyIdKey = @"PropertyId";
static NSString* const MessageTypeKey = @"MessageType";
static NSString* const UserTypeKey = @"UserType";
static NSString* const SenderPhotoKey = @"SenderPhoto";
static NSString* const UrlPhotoTypeKey = @"UrlPhotoType";

@implementation Message

- (id)initWithCoder:(NSCoder*)decoder
{
	if ((self = [super init]))
	{
		self.senderName = [decoder decodeObjectForKey:SenderNameKey];
		self.date = [decoder decodeObjectForKey:DateKey];
		self.text = [decoder decodeObjectForKey:TextKey];
        self.propertyId = [decoder decodeObjectForKey:PropertyIdKey];
        self.messageType = [decoder decodeObjectForKey:MessageTypeKey];
        self.userType = [decoder decodeObjectForKey:UserTypeKey];
        self.urlPhotoType = [decoder decodeObjectForKey:UrlPhotoTypeKey];
        self.senderPhoto = [decoder decodeObjectForKey:SenderPhotoKey];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:self.senderName forKey:SenderNameKey];
	[encoder encodeObject:self.date forKey:DateKey];
	[encoder encodeObject:self.text forKey:TextKey];
    [encoder encodeObject:self.propertyId forKey:PropertyIdKey];
	[encoder encodeObject:self.messageType forKey:MessageTypeKey];
	[encoder encodeObject:self.userType forKey:UserTypeKey];
    [encoder encodeObject:self.urlPhotoType forKey:UrlPhotoTypeKey];
	[encoder encodeObject:self.senderPhoto forKey:SenderPhotoKey];
}

- (BOOL)isSentByUser
{
	return self.senderName == nil;
}
@end
