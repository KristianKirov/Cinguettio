//
//  UserAnnotation.h
//  Cinguettio
//
//  Created by kkirov on 1/5/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "UserModel.h"

@interface UserAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong)UserModel* user;
@property (nonatomic, assign)CLLocationCoordinate2D userPosition;
@property (nonatomic, strong)NSString* fullName;

- (id)initWithUser:(UserModel*)user;

@end
