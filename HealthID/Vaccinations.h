//
//  Vaccinations.h
//  HealthID
//
//  Created by Joshua Walsh on 6/4/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Vaccinations : NSManagedObject

@property (nonatomic) NSTimeInterval completed_on;
@property (nonatomic) NSTimeInterval created_at;
@property (nonatomic) NSTimeInterval deleted_at;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic) NSTimeInterval updated_at;
@property (nonatomic) NSTimeInterval vaccination_date;
@property (nonatomic) BOOL is_public;

@end
