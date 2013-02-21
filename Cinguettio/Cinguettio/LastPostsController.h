//
//  FirstViewController.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/16/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ServiceClient.h"
#import "ServiceClientDelegate.h"
#import "UserModel.h"
#import "PostModel.h"
#import "DetailPostViewController.h"
#import "PostCustomCell.h"

@interface LastPostsController: UIViewController <ServiceClientDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *postsTableVeiw;
@property (strong, nonatomic) NSMutableArray* tableData;
@property (nonatomic) int userID;
@property (nonatomic) BOOL hasMoreData;
@property (nonatomic) BOOL loadingData;
@property (nonatomic) int pageIndex;
@property (nonatomic) int pageSize;

@end
