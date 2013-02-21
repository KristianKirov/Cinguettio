//
//  RegisterViewController.h
//  Cinguettio
//
//  Created by kkirov on 1/2/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ServiceClientDelegate.h"
#import "ServiceClient.h"

@interface RegisterViewController : UIViewController<UITextFieldDelegate, ServiceClientDelegate>

@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

@end
