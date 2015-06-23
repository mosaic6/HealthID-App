//
//  Allergies.h
//  HealthID
//
//  Created by Joshua Walsh on 6/4/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Allergies : NSManagedObject

@property (nonatomic) NSTimeInterval created_at;
@property (nonatomic) NSTimeInterval deleted_at;
@property (nonatomic) NSTimeInterval last_reaction;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * reaction;
@property (nonatomic) NSTimeInterval updated_at;
@property (nonatomic) BOOL is_public;

@end
