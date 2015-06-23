//
//  Procedures.h
//  HealthID
//
//  Created by Joshua Walsh on 6/4/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Procedures : NSManagedObject

@property (nonatomic) NSTimeInterval procedure_date;
@property (nonatomic) NSTimeInterval created_on;
@property (nonatomic) NSTimeInterval deleted_on;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic) NSTimeInterval updated_on;
@property (nonatomic) BOOL is_public;

@end
