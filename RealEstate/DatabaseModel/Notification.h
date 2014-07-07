//
//  Notification.h
//  RealEstate
//
//  Created by Sol.S on 5/24/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notification : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * notifyString;
@property (nonatomic, retain) NSDate * datecreated;

@end
