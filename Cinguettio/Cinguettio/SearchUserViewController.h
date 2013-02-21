//
//  SearchUserViewController.h
//  Cinguettio
//
//  Created by kkirov on 1/4/13.
//  Copyright (c) 2013 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceClient.h"
#import "ServiceClientDelegate.h"
#import "ProfileController.h"
#import "UserCustomCell.h"
#import "UserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SearchUserViewController : UIViewController <UISearchBarDelegate, ServiceClientDelegate,UITableViewDataSource>


@property(nonatomic, strong) IBOutlet UISearchBar* searchBar;
@property(nonatomic, strong) IBOutlet UITableView* resultsTableView;
@property(nonatomic, strong) NSMutableArray* data;
@property(nonatomic, assign) BOOL showAllUsers;
@property (nonatomic) BOOL hasMoreData;
@property (nonatomic) BOOL loadingData;
@property (nonatomic) int pageIndex;
@property (nonatomic) int pageSize;

@end
