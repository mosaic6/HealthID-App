//
//  Medications.h
//  HealthID
//
//  Created by Joshua Walsh on 7/10/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Medications : NSObject
{
    NSString *fdaApiKey;
    NSURL *fdaUrl;
}

@property (strong, nonatomic) NSArray *medications;

- (void)getDrugByName:(NSString *)drugName;
@end
