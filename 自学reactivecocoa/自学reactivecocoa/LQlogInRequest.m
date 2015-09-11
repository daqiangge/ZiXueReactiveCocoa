//
//  LQlogInRequest.m
//  自学reactivecocoa
//
//  Created by admin on 15/9/11.
//  Copyright (c) 2015年 蝶尚软件. All rights reserved.
//

#import "LQlogInRequest.h"

@implementation LQlogInRequest

- (void)loginRequest:(NSString *)urlStr complete:(loginRequestComplete)complete
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL success = YES;
        complete(success);
    });
}

@end
