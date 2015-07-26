//
//  SessionsViewController.m
//  PrimeNumbers
//
//  Created by Dmitry Ivulyov on 26.07.15.
//  Copyright (c) 2015 Dmitry Ivulyov. All rights reserved.
//

#import "SessionsViewController.h"

#import "Session.h"

#import "PrimeNumbersViewController.h"
#import "PrimeNumbersArchive.h"

@interface SessionsViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation SessionsViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    
    [self setupFetchedResultsController];
}

- (void)setupFetchedResultsController {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Session class])];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO]]];
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                 managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
                                                                                            cacheName:nil];
    controller.delegate = self;
    self.fetchedResultsController = controller;
    NSError *error;
    [controller performFetch:&error];
    if (error) {
        NSLog(@"error fetching sessions");
    }
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return _dateFormatter;
}

- (Session *)objectAtIndexPath:(NSIndexPath *)indexPath {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[indexPath.section];
    return [sectionInfo objects][indexPath.row];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"SessionCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Session *session = [self objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", [self.dateFormatter stringFromDate:session.startDate],
                           [self.dateFormatter stringFromDate:session.endDate]];
    cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Maximum value: %@", @"Maximum value: %@"), session.maximumValue ? session.maximumValue : @"-"];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LoadSession"]) {
        PrimeNumbersViewController *controller = segue.destinationViewController;
        Session *session = [self objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        NSNumber *maximumValue = session.maximumValue;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            PrimeNumbersArchive *archive = [[PrimeNumbersArchive alloc] init];
            NSArray *numbers = [archive archivedNumbers];
            controller.numbers = [numbers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF <= %@", maximumValue]];
        });
    }
}

@end
