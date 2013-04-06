//
//  Post.m
//  iCouchBlog
//
//  Created by Anna Lesniak on 8/26/12.
//  Copyright (c) 2012 Anna Lesniak. All rights reserved.
//

#import "Post.h"
#import "User.h"

@implementation Post

+ (void) defineFilters {
  [[DataStore currentDatabase] defineFilter: @"Post/for_user" asBlock: FILTERBLOCK({
    NSString *type = [revision.properties objectForKey: @"type"];
    NSString *userId = [params valueForKey: @"user_id"];
    NSString *docId = [revision.properties objectForKey: @"_id"];
    NSString *docUserId = [revision.properties objectForKey: @"user_id"];
    if (revision.isDeleted) {
      return YES;
    }
    if ([type isEqualToString: @"Post"] && [docUserId isEqualToString: userId]) {
      return YES;
    }
    if ([type isEqualToString: @"User"] && [docId isEqualToString: userId]) {
      return YES;
    }
    return NO;
  })];
}

- (id) init {
  self = [super init];
  if (self) {
    [self setValue: [[User current] documentID] ofProperty: @"user_id"];
  }
  return self;
}

@end
