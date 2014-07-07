//
//  PropertyImage.h
//  RealEstate
//
//  Created by Sol.S on 4/6/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Property;

@interface PropertyImage : NSManagedObject

@property (nonatomic, retain) NSNumber * imageid;
@property (nonatomic, retain) NSNumber * propertyid;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSDate * dateupdated;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) Property *propertyInfo;

@end
