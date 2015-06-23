//
//  ViewController.h
//  HealthID
//
//  Created by Joshua Walsh on 5/11/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreMotion/CoreMotion.h>
@interface ViewController : UIViewController {
    CMMotionManager *motionManager;
    NSOperationQueue *queue;
}

@property (weak, nonatomic) IBOutlet UIButton *getStartedBtn;

@end

