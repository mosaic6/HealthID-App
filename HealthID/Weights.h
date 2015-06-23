//
//  Weights.h
//  HealthID
//
//  Created by Joshua Walsh on 5/31/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Weights : NSManagedObject

@property (nonatomic) NSTimeInterval created_at;
@property (nonatomic) NSTimeInterval deleted_at;
@property (nonatomic) NSTimeInterval updated_at;
@property (nonatomic) float value;

@end
