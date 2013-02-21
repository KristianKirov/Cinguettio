//
//  ServiceClient.m
//  VirtualScrolling
//
//  Created by kkirov on 12/26/12.
//  Copyright (c) 2012 kkirov. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1


#import "ServiceClient.h"

@implementation ServiceClient
@synthesize delegate;

- (NSMutableArray*)getPostsFromData:(NSData*)data
{
    NSError* error;
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:kNilOptions 
                     error:&error];
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:[json count]];
    for (NSDictionary* postData in json) {
        PostModel* post = [[PostModel alloc] initFromJson:postData];
        NSDictionary* userData = [postData objectForKey:@"User"];
        post.user = [[UserModel alloc] initFromJson:userData];
        
        [result addObject:post];
    }
    
    return result;
}

- (void)getLatestPosts:(int)from to:(int)to
{
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/CinguettioDataService.svc/GetLatestPosts?from=%d&to=%d", from, to];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: 
                        dataUrl];
        
        NSMutableArray* result = [self getPostsFromData:data];
        
        [self performSelectorOnMainThread:@selector(getLatestPostsCompleted:)
                               withObject:result waitUntilDone:YES];
    });
}

- (void)getLatestPostsCompleted:(NSMutableArray*)posts {
    if (self.delegate) {
        [self.delegate getLatestPostsCompleted:posts];
    }
}

- (void)getLatestPostsForUserAsync:(int)userId from:(int)f to:(int)t
{
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/CinguettioDataService.svc/GetLatestPostsForUser?userId=%d&from=%d&to=%d", userId, f, t];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: 
                        dataUrl];
        
        NSMutableArray* result = [self getPostsFromData:data];
        
        [self performSelectorOnMainThread:@selector(getLatestPostsForUserCompleted:)
                               withObject:result waitUntilDone:YES];
    });
}

- (void)getLatestPostsForUserCompleted:(NSMutableArray*)posts {
    if (self.delegate) {
        [self.delegate getLatestPostsForUserCompleted:posts];
    }
}

- (void)authenticateUserAsync:(NSString *)userName withPassword:(NSString *)password
{
    NSString* encodedUserName = [userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* encodedPassword = [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/cinguettiodataservice.svc/AuthenticateUser?userName=%@&password=%@", encodedUserName, encodedPassword];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        dataUrl];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:kNilOptions
                         error:&error];
        
        UserModel* user = nil;
        if (json)
        {
            user = [[UserModel alloc] initFromJson:json];
            
        }
        [self performSelectorOnMainThread:@selector(authenticateUserCompleted:) withObject:user waitUntilDone:YES];
    });
}

- (void)authenticateUserCompleted:(UserModel*)user
{
    if (self.delegate)
    {
        [self.delegate authenticateUserCompleted:user];
    }
}

-(void)createPostAsync:(int)userId title:(NSString *)title content:(NSString *)content
{
    NSString* encodedTitle = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* encodedContent = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/cinguettiodataservice.svc/CreatePost?userId=%d&title=%@&content=%@", userId,encodedTitle,encodedContent];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        [NSData dataWithContentsOfURL:dataUrl];
        [self performSelectorOnMainThread:@selector(postCreated:) withObject:nil waitUntilDone:YES];
    });

}

- (void)postCreated:(NSObject*)obj
{
    if (self.delegate)
    {
        [self.delegate postCreated];
    }

}

- (void)updatePostAsync:(int)postId title:(NSString*)title content:(NSString*)content
{
    NSString* encodedTitle = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* encodedContent = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/CinguettioDataService.svc/UpdatePost?postId=%d&title=%@&content=%@", postId,encodedTitle,encodedContent];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        [NSData dataWithContentsOfURL:dataUrl];
        [self performSelectorOnMainThread:@selector(postUpdated:) withObject:nil waitUntilDone:YES];
    });

}

- (void)postUpdated:(NSObject*)obj
{
    if (self.delegate)
    {
        [self.delegate postUpdated];
    }
    
}



-(void)getPost:(int)postID
{
    
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/cinguettiodataservice.svc/getPost?postID=%d", postID];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        dataUrl];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        
        PostModel* post = [[PostModel alloc] initFromJson:json];
        NSDictionary* userData = [json objectForKey:@"User"];
        post.user = [[UserModel alloc] initFromJson:userData];
        
        [self performSelectorOnMainThread:@selector(getPostCompleted:) withObject:post waitUntilDone:YES];
    });
}

- (void)getPostCompleted:(PostModel*)post
{
    if (self.delegate)
    {
        [self.delegate getPostCompleted:post];
    }
    
}

