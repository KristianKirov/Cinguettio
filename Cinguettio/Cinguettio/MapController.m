//
//  MapController.m
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/25/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import "MapController.h"

@interface MapController ()

@end

@implementation MapController
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Map", @"Map");
        self.tabBarItem.image = [UIImage imageNamed:@"tabImage"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)mapView:(MKMapView *)_mapView regionDidChangeAnimated:(BOOL)animated
{
    MKCoordinateSpan span = _mapView.region.span;
    double latDelta = span.latitudeDelta / 2;
    double longDelta = span.longitudeDelta / 2;
    
    CLLocationCoordinate2D center = _mapView.region.center;
    
    double latetudeFrom = center.latitude - latDelta;
    double latetudeTo = center.latitude + latDelta;
    double longitudeFrom = center.longitude - longDelta;
    double longitudeTo = center.longitude + longDelta;
    
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    BOOL friendOnly = !delegate.showAllUsersOnMap;
    
    ServiceClient* client = [[ServiceClient alloc] init];
    client.delegate = self;
    [client getUsersInAreaLatitudeFrom:latetudeFrom latitudeTo:latetudeTo longitudeFrom:longitudeFrom longitudeTo:longitudeTo fiendsOnly:friendOnly forUser:delegate.userID];
}

-(void)getUsersInAreaCompleted:(NSMutableArray *)users
{
    [self removeAllAnnotations];
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    int currentUserId = delegate.userID;
    
    for (UserModel* user in users) {
        if ([user.userId integerValue] != currentUserId)
        {
            UserAnnotation* annotation = [[UserAnnotation alloc] initWithUser:user];
            [self.mapView addAnnotation:annotation];
        }
    }
}

-(void)removeAllAnnotations
{
    id userAnnotation = self.mapView.userLocation;
    
    NSMutableArray *annotations = [NSMutableArray arrayWithArray:self.mapView.annotations];
    if (userAnnotation)
    {
        [annotations removeObject:userAnnotation];
    }
    
    [self.mapView removeAnnotations:annotations];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString *identifier = @"UserAnnotation";
    if ([annotation isKindOfClass:[UserAnnotation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = detailButton;
        
        annotationView.pinColor = MKPinAnnotationColorGreen;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[UserAnnotation class]])
    {
        UserAnnotation* annotation = (UserAnnotation*)view.annotation;
        int userId = [annotation.user.userId integerValue];
        
        ProfileController *profileVC = [[ProfileController alloc] init];
        profileVC.userID = userId;
        [self.navigationController pushViewController:profileVC animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CLLocationManager* locationManager = [[CLLocationManager alloc] init];
    CLLocationCoordinate2D centerCoordinate;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        centerCoordinate = locationManager.location.coordinate;
    }
    else
    {
        centerCoordinate.latitude = 42.646444;
        centerCoordinate.longitude = 23.34511;
    }
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, 1000.0, 1000.0);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}
@end
