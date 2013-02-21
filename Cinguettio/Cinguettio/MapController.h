//
//  MapController.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/25/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ServiceClient.h"
#import "ServiceClientDelegate.h"
#import "AppDelegate.h"
#import "UserAnnotation.h"

@interface MapController : UIViewController <MKMapViewDelegate, ServiceClientDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
