//
//  MainViewController.m
//  PrimeNumbers
//
//  Created by Dmitry Ivulyov on 26.07.15.
//  Copyright (c) 2015 Dmitry Ivulyov. All rights reserved.
//

#import "MainViewController.h"

#import "PrimeNumbersGeneratorViewController.h"
#import "PrimeNumbersViewController.h"

@interface MainViewController () <PrimeNumbersGeneratorViewControllerDelegate>

@property (nonatomic, weak) PrimeNumbersViewController *numbersController;

@end

@implementation MainViewController

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LoadGenerator"]) {
        PrimeNumbersGeneratorViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"LoadPrimeNumbers"]) {
        PrimeNumbersViewController *controller = segue.destinationViewController;
        self.numbersController = controller;
    }
}

#pragma mark - PrimeNumbersGeneratorViewControllerDelegate

- (void)primeNumbersGeneratorViewController:(PrimeNumbersGeneratorViewController *)controller didFinishWithResult:(NSArray *)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.numbersController.numbers = result;
    });
}

@end
