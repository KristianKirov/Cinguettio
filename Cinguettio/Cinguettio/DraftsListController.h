//
//  DraftsListController.h
//  Cinguettio
//
//  Created by Gabriela Zagarova on 12/16/12.
//  Copyright (c) 2012 FMI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "PostDraft.h"
#import "DraftsListDelegate.h"

@interface DraftsListController : UIViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate,UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UISearchBar* searchBar;
@property (nonatomic, strong) NSFetchedResultsController* resultsController;
@property (nonatomic, weak) id<DraftsListDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
