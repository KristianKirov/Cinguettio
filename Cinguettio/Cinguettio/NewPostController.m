//
//  SecondViewController.m
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/16/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import "NewPostController.h"

@interface NewPostController()

@end

@implementation NewPostController

@synthesize contentTextView;
@synthesize titleContentLabel;
@synthesize isInEditMode;
@synthesize postID;


-(BOOL)validateLabels
{
    if( [self.titleContentLabel.text length] == 0 || [self.contentTextView.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"Missing post title or post content! "];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        if( [self.titleContentLabel.text length] == 0)
        {
            self.titleContentLabel.layer.borderWidth = 2.0f;
            self.titleContentLabel.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else  if( [self.titleContentLabel.text length] > 0)
        {
            self.titleContentLabel.layer.borderColor = [[UIColor clearColor] CGColor];
        }
        if( [self.contentTextView.text length] == 0)
        {
            self.contentTextView.layer.borderWidth = 2.0f;
            self.contentTextView.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else if( [self.contentTextView.text length] > 0)
        {
            self.contentTextView.layer.borderColor = [[UIColor clearColor] CGColor];
        }
        return FALSE;
    }
return TRUE;
}
-(void)richTextEditCompleted:(id)sender value:(NSString *)val
{
  
    [self.navigationController popToViewController:self animated:YES];
    self.contentTextView.layer.borderColor = [[UIColor clearColor] CGColor];
    self.contentTextView.text = val;
}

-(void)textEditCompleted:(id)sender value:(NSString *)val
{
    [self.navigationController popToViewController:self animated:YES];
    self.titleContentLabel.layer.borderColor = [[UIColor clearColor] CGColor];
    self.titleContentLabel.text = val;
}

-(void)contentEditClicked:(id)sender
{
    EditRichTextController* editController = [[EditRichTextController alloc]init];
    editController.title = @"Content";
    editController.PropertyText = self.contentTextView.text;
    editController.delegate = self;
    [self.navigationController pushViewController:editController animated:YES];
    
}

-(void)titleEditClicked:(id)sender
{
    EditTextController* editController = [[EditTextController alloc]init];
    editController.title = @"Title";
    editController.PropertyLabel = @"Title";
    editController.PropertyText = self.titleContentLabel.text;
    editController.delegate = self;
    [self.navigationController pushViewController:editController animated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"New Post", @"New Post");
        self.tabBarItem.image = [UIImage imageNamed:@"tabImage"];
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    if(isInEditMode)
    {
        ServiceClient* client = [[ServiceClient alloc] init];
        client.delegate = self;
        [client getPost:self.postID];
        isInEditMode = FALSE;
    }
    [super viewWillAppear:animated];
}
							
- (void)viewDidLoad
{
    
    if(isInEditMode)
    {
        self.loadButton.hidden = YES;
        self.title = NSLocalizedString(@"Edit Post", @"Edit Post");
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(savePressed)];
        [self.navigationItem setRightBarButtonItem:saveButton];
    }
    else
    {
        UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleBordered target:self action:@selector(postPressed)];
        [self.navigationItem setRightBarButtonItem:postButton];
    
        UIBarButtonItem *draftButton = [[UIBarButtonItem alloc] initWithTitle:@"Draft" style:UIBarButtonItemStyleBordered target:self action:@selector(draftPressed)];
        [self.navigationItem setLeftBarButtonItem:draftButton];
    }
    
    [titleContentLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizerT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleEditClicked:)];
    [tapGestureRecognizerT setNumberOfTapsRequired:1];
    [titleContentLabel addGestureRecognizer:tapGestureRecognizerT];
    
    [contentTextView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizerC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentEditClicked:)];
    [tapGestureRecognizerC setNumberOfTapsRequired:1];
    [contentTextView addGestureRecognizer:tapGestureRecognizerC];
    
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
}


-(void)getPostCompleted:(PostModel *)post
{
    self.titleContentLabel.text = post.title;
    self.contentTextView.text = post.content;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) postPressed
{
    if( [self validateLabels] ){
        //TO DO communicate with service
        ServiceClient* client = [[ServiceClient alloc] init];
        client.delegate = self;
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        int userID = delegate.userID;
        [client createPostAsync:userID title:self.titleContentLabel.text content:contentTextView.text];
    }
}

- (void) draftPressed{
    //za box
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@""];
	[alert setMessage:@"Do you want to save this post?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
    

  //  CinguettioDataAccessLayer* dal = [[CinguettioDataAccessLayer alloc] init];
  // [dal addPostDraft:self.titleContentLabel.text withContent:self.contentTextView.text];

}

- (void) savePressed{
    //TO DO communicate with service
    ServiceClient* client = [[ServiceClient alloc] init];
    client.delegate = self;
    //AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    //int userID = delegate.userID;
    [client updatePostAsync:postID title:self.titleContentLabel.text content:contentTextView.text];
}


//delegate method to catch the button click:
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		CinguettioDataAccessLayer* dal = [[CinguettioDataAccessLayer alloc] init];
        [dal addPostDraft:self.titleContentLabel.text withContent:self.contentTextView.text];
    }
	else if (buttonIndex == 1)
	{
		
	}
}


-(void)loadDraftClicked:(id)sender
{
    DraftsListController *draftListController = [[DraftsListController alloc]init];
    draftListController.delegate = self;
    [self.navigationController pushViewController:draftListController animated:YES];
}

-(void)draftSelectedWithTitle:(NSString *)title andContent:(NSString *)content
{
    self.titleContentLabel.text = title;
    self.contentTextView.text = content;
}

- (void)postCreated
{
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Post created!"];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
    self.titleContentLabel.text = @"";
    self.contentTextView.text = @"";

}

- (void)postUpdated
{
    UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Post updated! "];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
    self.titleContentLabel.text = @"";
    self.contentTextView.text = @"";
    
}

@end
