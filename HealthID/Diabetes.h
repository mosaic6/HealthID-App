//
//  Diabetes.h
//  HealthID
//
//  Created by Joshua Walsh on 6/17/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Diabetes : NSManagedObject

@property (nonatomic) int16_t carbs;
@property (nonatomic) NSTimeInterval created_at;
@property (nonatomic) NSTimeInterval deleted_at;
@property (nonatomic) int16_t feeling;
@property (nonatomic) int16_t glucose_level;
@property (nonatomic, retain) NSString * insulin_type;
@property (nonatomic) int16_t insulin_units;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic) int16_t tag;
@property (nonatomic) NSTimeInterval tracked_at;
@property (nonatomic) NSTimeInterval updated_at;

@end
