//
//  PropertyFurnish.h
//  RealEstate
//
//  Created by Sol.S on 4/5/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Property;

@interface PropertyFurnish : NSManagedObject

@property (nonatomic, retain) NSNumber * propertyfurnishid;
@property (nonatomic, retain) NSNumber * propertyid;
@property (nonatomic, retain) NSNumber * furnishid;
@property (nonatomic, retain) NSString * furnish_name;
@property (nonatomic, retain) Property *propertyInfo;

@end
