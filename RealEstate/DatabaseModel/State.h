//
//  State.h
//  RealEstate
//
//  Created by Sol.S on 4/5/14.
//  Copyright (c) 2014 GaoZhuoLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Postcode;

@interface State : NSManagedObject

@property (nonatomic, retain) NSString * state_code;
@property (nonatomic, retain) NSString * state_name;
@property (nonatomic, retain) NSSet *codeInfo;
@end

@interface State (CoreDataGeneratedAccessors)

- (void)addCodeInfoObject:(Postcode *)value;
- (void)removeCodeInfoObject:(Postcode *)value;
- (void)addCodeInfo:(NSSet *)values;
- (void)removeCodeInfo:(NSSet *)values;

@end
