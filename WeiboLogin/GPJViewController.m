//
//  GPJViewController.m
//  WeiboLogin
//
//  Created by 巩 鹏军 on 12/29/13.
//  Copyright (c) 2013 Gong Pengjun. All rights reserved.
//

#import "GPJViewController.h"

@interface GPJViewController ()

@end

@implementation GPJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:0 target:self action:@selector(back)];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
