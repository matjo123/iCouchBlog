//
//  User.m
//  iCouchBlog
//
//  Created by Anna Lesniak on 10/16/12.
//  Copyright (c) 2012 Anna Lesniak. All rights reserved.
//

#import "User.h"
#import "Post.h"
#import "AppDelegate.h"

static User *currentUser;

@implementation User

+ (void) defineFilters {}

+ (User *) current {
  NSString *email = [User emailFromSettings];
  if (email) {
    currentUser = [User findByEmail: email];
  }
  return currentUser;
}

+ (User *) findByEmail: (NSString *) anEmail {
  CBLQuery *query = [[[DataStore currentDatabase] viewNamed: UserByEmailView] query];
  query.keys = @[anEmail];
  NSDictionary *values = [[query.rows nextRow] value];
  if (values) {
    return [User modelForDocumentWithId: [values objectForKey: @"_id"]];
  } else {
    return nil;
  }
}

- (NSString *) documentID {
  return [[[User current] document] documentID];
}

- (void) addPost: (Post *) post {
  NSString *postId = [[post document] documentID];
  NSMutableArray *posts = [NSMutableArray arrayWithArray: [self getValueOfProperty: @"post_ids"]];
  if (![posts containsObject: postId]) {
    [posts addObject: postId];
    [self setValue: posts ofProperty: @"post_ids"];
  }
  
  NSError *error;
  [self save: &error];
}


+ (NSString *) emailFromSettings {
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  return [settings objectForKey: UserEmailSettingsKey];
}

+ (User *) createWith: (NSDictionary *) hash {
  NSLog(@"HASH: %@", hash);
  NSMutableDictionary *properties = [NSMutableDictionary dictionary];
  
  [properties setValue: @"User" forKey: @"type"];
  
  for (NSString *property in @[@"email", @"post_ids", @"created_at", @"updated_at"]) {
    [properties setValue: [hash valueForKey: property] forKey: property];
  }
  
  NSString *userId = [hash valueForKey: @"_id"];
  CBLDocument* doc = [[DataStore currentDatabase] documentWithID: userId];
  NSError* error;
  [doc putProperties: properties error: &error];

  User *user = [User findByEmail: [properties valueForKey: @"email"]];
  NSLog(@"USER %@", user);
  return user;
}

- (BOOL) login {
  NSString *email = [self getValueOfProperty: @"email"];
  
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  [settings setObject: email forKey: UserEmailSettingsKey];
  [settings synchronize];
  
  return [User current] != nil;
}

- (void) logout {
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  [settings removeObjectForKey: UserEmailSettingsKey];
  [settings synchronize];
}

@end
