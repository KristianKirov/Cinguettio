//
//  DetailUserViewController.m
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/28/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import "DetailUserViewController.h"

@interface DetailUserViewController ()

@end

@implementation DetailUserViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPhotoImageView:nil];
    [self setFirstNameLabel:nil];
    [self setLastNameLabel:nil];
    [super viewDidUnload];
}
- (IBAction)sendMailButton:(id)sender {
}
@end
