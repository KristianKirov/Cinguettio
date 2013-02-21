//
//  FriendsController.m
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/16/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import "FriendsController.h"

@interface FriendsController ()

@end

@implementation FriendsController

@synthesize friendsTableVeiw;
@synthesize tableData;

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
        
        self.title = NSLocalizedString(@"Friends", @"Friends");
        self.tabBarItem.image = [UIImage imageNamed:@"tabImage"];
        self.hasMoreData = YES;
        self.loadingData = NO;
        self.pageIndex = 0;
        self.pageSize = delegate.loadItemsPerRequest;
    }
    return self;
}

- (void)viewDidLoad
{
    self.tableData = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
    UIBarButtonItem *addFriendButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(addFriendClicked)];
    [self.navigationItem setRightBarButtonItem:addFriendButton];
}

- (void)addFriendClicked
{
    SearchUserViewController* searchVc = [[SearchUserViewController alloc] init];
    searchVc.title = @"Search";
    [self.navigationController pushViewController:searchVc animated:YES];
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
    
    AppDelegate* delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    int loggedInUserId = delegate.userID;
    
    [client getFriendsForUser:loggedInUserId from:from to:to];
}

- (void)getFriendsForUserCompleted:(NSMutableArray *)friends
{
    if ([friends count] == pageSize)
    {
        hasMoreData = YES;
        ++pageIndex;
    }
    else
    {
        hasMoreData = NO;
    }
    
    [self.tableData addObjectsFromArray:friends];
    [self.friendsTableVeiw reloadData];
    
    loadingData = NO;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload
{
    [self setFriendsTableVeiw:nil];
    [super viewDidUnload];
}

#pragma Mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"UserCustomCell";
    UserCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UserCustomCell" owner:nil options:nil];
        
      //  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UserCustomCell class]])
            {
                cell = (UserCustomCell *)currentObject;
                break;
            }
        }

    }
    
    UserModel* user = [self.tableData objectAtIndex:indexPath.row];
    NSString* fullName = [NSString stringWithFormat:@"%@ %@",user.firstName, user.lastName];
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
    
    UserModel* user = [self.tableData objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProfileController *profileVC = [[ProfileController alloc] init];
    profileVC.userID = [user.userId integerValue];
    [self.navigationController pushViewController:profileVC animated:YES];
}

@end
