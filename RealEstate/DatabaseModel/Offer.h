//
//  Offer.h
//  RealEstate
//
//  Created by Sol.S on 4/5/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OfferTime, Property, Users;

@interface Offer : NSManagedObject

@property (nonatomic, retain) NSNumber * offerid;
@property (nonatomic, retain) NSNumber * userid;
@property (nonatomic, retain) NSNumber * propertyid;
@property (nonatomic, retain) NSNumber * term;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSDate * dateupdated;
@property (nonatomic, retain) NSDate * prefertimestart;
@property (nonatomic, retain) NSString * reason;
@property (nonatomic, retain) NSSet *timeInfo;
@property (nonatomic, retain) Property *propertyInfo;
@property (nonatomic, retain) Users *userInfo;
@end

@interface Offer (CoreDataGeneratedAccessors)

- (void)addTimeInfoObject:(OfferTime *)value;
- (void)removeTimeInfoObject:(OfferTime *)value;
- (void)addTimeInfo:(NSSet *)values;
- (void)removeTimeInfo:(NSSet *)values;

@end
