//
//  UserAnnotation.m
//  Cinguettio
//
//  Created by kkirov on 1/5/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import "UserAnnotation.h"


@implementation UserAnnotation

@synthesize user;
@synthesize userPosition;
@synthesize fullName;

- (id)initWithUser:(UserModel *)_user
{
    if ((self = [super init])) {
        self.user = _user;
        CLLocationCoordinate2D pos;
        pos.latitude = [_user.latitude doubleValue];
        pos.longitude = [_user.longitude doubleValue];
        self.userPosition = pos;
        self.fullName = [[NSString alloc] initWithFormat:@"%@ %@", _user.firstName, _user.lastName];
    }
    return self;
}

- (NSString *)title{
    return self.fullName;
}

- (NSString *)subtitle{
    return self.user.email;
}

- (CLLocationCoordinate2D)coordinate{
    return self.userPosition;
}

@end
