//
//  LoginViewController.m
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/29/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize delegate;

-(BOOL)validateTextFilds
{
    if( [self.userNameTF.text length] == 0 || [self.passwordTF.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Missing information! "];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
     
        if([self.userNameTF.text length] == 0 ){
            self.userNameTF.layer.borderWidth = 2.0f;
            self.userNameTF.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else  if([self.userNameTF.text length] > 0 ){
            self.userNameTF.layer.borderColor = [[UIColor clearColor] CGColor];
        }
        if( [self.passwordTF.text length] == 0) {
            self.passwordTF.layer.borderWidth = 2.0f;
            self.passwordTF.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else if( [self.passwordTF.text length] > 0) {
            self.passwordTF.layer.borderColor = [[UIColor clearColor] CGColor];
        }
        return FALSE;
    }
    return TRUE;
}

//scroll code
CGFloat animatedDistance;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if( [self validateTextFilds] ){
        ServiceClient* client = [[ServiceClient alloc] init];
        client.delegate = self;
        [client authenticateUserAsync:self.userNameTF.text withPassword:self.passwordTF.text];
    }
    [textField resignFirstResponder];
    return YES;
}

//end of scroll code



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
    UIBarButtonItem *registerButton = [[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStyleBordered target:self action:@selector(registerClicked)];
    [self.navigationItem setRightBarButtonItem:registerButton];
}

- (void) registerClicked{
    RegisterViewController* registerController = [[RegisterViewController alloc] init];
    registerController.title = @"Register";
    [self.navigationController pushViewController:registerController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loginButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    if( [self validateTextFilds] ){
        ServiceClient* client = [[ServiceClient alloc] init];
        client.delegate = self;
        [client authenticateUserAsync:self.userNameTF.text withPassword:self.passwordTF.text];
    }
}

- (void)authenticateUserCompleted:(UserModel *)user
{
    if (user)
    {
        [self.delegate UserAuthenticationSucceeded:user];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"There is no such user registered! "];
        [alert setMessage:@" Make sure your username and password are are correct or make registration! "];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    }
    
}

- (void)viewDidUnload {
    [self setUserNameTF:nil];
    [self setPasswordTF:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view.window endEditing: YES];
}


@end
