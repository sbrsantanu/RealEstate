//
//  OfferTime.h
//  RealEstate
//
//  Created by Sol.S on 4/5/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Offer;

@interface OfferTime : NSManagedObject

@property (nonatomic, retain) NSNumber * timeid;
@property (nonatomic, retain) NSNumber * offerid;
@property (nonatomic, retain) NSNumber * weekday;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) Offer *offerInfo;

@end
