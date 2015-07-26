//
//  UIViewController+HUD.m
//  PrimeNumbers
//
//  Created by Dmitry Ivulyov on 27.07.15.
//  Copyright (c) 2015 Dmitry Ivulyov. All rights reserved.
//

#import "UIViewController+HUD.h"

#import "MBProgressHUD.h"

@implementation UIViewController (HUD)

- (void)showHUDWithText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (text) {
        hud.labelText = text;
    }
    self.view.userInteractionEnabled = NO;
}
- (void)hideHUD {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.view.userInteractionEnabled = YES;
}

@end
