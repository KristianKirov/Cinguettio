//
//  LoginWindowProtocol.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/29/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@protocol LoginWindowProtocol <NSObject>

-(void) UserAuthenticationSucceeded:(UserModel*) user;
@end