-(void) getUser:(int)userID
{
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/cinguettiodataservice.svc/getUser?userID=%d", userID];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        dataUrl];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        UserModel* user = [[UserModel alloc] initFromJson:json];
        
        [self performSelectorOnMainThread:@selector(getUserCompleted:) withObject:user waitUntilDone:YES];
    });
}

- (void)getUserCompleted:(UserModel*)user
{
    if (self.delegate)
    {
        [self.delegate getUserCompleted:user];
    }
}

-(void) getUserWithPosition:(int)userID
{
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/cinguettiodataservice.svc/GetUserWithPosition?userID=%d", userID];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        dataUrl];
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        
        UserModel* user = nil;
        if (json)
        {
            user = [[UserModel alloc] initFromJson:json];
        }
        
        [self performSelectorOnMainThread:@selector(getUserWithPositionCompleted:) withObject:user waitUntilDone:YES];
    });
}

- (void)getUserWithPositionCompleted:(UserModel*)user
{
    if (self.delegate)
    {
        [self.delegate getUserWithPositionCompleted:user];
    }
}

- (void)createUser:(NSString *)userName withPassword:(NSString *)password withFirstName:(NSString *)firstName withLastName:(NSString *)lastName withEmail:(NSString *)email
{
    NSString* encodedUserName = [userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* encodedFirstName = [firstName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* encodedLastName = [lastName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* encodedPassword = [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/CinguettioDataService.svc/CreateUser?userName=%@&password=%@&firstName=%@&lastName=%@&email=%@", encodedUserName, encodedPassword, encodedFirstName, encodedLastName, email];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        dataUrl];
        
        NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [self performSelectorOnMainThread:@selector(createUserCompleted:) withObject:result waitUntilDone:YES];
    });
}

- (void)createUserCompleted:(NSString*)result
{
    if (self.delegate)
    {
        if ([result isEqualToString:@"true"]) {
            [self.delegate createUserCompleted:YES];
        }
        else
        {
            [self.delegate createUserCompleted:NO];
        }
    }
}

- (void)updateProfile:(int)userID withFirstName:(NSString*)firstName withLastName:(NSString*)lastName withEmail:(NSString*)email withImageUrl:(NSString*)imageUrl
{
    NSString* encodedFirstName = [firstName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* encodedLastName = [lastName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* encodedEmail = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* encodedImageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/CinguettioDataService.svc/UpdateUserProfile?userId=%d&firstName=%@&lastName=%@&email=%@&imageUrl=%@",userID, encodedFirstName, encodedLastName, encodedEmail,encodedImageUrl];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        [NSData dataWithContentsOfURL:dataUrl];
        
        [self performSelectorOnMainThread:@selector(updateProfileCompleted:) withObject:nil waitUntilDone:YES];
    });

}

- (void)updateProfileCompleted:(NSString*)result
{
    if (self.delegate){

            [self.delegate updateProfileCompleted];
    }
}



- (void)updateUserPosition:(int)userId withLatitude:(double)latitude withLongitude:(double)longitude
{
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/CinguettioDataService.svc/UpdateUserPosition?userId=%d&latitude=%.8f&longitude=%.8f", userId, latitude, longitude];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        [NSData dataWithContentsOfURL:dataUrl];
    });
}

-(NSMutableArray*)getUsersFromData:(NSData*)data
{
    NSError* error;
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:kNilOptions
                     error:&error];
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:[json count]];
    for (NSDictionary* userData in json) {
        UserModel* user = [[UserModel alloc] initFromJson:userData];
        [result addObject:user];
    }
    
    return result;
}

- (void)getFriendsForUser:(int)userId from:(int)from to:(int)to
{
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/CinguettioDataService.svc/GetFriends?userid=%d&from=%d&to=%d", userId, from, to];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        dataUrl];
        
        NSMutableArray* result = [self getUsersFromData:data];
        
        [self performSelectorOnMainThread:@selector(getFriendsForUserCompleted:) withObject:result waitUntilDone:YES];
    });
}

- (void)getFriendsForUserCompleted:(NSMutableArray*)users
{
    if (self.delegate)
    {
        [self.delegate getFriendsForUserCompleted:users];
    }
}

- (void)searchUsers:(NSString *)data
{
    NSString* encodedData = [data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/CinguettioDataService.svc/SearchUsers?data=%@", encodedData];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        dataUrl];
        
        NSMutableArray* result = [self getUsersFromData:data];
        
        [self performSelectorOnMainThread:@selector(searchUsersCompleted:) withObject:result waitUntilDone:YES];
    });
}

