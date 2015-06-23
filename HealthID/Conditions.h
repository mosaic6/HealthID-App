//
//  Conditions.h
//  HealthID
//
//  Created by Joshua Walsh on 6/3/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Conditions : NSManagedObject

@property (nonatomic, retain) NSString * status;
@property (nonatomic) NSTimeInterval created_at;
@property (nonatomic) NSTimeInterval deleted_at;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) NSTimeInterval updated_at;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic) NSTimeInterval date_diagnosed;
@property (nonatomic) BOOL is_public;

@end
