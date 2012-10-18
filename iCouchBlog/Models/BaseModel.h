//
//  BaseModel.h
//  iCouchBlog
//
//  Created by Anna Lesniak on 9/2/12.
//  Copyright (c) 2012 Anna Lesniak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : CouchModel

+ (CouchDesignDocument *) design;
+ (CouchDesignDocument *) initDesignDocument;
+ (void) defineViews;
- (void) save;

@end
