//
//  UploadedImagesViewController.m
//  Cinguettio
//
//  Created by kkirov on 1/5/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import "UploadedImagesViewController.h"

@interface UploadedImagesViewController ()

@end

@implementation UploadedImagesViewController

@synthesize resultsController;
@synthesize imagesTableVIew;


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
    
    UIBarButtonItem *addImageButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addImageClicked)];
    [self.navigationItem setRightBarButtonItem:addImageButton];
}

- (void)addImageClicked
{
    UploadImageViewController* uploadImageVC = [[UploadImageViewController alloc] init];
    [self.navigationController pushViewController:uploadImageVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
	NSManagedObjectContext *moc = [appDelegate managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"UploadedImage" inManagedObjectContext:moc];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"imgTitle" ascending:YES];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:@"uploadedImage_list.cache"];
    self.resultsController.delegate = self;
    
    NSError* error;
	BOOL success = [self.resultsController performFetch:&error];
    
    if (!success) {
        NSLog(@"The objects cannot be retrieved");
    }
    else
    {
        [self.imagesTableVIew reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.resultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.resultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"UploadedImageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
    }
    
    UploadedImage* imageData = (UploadedImage*)[self.resultsController objectAtIndexPath:indexPath];
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    if(delegate.loadImages)
    {
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageData.imgUrl] placeholderImage:[UIImage imageNamed:@"userDefault.png"]];
    }
    
    cell.textLabel.text = imageData.imgTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate)
    {
        UploadedImage* imageData = (UploadedImage*)[self.resultsController objectAtIndexPath:indexPath];
        [self.delegate imageSelectedWithUrl:imageData.imgUrl];
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
    [self setImagesTableVIew:nil];
    [super viewDidUnload];
}
@end
