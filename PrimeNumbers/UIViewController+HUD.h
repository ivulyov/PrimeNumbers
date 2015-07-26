//
//  UIViewController+HUD.h
//  PrimeNumbers
//
//  Created by Dmitry Ivulyov on 27.07.15.
//  Copyright (c) 2015 Dmitry Ivulyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

- (void)showHUDWithText:(NSString *)text;
- (void)hideHUD;

@end
