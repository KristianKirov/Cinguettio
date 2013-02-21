//
//  ServiceClientDelegate.h
//  VirtualScrolling
//
//  Created by kkirov on 12/27/12.
//  Copyright (c) 2012 kkirov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "PostModel.h"

@protocol ServiceClientDelegate <NSObject>

@optional

- (void)getLatestPostsCompleted:(NSMutableArray*)posts;
- (void)getLatestPostsForUserCompleted:(NSMutableArray*)posts;
- (void)authenticateUserCompleted:(UserModel*)user;
- (void)postCreated;
- (void)postUpdated;
- (void)getPostCompleted:(PostModel*)post;
- (void)getUserCompleted:(UserModel*)user;
- (void)getUserWithPositionCompleted:(UserModel*)user;
- (void)createUserCompleted:(BOOL)success;
- (void)updateProfileCompleted;
- (void)getFriendsForUserCompleted:(NSMutableArray*)friends;
- (void)searchUsersCompleted:(NSMutableArray*)users;
- (void)areFriendsCompleted:(BOOL)result;
- (void)addFriendCompleted:(BOOL)result;
- (void)removeFriendCompleted:(BOOL)result;
- (void)getUsersInAreaCompleted:(NSMutableArray*)users;
- (void)uploadImageCompleted:(NSString*)url;
- (void)getUsersCompleted:(NSMutableArray*)users;

@end
