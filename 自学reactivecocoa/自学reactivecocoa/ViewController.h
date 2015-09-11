//
//  ViewController.h
//  自学reactivecocoa
//
//  Created by admin on 15/9/11.
//  Copyright (c) 2015年 蝶尚软件. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^changeMyViewBackgroundColor)(UIView *);


@interface ViewController : UIViewController

- (void)changeMyViewBackgroundColor:(changeMyViewBackgroundColor)changeMyViewBackgroundColor;

@end