- (void)searchUsersCompleted:(NSMutableArray*)users
{
    if (self.delegate)
    {
        [self.delegate searchUsersCompleted:users];
    }
}

- (void)areFriends:(int)userId friend:(int)friendId
{
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/CinguettioDataService.svc/AreFriends?userId=%d&friendId=%d", userId, friendId];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        dataUrl];
        
        NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [self performSelectorOnMainThread:@selector(areFriendsCompleted:) withObject:result waitUntilDone:YES];
    });
}

- (void)areFriendsCompleted:(NSString*)result
{
    if (self.delegate)
    {
        if ([result isEqualToString:@"true"]) {
            [self.delegate areFriendsCompleted:YES];
        }
        else
        {
            [self.delegate areFriendsCompleted:NO];
        }
    }
}

- (void)addFriend:(int)userId friend:(int)friendId
{
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/CinguettioDataService.svc/AddFriend?userId=%d&friendId=%d", userId, friendId];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        dataUrl];
        
        NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [self performSelectorOnMainThread:@selector(addFriendCompleted:) withObject:result waitUntilDone:YES];
    });
}

- (void)addFriendCompleted:(NSString*)result
{
    if (self.delegate)
    {
        if ([result isEqualToString:@"true"]) {
            [self.delegate addFriendCompleted:YES];
        }
        else
        {
            [self.delegate addFriendCompleted:NO];
        }
    }
}

- (void)removeFriend:(int)userId friend:(int)friendId
{
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/CinguettioDataService.svc/RemoveFriend?userId=%d&friendId=%d", userId, friendId];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        dataUrl];
        
        NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [self performSelectorOnMainThread:@selector(removeFriendCompleted:) withObject:result waitUntilDone:YES];
    });
}

- (void)removeFriendCompleted:(NSString*)result
{
    if (self.delegate)
    {
        if ([result isEqualToString:@"true"]) {
            [self.delegate removeFriendCompleted:YES];
        }
        else
        {
            [self.delegate removeFriendCompleted:NO];
        }
    }
}

-(void)getUsersInAreaLatitudeFrom:(double)latitudeFrom latitudeTo:(double)latitudeTo longitudeFrom:(double)longitudeFrom longitudeTo:(double)longitudeTo fiendsOnly:(BOOL)friendsOnly forUser:(int)userId
{
    NSString* friendsOnlyString = friendsOnly ? @"true" : @"false";
    
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/CinguettioDataService.svc/GetUsersInArea?latitudeFrom=%lf&latitudeTo=%lf&longitudeFrom=%lf&longitudeTo=%lf&friendsOnly=%@&userId=%d", latitudeFrom, latitudeTo, longitudeFrom, longitudeTo, friendsOnlyString, userId];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        dataUrl];
        
        NSMutableArray* result = [self getUsersFromData:data];
        
        [self performSelectorOnMainThread:@selector(getUsersInAreaCompleted:) withObject:result waitUntilDone:YES];
    });
}

- (void)getUsersInAreaCompleted:(NSMutableArray*)users
{
    if (self.delegate)
    {
        [self.delegate getUsersInAreaCompleted:users];
    }
}

- (void)uploadImage:(UIImage*)image withName:(NSString*)fileName withExtention:(NSString*)extention
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *urlString = @"http://cinguettiodataservice.somee.com/UploadImage.ashx";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.%@\"\r\n", fileName, extention] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[ [NSString stringWithFormat:@"Content-Type: image/%@\r\n\r\n", extention] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:imageData]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               [self uploadImageCompleted:returnString];
                           }];
}

- (void)uploadImageCompleted:(NSString*)url
{
    if (self.delegate)
    {
        [self.delegate uploadImageCompleted:url];
    }
}

- (void)getUsers:(int)from to:(int)to
{
    NSString* dataStringUrl = [NSString stringWithFormat:@"http://cinguettiodataservice.somee.com/CinguettioDataService.svc/GetUsers?from=%d&to=%d", from, to];
    NSURL* dataUrl = [NSURL URLWithString:dataStringUrl];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:dataUrl];
        
        NSMutableArray* result = [self getUsersFromData:data];
        
        [self performSelectorOnMainThread:@selector(getUsersCompleted:) withObject:result waitUntilDone:YES];
    });
}

- (void)getUsersCompleted:(NSMutableArray*)users
{
    if (self.delegate)
    {
        [self.delegate getUsersCompleted:users];
    }
}

@end
