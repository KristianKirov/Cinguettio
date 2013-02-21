//
//  LoginViewController.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/29/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LoginWindowProtocol.h"
#import "ServiceClient.h"
#import "ServiceClientDelegate.h"
#import "UserModel.h"
#import "RegisterViewController.h"


@interface LoginViewController : UIViewController <ServiceClientDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;

@property (nonatomic, weak) id<LoginWindowProtocol> delegate;
-(IBAction)loginButtonClicked:(id)sender;
-(void)authenticateUserCompleted:(UserModel *)user;

@end
