//
//  Favorites.h
//  RealEstate
//
//  Created by Sol.S on 4/5/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Property, Users;

@interface Favorites : NSManagedObject

@property (nonatomic, retain) NSNumber * favoritesid;
@property (nonatomic, retain) NSNumber * userid;
@property (nonatomic, retain) NSNumber * propertyid;
@property (nonatomic, retain) Property *propertyInfo;
@property (nonatomic, retain) Users *userInfo;

@end
