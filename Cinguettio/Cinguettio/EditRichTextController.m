//
//  EditRichTextController.m
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/16/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import "EditRichTextController.h"

@interface EditRichTextController ()

@end

@implementation EditRichTextController

@synthesize PropertyText;
@synthesize textView;
@synthesize delegate;

- (void)registerKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardDidShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

- (void)unregisterKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    //adjust frame
    [textView setFrame:CGRectMake(0, 0, 320, 455)];
}

-(void) keyboardWillShow:(NSNotification *)note
{
    //adjust frame
    [textView setFrame:CGRectMake(0, 0, 320, 200)];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Content", @"Content");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerKeyboardNotifications];
    [self keyboardWillHide:nil];
    [self keyboardWillShow:nil];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIButtonTypeRoundedRect  target:self action:@selector(donePressed)];
    [self.navigationItem setRightBarButtonItem:doneButton];
    
    self.textView.text = PropertyText;
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) donePressed{
    
    if( [self.textView.text length] > 0 )
    {
        self.PropertyText = self.textView.text;
        [self.delegate richTextEditCompleted:self value:self.PropertyText];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Missing post content! "];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        if( [self.textView.text length] <= 0)
        {
            self.textView.layer.borderWidth = 2.0f;
            self.textView.layer.borderColor = [[UIColor redColor] CGColor];
        }
        [self.textView resignFirstResponder];
    }

}


- (void)viewWillDisappear:(BOOL)animated
{
    [self unregisterKeyboardNotifications];
    [super viewDidAppear:animated];
    [self.view.window endEditing: YES];
}

@end
