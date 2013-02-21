//
//  DetailPostViewController.m
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/28/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import "DetailPostViewController.h"

@interface DetailPostViewController ()

@end

@implementation DetailPostViewController
@synthesize postID;
@synthesize userID;
@synthesize fullNameLabel;

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ServiceClient* client = [[ServiceClient alloc] init];
    client.delegate = self;
    [client getPost:self.postID];
}

- (void)editPostClicked
{
    NewPostController* editPostController = [[NewPostController alloc] init];
    editPostController.isInEditMode = TRUE;
    editPostController.postID = self.postID;
    [self.navigationController pushViewController:editPostController animated:YES];
}


-(void)getPostCompleted:(PostModel *)post
{
    self.userID = [post.user.userId integerValue];
    self.titleLabel.text = post.title;
    self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@",post.user.firstName, post.user.lastName];
    self.contentTexView.text = post.content;
    NSString* dateCreatedStrig = [NSDateFormatter localizedStringFromDate:post.dateCreated dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.dateLabel.text = dateCreatedStrig;
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    int loggedInUserId = delegate.userID;
    
    if ( userID == 0 || userID == loggedInUserId)
    {
        UIBarButtonItem *editPostButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editPostClicked)];
        [self.navigationItem setRightBarButtonItem:editPostButton];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)viewProfileClicked:(id)sender
{
    ProfileController* userProfileController = [[ProfileController alloc] init];
    userProfileController.userID = self.userID;
    [self.navigationController pushViewController:userProfileController animated:YES];
}
@end
