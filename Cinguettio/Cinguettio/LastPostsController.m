//
//  FirstViewController.m
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/16/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import "LastPostsController.h"

@interface LastPostsController ()

@end

@implementation LastPostsController
@synthesize postsTableVeiw;
@synthesize tableData;
@synthesize userID;
@synthesize hasMoreData;
@synthesize loadingData;
@synthesize pageIndex;
@synthesize pageSize;

-(id)init {
    if (self = [super init])  {
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        
        self.hasMoreData = YES;
        self.loadingData = NO;
        self.pageIndex = 0;
        self.pageSize = delegate.loadItemsPerRequest;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate; 
        
        self.title = NSLocalizedString(@"Posts", @"Posts");
        self.tabBarItem.image = [UIImage imageNamed:@"tabImage"];
        self.hasMoreData = YES;
        self.loadingData = NO;
        self.pageIndex = 0;
        self.pageSize = delegate.loadItemsPerRequest;

    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    self.tableData = [[NSMutableArray alloc] init];
    
    //tab bar pictires
    UIImage *selectedImage0 = [UIImage imageNamed:@"allpostsS.png"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"allpostsUS.png"];

    UIImage *selectedImage1 = [UIImage imageNamed:@"profileS.png"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"profileUS.png"];
    
    UIImage *selectedImage2 = [UIImage imageNamed:@"postaddS.png"];
    UIImage *unselectedImage2 = [UIImage imageNamed:@"postaddUS.png"];
    
    UIImage *selectedImage3 = [UIImage imageNamed:@"friendsS.png"];
    UIImage *unselectedImage3 = [UIImage imageNamed:@"friendsUS.png"];
    
    UIImage *selectedImage4 = [UIImage imageNamed:@"mapS.png"];
    UIImage *unselectedImage4 = [UIImage imageNamed:@"mapUS.png"];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    UITabBarItem *item4 = [tabBar.items objectAtIndex:4];
    
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    [item3 setFinishedSelectedImage:selectedImage3 withFinishedUnselectedImage:unselectedImage3];
    [item4 setFinishedSelectedImage:selectedImage4 withFinishedUnselectedImage:unselectedImage4];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableData removeAllObjects];
    hasMoreData = YES;
    pageIndex = 0;

    [self loadMoreData];
}

- (void)loadMoreData
{
    if (loadingData)
    {
        return;
    }
    
    loadingData = YES;
    ServiceClient* client = [[ServiceClient alloc] init];
    client.delegate = self;
    int from = pageIndex * pageSize;
    int to = from + pageSize - 1;
    if (userID == 0)
    {
        [client getLatestPosts:from to:to];
    }
    else
    {
        [client getLatestPostsForUserAsync:userID from:from to:to];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    if (y >= h) {
        //[[[UIAlertView alloc] initWithTitle:@"Works" message:@"Works" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        if (hasMoreData)
        {
            [self loadMoreData];
        }
    }
    
}


- (void)viewDidUnload
{
    [self setPostsTableVeiw:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)onPostsRetrieved:(NSMutableArray*) posts
{
    if ([posts count] == pageSize)
    {
        hasMoreData = YES;
        ++pageIndex;
    }
    else
    {
        hasMoreData = NO;
    }
    
    [self.tableData addObjectsFromArray:posts];
    [self.postsTableVeiw reloadData];
    
    loadingData = NO;
}

- (void)getLatestPostsCompleted:(NSMutableArray *)posts
{
    [self onPostsRetrieved:posts];
}

- (void)getLatestPostsForUserCompleted:(NSMutableArray *)posts
{
    [self onPostsRetrieved:posts];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma Mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PostCustomCell";
    PostCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostCustomCell" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[PostCustomCell class]])
            {
                cell = (PostCustomCell *)currentObject;
                break;
            }
        }
    }
    
    PostModel* post = [self.tableData objectAtIndex:indexPath.row];
    
    [cell.titleLabel setText:post.title];
    NSString* fullName = [NSString stringWithFormat:@"%@ %@",post.user.firstName, post.user.lastName];
    [cell.fullNameLabel setText:fullName];
    [cell.contentTextView setText:post.content];
    NSString* dateCreatedStrig = [NSDateFormatter localizedStringFromDate:post.dateCreated dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    [cell.publishDateLabel setText:dateCreatedStrig];
 
    return cell;

}


#pragma Mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostModel* post = [self.tableData objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailPostViewController *detailVC = [[DetailPostViewController alloc] init];
    detailVC.postID = [post.postId integerValue];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end

