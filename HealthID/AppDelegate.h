//
//  AppDelegate.h
//  HealthID
//
//  Created by Joshua Walsh on 5/11/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    CMMotionManager *motionManager;
}

@property (strong, nonatomic) UIWindow *window;

@end

