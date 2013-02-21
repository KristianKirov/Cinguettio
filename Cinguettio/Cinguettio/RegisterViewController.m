//
//  RegisterViewController.m
//  Cinguettio
//
//  Created by kkirov on 1/2/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize userNameTextField;
@synthesize passwordTextField;
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize emailTextField;

-(BOOL)validateTextFilds
{
    if( [self.userNameTextField.text length] == 0 || [self.passwordTextField.text length] == 0 || [self.firstNameTextField.text length] == 0 || [self.lastNameTextField.text length] == 0 || [self.emailTextField.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Incomplete registration! "];
        [alert setMessage:@"Missing information! "];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        
        if([self.userNameTextField.text length] == 0 )
        {
            self.userNameTextField.layer.borderWidth = 2.0f;
            self.userNameTextField.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else if([self.userNameTextField.text length] > 0 )
        {
            self.userNameTextField.layer.borderColor = [[UIColor clearColor] CGColor];
        }
        
        if([self.passwordTextField.text length] == 0 )
        {
            self.passwordTextField.layer.borderWidth = 2.0f;
            self.passwordTextField.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else if([self.passwordTextField.text length] > 0 )
        {
            self.passwordTextField.layer.borderColor = [[UIColor clearColor] CGColor];
        }
        
        if([self.firstNameTextField.text length] == 0 )
        {
            self.firstNameTextField.layer.borderWidth = 2.0f;
            self.firstNameTextField.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else if([self.firstNameTextField.text length] > 0)
        {
            self.firstNameTextField.layer.borderColor = [[UIColor clearColor] CGColor];
        }
        
        if([self.lastNameTextField.text length] == 0 )
        {
            self.lastNameTextField.layer.borderWidth = 2.0f;
            self.lastNameTextField.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else if([self.lastNameTextField.text length] > 0 )
        {
            self.lastNameTextField.layer.borderColor = [[UIColor clearColor] CGColor];
        }
            
        if([self.emailTextField.text length] == 0 )
        {
            self.emailTextField.layer.borderWidth = 2.0f;
            self.emailTextField.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else if([self.emailTextField.text length] > 0)
        {
            self.emailTextField.layer.borderColor = [[UIColor clearColor] CGColor];
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
    if( [self validateTextFilds] )
    {
        ServiceClient* client = [[ServiceClient alloc] init];
        client.delegate = self;
        [client createUser:self.userNameTextField.text withPassword:self.passwordTextField.text withFirstName:self.firstNameTextField.text withLastName:self.lastNameTextField.text withEmail:self.emailTextField.text];
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Your registration has been successfully completed! "];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"OK"];
        [alert show];

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
    UIBarButtonItem *registerButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(registerClicked)];
    [self.navigationItem setRightBarButtonItem:registerButton];
}

- (void) registerClicked
{
   if( [self validateTextFilds] )
   {
        ServiceClient* client = [[ServiceClient alloc] init];
        client.delegate = self;
        [client createUser:self.userNameTextField.text withPassword:self.passwordTextField.text withFirstName:self.firstNameTextField.text withLastName:self.lastNameTextField.text withEmail:self.emailTextField.text];
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Your registration has been successfully completed! "];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    }
}

- (void)createUserCompleted:(BOOL)success
{
    if (success) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView* errorMsg = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not create user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorMsg show];
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
    [self setUserNameTextField:nil];
    [self setFirstNameTextField:nil];
    [self setLastNameTextField:nil];
    [self setEmailTextField:nil];
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view.window endEditing: YES];
}

@end
