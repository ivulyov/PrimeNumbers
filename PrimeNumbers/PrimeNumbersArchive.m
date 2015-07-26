//
//  PrimeNumbersArchive.m
//  PrimeNumbers
//
//  Created by Dmitry Ivulyov on 27.07.15.
//  Copyright (c) 2015 Dmitry Ivulyov. All rights reserved.
//

#import "PrimeNumbersArchive.h"

@implementation PrimeNumbersArchive

- (NSString *)primeNumbersArchivePath {
    NSString *documentsDirectory = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                            inDomains:NSUserDomainMask] lastObject] path];
    return [documentsDirectory stringByAppendingPathComponent:@"prime_numbers.dat"];
}

- (NSArray *)archivedNumbers {
    NSString *fileName = [self primeNumbersArchivePath];
    return [[NSArray alloc] initWithContentsOfFile:fileName];
}

- (void)updateArchiveWithNumbers:(NSArray *)numbers {
    NSString *fileName = [self primeNumbersArchivePath];
    NSArray *oldResultsArray = [[NSArray alloc] initWithContentsOfFile:fileName];
    if ([numbers count] > [oldResultsArray count]) {
        [numbers writeToFile:fileName atomically:YES];
    }
}

@end
