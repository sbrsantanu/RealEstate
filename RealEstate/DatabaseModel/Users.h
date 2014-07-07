//
//  Users.h
//  RealEstate
//
//  Created by Sol.S on 4/5/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Favorites, Property, Offer;

@interface Users : NSManagedObject

@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * nationality;
@property (nonatomic, retain) NSString * race;
@property (nonatomic, retain) NSString * occupation;
@property (nonatomic, retain) NSString * ip_address;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSNumber * quality;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSDate * dateupdated;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * privacy;
@property (nonatomic, retain) NSString * device_token;
@property (nonatomic, retain) NSString * deviceToken;
@property (nonatomic, retain) NSSet *propertyInfo;
@property (nonatomic, retain) NSSet *offerInfo;
@property (nonatomic, retain) NSSet *favoritesInfo;
@end

@interface Users (CoreDataGeneratedAccessors)

- (void)addPropertyInfoObject:(Property *)value;
- (void)removePropertyInfoObject:(Property *)value;
- (void)addPropertyInfo:(NSSet *)values;
- (void)removePropertyInfo:(NSSet *)values;

- (void)addOfferInfoObject:(Offer *)value;
- (void)removeOfferInfoObject:(Offer *)value;
- (void)addOfferInfo:(NSSet *)values;
- (void)removeOfferInfo:(NSSet *)values;

- (void)addFavoritesInfoObject:(Property *)value;
- (void)removeFavoritesInfoObject:(Property *)value;
- (void)addFavoritesInfo:(NSSet *)values;
- (void)removeFavoritesInfo:(NSSet *)values;

@end
