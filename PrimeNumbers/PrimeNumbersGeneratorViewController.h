//
//  PrimeNumbersGeneratorViewController.h
//  PrimeNumbers
//
//  Created by Dmitry Ivulyov on 26.07.15.
//  Copyright (c) 2015 Dmitry Ivulyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrimeNumbersGeneratorViewController;

@protocol PrimeNumbersGeneratorViewControllerDelegate <NSObject>

- (void)primeNumbersGeneratorViewControllerDidStartGeneration:(PrimeNumbersGeneratorViewController *)controller;
- (void)primeNumbersGeneratorViewController:(PrimeNumbersGeneratorViewController *)controller didFinishWithResult:(NSArray *)result;

@end

@interface PrimeNumbersGeneratorViewController : UIViewController

@property (nonatomic, weak) id<PrimeNumbersGeneratorViewControllerDelegate> delegate;

@end
