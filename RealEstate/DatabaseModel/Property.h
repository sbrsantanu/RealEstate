//
//  Property.h
//  RealEstate
//
//  Created by Sol.S on 4/6/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Favorites, PropertyFacility, PropertyFurnish, PropertyImage, Users, Offer;

@interface Property : NSManagedObject

@property (nonatomic, retain) NSNumber * propertyid;
@property (nonatomic, retain) NSNumber * userid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSNumber * quality;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * rooms;
@property (nonatomic, retain) NSNumber * toilets;
@property (nonatomic, retain) NSNumber * sqft;
@property (nonatomic, retain) NSNumber * parkings;
@property (nonatomic, retain) NSString * disPrice;
@property (nonatomic, retain) NSDate * availability;
@property (nonatomic, retain) NSDate * prefertimestart;
@property (nonatomic, retain) NSString * rental;
@property (nonatomic, retain) NSNumber * furnish_type;
@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * zipcode;
@property (nonatomic, retain) NSString * describe;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSDate * dateupdated;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * nationality;
@property (nonatomic, retain) NSString * race;
@property (nonatomic, retain) Users *userInfo;
@property (nonatomic, retain) NSSet *imgInfo;
@property (nonatomic, retain) NSSet *facilityInfo;
@property (nonatomic, retain) NSSet *furnishInfo;
@property (nonatomic, retain) NSSet *favoritesInfo;
@property (nonatomic, retain) NSSet *offerInfo;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *userphoto;
@property (nonatomic, retain) NSNumber *userprivacy;
@end

@interface Property (CoreDataGeneratedAccessors)


- (void)addImgInfoObject:(PropertyImage *)value;
- (void)removeImgInfoObject:(PropertyImage *)value;
- (void)addImgInfo:(NSSet *)values;
- (void)removeImgInfo:(NSSet *)values;

- (void)addFacilityInfoObject:(PropertyFacility *)value;
- (void)removeFacilityInfoObject:(PropertyFacility *)value;
- (void)addFacilityInfo:(NSSet *)values;
- (void)removeFacilityInfo:(NSSet *)values;

- (void)addFurnishInfoObject:(PropertyFurnish *)value;
- (void)removeFurnishInfoObject:(PropertyFurnish *)value;
- (void)addFurnishInfo:(NSSet *)values;
- (void)removeFurnishInfo:(NSSet *)values;

- (void)addFavoritesInfoObject:(Favorites *)value;
- (void)removeFavoritesInfoObject:(Favorites *)value;
- (void)addFavoritesInfo:(NSSet *)values;
- (void)removeFavoritesInfo:(NSSet *)values;

- (void)addOfferInfoObject:(Offer *)value;
- (void)removeOfferInfoObject:(Offer *)value;
- (void)addOfferInfo:(NSSet *)values;
- (void)removeOfferInfo:(NSSet *)values;

@end
