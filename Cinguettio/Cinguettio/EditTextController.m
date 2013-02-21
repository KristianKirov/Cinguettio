//
//  EditTextController.m
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/16/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import "EditTextController.h"

@interface EditTextController ()

@end

@implementation EditTextController

@synthesize PropertyText;
@synthesize PropertyLabel;
@synthesize label;
@synthesize textField;
@synthesize delegate;

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if( [self.textField.text length] > 0 )
    {
        self.PropertyText = self.textField.text;
        [self.delegate textEditCompleted:self value:self.PropertyText];
        return YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Missing post title! "];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        if( [self.textField.text length] <= 0)
        {
            self.textField.layer.borderWidth = 2.0f;
            self.textField.layer.borderColor = [[UIColor redColor] CGColor];
        }
        //[self.textField resignFirstResponder];
        return NO;
    }
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"tabImage"];
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIButtonTypeRoundedRect target:self action:@selector(donePressed)];
    [self.navigationItem setRightBarButtonItem:doneButton];
    
    self.title = PropertyLabel;
    self.label.text = PropertyLabel;
    self.textField.text = PropertyText;
    
    [self.textField becomeFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) donePressed{
    if( [self.textField.text length] > 0 )
    {
        self.PropertyText = self.textField.text;
        [self.delegate textEditCompleted:self value:self.PropertyText];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Enter post title! "];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        if( [self.textField.text length] <= 0 )
        {
            self.textField.layer.borderWidth = 2.0f;
            self.textField.layer.borderColor = [[UIColor redColor] CGColor];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view.window endEditing: YES];
}

@end
