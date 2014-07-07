//
//  Postcode.h
//  RealEstate
//
//  Created by Sol.S on 4/5/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class State;

@interface Postcode : NSManagedObject

@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * post_office;
@property (nonatomic, retain) NSString * state_code;
@property (nonatomic, retain) State *stateInfo;

@end
