//
//  MetaProperty.h
//  RealEstate
//
//  Created by Sol.S on 4/5/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MetaPropertyFacility;

@interface MetaProperty : NSManagedObject

@property (nonatomic, retain) NSNumber * propertyid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * land_area;
@property (nonatomic, retain) NSNumber * built_up;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSNumber * bedrooms;
@property (nonatomic, retain) NSNumber * bathrooms;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSDate * dateupdated;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * zipcode;
@property (nonatomic, retain) NSSet *facilityInfo;
@end

@interface MetaProperty (CoreDataGeneratedAccessors)

- (void)addFacilityInfoObject:(MetaPropertyFacility *)value;
- (void)removeFacilityInfoObject:(MetaPropertyFacility *)value;
- (void)addFacilityInfo:(NSSet *)values;
- (void)removeFacilityInfo:(NSSet *)values;

@end
