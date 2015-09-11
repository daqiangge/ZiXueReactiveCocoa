//
//  LQlogInRequest.h
//  自学reactivecocoa
//
//  Created by admin on 15/9/11.
//  Copyright (c) 2015年 蝶尚软件. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^loginRequestComplete)(BOOL);

@interface LQlogInRequest : NSObject

- (void)loginRequest:(NSString *)urlStr complete:(loginRequestComplete)complete;

@end
