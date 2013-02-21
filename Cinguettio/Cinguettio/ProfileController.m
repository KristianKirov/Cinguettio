//
//  ProfileController.m
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/25/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import "ProfileController.h"

@interface ProfileController ()

@end

@implementation ProfileController
@synthesize userID;
@synthesize sendMailButton;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Profile", @"Profile");
        self.tabBarItem.image = [UIImage imageNamed:@"tabImage"];
    }
    return self;
}

- (void)viewDidLoad
{
    //in pfofil hiden sedn mail button
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    int loggedInUserId = delegate.userID;
    if (userID == 0 || userID == loggedInUserId)
    {
        userID = loggedInUserId;
        self.sendMailButton.hidden = YES;
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)viewOnMapClicked:(id)sender
{
    SingleUserMapViewController* userOnMapVC = [[SingleUserMapViewController alloc] init];
    userOnMapVC.userId = self.userID;
    
    [self.navigationController pushViewController:userOnMapVC animated:YES];
}

-(IBAction)showMailAction:(id)sender {
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
	if (mailClass != nil && [mailClass canSendMail]) {
        [self displayMailComposerSheet];
    } else {
        NSLog(@"Device not configured to send mail.");
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    ServiceClient* client = [[ServiceClient alloc] init];
    client.delegate = self;
    
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    int loggedInUserId = delegate.userID;
    if (userID == 0 || userID == loggedInUserId)
    {
        userID = loggedInUserId;
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editClicked)];
        [self.navigationItem setRightBarButtonItem:editButton];
    }
    else
    {
        [client areFriends:loggedInUserId friend:userID];
    }

    [client getUser:userID];
    [super viewWillAppear:animated];
}

- (void)editClicked
{
    EditProfileViewController* editProfileController = [[EditProfileViewController alloc] init];
    [self.navigationController pushViewController:editProfileController animated:YES];

}

- (void)areFriendsCompleted:(BOOL)result
{
    if (result)
    {
        UIBarButtonItem *removeFriendButton = [[UIBarButtonItem alloc] initWithTitle:@"Remove Friend" style:UIBarButtonItemStyleBordered target:self action:@selector(removeFriendClicked)];
        [self.navigationItem setRightBarButtonItem:removeFriendButton];
    }
    else
    {
        UIBarButtonItem *addFriendButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Friend" style:UIBarButtonItemStyleBordered target:self action:@selector(addFriendClicked)];
        [self.navigationItem setRightBarButtonItem:addFriendButton];
    }
}

- (void)removeFriendClicked
{
    ServiceClient* client = [[ServiceClient alloc] init];
    client.delegate = self;
    
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    int loggedInUserId = delegate.userID;
    
    [client removeFriend:loggedInUserId friend:self.userID];
}

- (void)removeFriendCompleted:(BOOL)result
{
    if (result)
    {
        self.navigationItem.rightBarButtonItem.title = @"Add Friend";
        self.navigationItem.rightBarButtonItem.action = @selector(addFriendClicked);
    }
    else
    {
        UIAlertView* msg = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Could not remove friend" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [msg show];
    }
}

- (void)addFriendClicked
{
    ServiceClient* client = [[ServiceClient alloc] init];
    client.delegate = self;
    
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    int loggedInUserId = delegate.userID;
    
    [client addFriend:loggedInUserId friend:self.userID];
}

- (void)addFriendCompleted:(BOOL)result
{
    if (result)
    {
        self.navigationItem.rightBarButtonItem.title = @"Remove Friend";
        self.navigationItem.rightBarButtonItem.action = @selector(removeFriendClicked);
    }
    else
    {
        UIAlertView* msg = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Could not add friend" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [msg show];
    }
}

-(void)getUserCompleted:(UserModel *)user
{
    if (user.imageUrl)
    {
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        if(delegate.loadImages)
        {
        [self.profileImageView setImageWithURL:[NSURL URLWithString:user.imageUrl] placeholderImage:[UIImage imageNamed:@"userDefault.png"]];
        }
    }
    self.firstNameLabel.text = user.firstName;
    self.lastNameLabel.text = user.lastName;
    self.mailLabel.text = user.email;
    self.usernameLabel.text = user.userName;
    //.......
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Mail controller

- (void)displayMailComposerSheet {
	MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
	mailController.mailComposeDelegate = self;
	
	[mailController setSubject:@"Mail from friend"];
	
	NSArray *toRecipients = [NSArray arrayWithObject:self.mailLabel.text];
	[mailController setToRecipients:toRecipients];
	
	// Fill out the email body text
	//NSString *emailBody = @"";
	//[mailController setMessageBody:emailBody isHTML:NO];
	
	[self presentViewController:mailController animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
    NSString* message = nil;
    
	// Notifies users about errors associated with the interface
	switch (result) {
		case MFMailComposeResultCancelled:
			message = @"Mail sending canceled";
			break;
		case MFMailComposeResultSaved:
			message = @"Mail saved";
			break;
		case MFMailComposeResultSent:
			message = @"Mail sent";
			break;
		case MFMailComposeResultFailed:
			message = @"Mail sending failed";
			break;
		default:
			message = @"Mail not sent";
			break;
	}
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Email" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setFirstNameLabel:nil];
    [self setLastNameLabel:nil];
    [self setProfileImageView:nil];
    [self setUsernameLabel:nil];
    [super viewDidUnload];
}
- (IBAction)myPostsButton:(id)sender
{
    LastPostsController* selectedPostVC = [[LastPostsController alloc] init];
    selectedPostVC.userID = self.userID;
    [self.navigationController pushViewController:selectedPostVC animated:YES];
}
@end
