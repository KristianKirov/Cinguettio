//
//  SearchUserViewController.m
//  Cinguettio
//
//  Created by kkirov on 1/4/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import "SearchUserViewController.h"

@interface SearchUserViewController ()

@end

@implementation SearchUserViewController

@synthesize resultsTableView;
@synthesize data;
@synthesize searchBar;
@synthesize showAllUsers;
@synthesize hasMoreData;
@synthesize loadingData;
@synthesize pageIndex;
@synthesize pageSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        showAllUsers = YES;
        
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        
        self.hasMoreData = YES;
        self.loadingData = NO;
        self.pageIndex = 0;
        self.pageSize = delegate.loadItemsPerRequest;
    }
    return self;
}

- (void)viewDidLoad
{
    self.data = [[NSMutableArray alloc] init];
    [super viewDidLoad];
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
    [client getUsers:from to:to];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!showAllUsers)
    {
        return;
    }
    
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

- (void)getUsersCompleted:(NSMutableArray *)users
{
    if (showAllUsers) {
        if ([users count] == pageSize)
        {
            hasMoreData = YES;
            ++pageIndex;
        }
        else
        {
            hasMoreData = NO;
        }
        
        [self.data addObjectsFromArray:users];
        [self.resultsTableView reloadData];
        
        loadingData = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    self.showAllUsers = NO;
    [self.view endEditing:YES];
    ServiceClient* client = [[ServiceClient alloc] init];
    client.delegate = self;
    [client searchUsers:_searchBar.text];
    
}

- (void)searchUsersCompleted:(NSMutableArray *)users
{
    self.data = users;
    [self.resultsTableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.data)
    {
        return [self.data count];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    static NSString *CellIdentifier = @"UserCustomCell";
    UserCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UserCustomCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UserCustomCell class]])
            {
                cell = (UserCustomCell *)currentObject;
                break;
            }
        }
    }
    
    UserModel* user = [self.data objectAtIndex:indexPath.row];
    NSString* fullName = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    [cell.fullNameLabel setText:fullName];
    
    if (user.imageUrl)
    {
        AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        if(delegate.loadImages)
        {
            [cell.photoImageView setImageWithURL:[NSURL URLWithString:user.imageUrl] placeholderImage:[UIImage imageNamed:@"userDefault.png"]];
        }
    }
    
    return cell;
}

#pragma Mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserModel* user = [self.data objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProfileController *profileVC = [[ProfileController alloc] init];
    profileVC.userID = [user.userId integerValue];
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view.window endEditing: YES];
}

@end
