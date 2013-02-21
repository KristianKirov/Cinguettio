//
//  ServiceClient.h
//  VirtualScrolling
//
//  Created by kkirov on 12/26/12.
//  Copyright (c) 2012 kkirov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostModel.h"
#import "UserModel.h"
#import "ServiceClientDelegate.h"
#import "PostModel.h"
#import "UserModel.h"

@interface ServiceClient : NSObject
@property (strong, nonatomic) id<ServiceClientDelegate> delegate;

- (void)getLatestPosts:(int)from to:(int)to;
- (void)getLatestPostsForUserAsync:(int)userId from:(int)f to:(int)t;
- (void)authenticateUserAsync:(NSString*)userName withPassword:(NSString*)password;
- (void)createPostAsync:(int)userId title:(NSString*)title content:(NSString*)content;
- (void)updatePostAsync:(int)postId title:(NSString*)title content:(NSString*)content;
- (void)getPost: (int)postID;
- (void)getUser: (int)userID;
- (void)getUserWithPosition: (int)userID;
- (void)createUser: (NSString*)userName withPassword:(NSString*)password withFirstName:(NSString*)firstName withLastName:(NSString*)lastName withEmail:(NSString*)email;
- (void)updateProfile:(int)userID withFirstName:(NSString*)firstName withLastName:(NSString*)lastName withEmail:(NSString*)email withImageUrl:(NSString*)imageUrl;
- (void)updateUserPosition: (int)userId withLatitude:(double)latitude withLongitude:(double)longitude;
- (void)getFriendsForUser:(int)userId from:(int)from to:(int)to;
- (void)searchUsers:(NSString*)data;
- (void)areFriends:(int)userId friend:(int)friendId;
- (void)addFriend:(int)userId friend:(int)friendId;
- (void)removeFriend:(int)userId friend:(int)friendId;
- (void)getUsersInAreaLatitudeFrom:(double)latitudeFrom latitudeTo:(double)latitudeTo longitudeFrom:(double)longitudeFrom longitudeTo:(double)longitudeTo fiendsOnly:(BOOL)friendsOnly forUser:(int)userId;
- (void)uploadImage:(UIImage*)image withName:(NSString*)fileName withExtention:(NSString*)extention;
- (void)getUsers:(int)from to:(int)to;

@end
