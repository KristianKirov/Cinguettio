//
//  SingleUserMapViewController.h
//  Cinguettio
//
//  Created by kkirov on 1/5/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "UserAnnotation.h"
#import "ProfileController.h"
#import "ServiceClient.h"
#import "ServiceClientDelegate.h"

@interface SingleUserMapViewController : UIViewController <MKMapViewDelegate, ServiceClientDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) int userId;

@end
