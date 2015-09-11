//
//  LQViewController1.m
//  自学reactivecocoa
//
//  Created by admin on 15/9/11.
//  Copyright (c) 2015年 蝶尚软件. All rights reserved.
//

#import "LQViewController1.h"
#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LQViewController1 ()

@property (nonatomic, strong) ViewController *vc;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation LQViewController1

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.vc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2];
    
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         [self changeMyViewBackgroundColor];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeMyViewBackgroundColor
{
    [self.vc changeMyViewBackgroundColor:^(UIView *vv) {
        vv.backgroundColor = [UIColor redColor];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
