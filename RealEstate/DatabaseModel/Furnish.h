//
//  Furnish.h
//  RealEstate
//
//  Created by Sol.S on 4/5/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Furnish : NSManagedObject

@property (nonatomic, retain) NSNumber * furnishid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * datecreated;
@property (nonatomic, retain) NSNumber * dateupdated;

@end
