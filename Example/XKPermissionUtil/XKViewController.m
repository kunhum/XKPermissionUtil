//
//  XKViewController.m
//  XKPermissionUtil
//
//  Created by kunhum on 09/18/2018.
//  Copyright (c) 2018 kunhum. All rights reserved.
//

#import "XKViewController.h"
#import "XKPermissionUtil.h"

@interface XKViewController ()

@end

@implementation XKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [XKPermissionUtil xk_checkAddressbookStatus:^(BOOL result, CNAuthorizationStatus authStatus) {
        if (authStatus == CNAuthorizationStatusDenied) {
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
