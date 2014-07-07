//
//  PropertyFacility.h
//  RealEstate
//
//  Created by Sol.S on 4/5/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Property;

@interface PropertyFacility : NSManagedObject

@property (nonatomic, retain) NSNumber * propertyfacilityid;
@property (nonatomic, retain) NSNumber * propertyid;
@property (nonatomic, retain) NSNumber * facilityid;
@property (nonatomic, retain) NSString * facility_name;
@property (nonatomic, retain) Property *propertyInfo;

@end
