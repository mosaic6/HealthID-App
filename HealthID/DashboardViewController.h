//
//  DashboardViewController.h
//  HealthID
//
//  Created by Joshua Walsh on 5/25/15.
//  Copyright (c) 2015 Joshua Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>
#import "WelcomeView.h"
#import "CoreDataStack.h"

@interface DashboardViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *welcomeView;
@property (strong, nonatomic) NSArray *dashboardList;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;

@end
