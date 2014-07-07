//
//  Race.h
//  RealEstate
//
//  Created by Sol.S on 4/5/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Race : NSManagedObject

@property (nonatomic, retain) NSNumber * raceid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSDate * dateupdated;

@end