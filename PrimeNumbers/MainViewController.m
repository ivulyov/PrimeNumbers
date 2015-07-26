//
//  MainViewController.m
//  PrimeNumbers
//
//  Created by Dmitry Ivulyov on 26.07.15.
//  Copyright (c) 2015 Dmitry Ivulyov. All rights reserved.
//

#import "MainViewController.h"

#import "PrimeNumbersGeneratorViewController.h"
#import "SessionsViewController.h"

#import "DataStoreConfiguration.h"
#import "Session.h"

#import "PrimeNumbersArchive.h"

@interface MainViewController () <PrimeNumbersGeneratorViewControllerDelegate>

@property (nonatomic, strong) DataStoreConfiguration *dataStoreConfiguration;

@property (nonatomic, strong) NSDate *startGenerationDate;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (DataStoreConfiguration *)dataStoreConfiguration {
    if (!_dataStoreConfiguration) {
        _dataStoreConfiguration = [[DataStoreConfiguration alloc] init];
    }
    return _dataStoreConfiguration;
}

- (void)saveResults:(NSArray *)results withStartDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    Session *session = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Session class])
                                                     inManagedObjectContext:self.dataStoreConfiguration.managedObjectContext];
    session.startDate = startDate;
    session.endDate = endDate;
    session.maximumValue = [results lastObject];
    NSError *error;
    [self.dataStoreConfiguration.managedObjectContext save:&error];
    if (error) {
        NSLog(@"error saving session %@", error);
    }
    
    PrimeNumbersArchive *archive = [[PrimeNumbersArchive alloc] init];
    [archive updateArchiveWithNumbers:results];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LoadGenerator"]) {
        PrimeNumbersGeneratorViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"LoadSessions"]) {
        SessionsViewController *controller = segue.destinationViewController;
        controller.managedObjectContext = self.dataStoreConfiguration.managedObjectContext;
    }
}

#pragma mark - PrimeNumbersGeneratorViewControllerDelegate

- (void)primeNumbersGeneratorViewControllerDidStartGeneration:(PrimeNumbersGeneratorViewController *)controller {
    self.startGenerationDate = [NSDate date];
}

- (void)primeNumbersGeneratorViewController:(PrimeNumbersGeneratorViewController *)controller didFinishWithResult:(NSArray *)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self saveResults:result withStartDate:self.startGenerationDate endDate:[NSDate date]];
    });
}

@end
