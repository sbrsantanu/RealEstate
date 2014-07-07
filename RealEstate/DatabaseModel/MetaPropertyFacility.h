//
//  MetaPropertyFacility.h
//  RealEstate
//
//  Created by Sol.S on 4/5/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MetaProperty;

@interface MetaPropertyFacility : NSManagedObject

@property (nonatomic, retain) NSNumber * facilityid;
@property (nonatomic, retain) NSNumber * propertyid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSDate * dateupdated;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) MetaProperty *propertyInfo;

@end
