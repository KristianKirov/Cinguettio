//
//  SingleUserMapViewController.m
//  Cinguettio
//
//  Created by kkirov on 1/5/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import "SingleUserMapViewController.h"

@interface SingleUserMapViewController ()

@end

@implementation SingleUserMapViewController
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    ServiceClient* client = [[ServiceClient alloc] init];
    client.delegate = self;
    [client getUserWithPosition:self.userId];
}

- (void)getUserWithPositionCompleted:(UserModel *)user
{
    [self removeAllAnnotations];
    if (user)
    {
        UserAnnotation* annotation = [[UserAnnotation alloc] initWithUser:user];
        [self.mapView addAnnotation:annotation];
        
        CLLocationCoordinate2D centerCoordinate;
        centerCoordinate.latitude = [user.latitude doubleValue];
        centerCoordinate.longitude = [user.longitude doubleValue];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, 1000.0, 1000.0);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES];
    }
    else
    {
        UIAlertView* msg = [[UIAlertView alloc] initWithTitle:@"Not Found" message:@"Could not find the location of user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [msg show];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}
@end
