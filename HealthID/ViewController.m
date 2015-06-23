//
//  ViewController.m
//  HealthID
//
//  Created by Joshua Walsh on 5/11/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "Dates.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.getStartedBtn.layer.borderColor = (__bridge CGColorRef)([UIColor whiteColor]);
    
    motionManager = [[CMMotionManager alloc]init];
    motionManager.accelerometerUpdateInterval = 2;
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startMyMotionDetect];
}


//- (CMMotionManager *)motionManager {
//    motionManager = [[CMMotionManager alloc] init];
//    motionManager.accelerometerUpdateInterval  = 1.0/10.0;\
//    if (motionManager.accelerometerAvailable) {
//        NSLog(@"Accelerometer available");
//        queue = [NSOperationQueue currentQueue];
//        [motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
//            CMAcceleration acceleration = accelerometerData.acceleration;
//            NSLog(@"%f", acceleration.x);
//            NSLog(@"%f", acceleration.y);
//            if ((acceleration.x) > 0.2 || (acceleration.y) > 0.2) {
//                [motionManager stopAccelerometerUpdates];
//                
//                UILocalNotification *localNotification = [[UILocalNotification alloc]init];
//                localNotification.alertBody = @"Good Morning Josh, Did you take your medications this morning?";
//                localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication]applicationIconBadgeNumber];
//                [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
//                
//                
//            }
//        }];
//    }
//    return motionManager;
//}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [motionManager stopAccelerometerUpdates];
    // Request to stop receiving accelerometer events and turn off accelerometer
    
}

- (CMMotionManager *)motionManager
{
    motionManager = nil;
    
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    if ([appDelegate respondsToSelector:@selector(motionManager)]) {
        motionManager = [appDelegate motionManager];
    }
    
    return motionManager;
}

- (void)startMyMotionDetect {
    NSLog(@"active %d",motionManager.accelerometerActive);
    
    NSLog(@"availabilty %d",motionManager.accelerometerAvailable);
    
    [motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),^{
             [motionManager stopAccelerometerUpdates];
        });
     }];
}
@end
