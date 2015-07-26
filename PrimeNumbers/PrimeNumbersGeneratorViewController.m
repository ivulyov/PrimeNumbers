//
//  PrimeNumbersGeneratorViewController.m
//  PrimeNumbers
//
//  Created by Dmitry Ivulyov on 26.07.15.
//  Copyright (c) 2015 Dmitry Ivulyov. All rights reserved.
//

#import "PrimeNumbersGeneratorViewController.h"

#import "PrimeNumbersGenerator.h"
#import "PrimeNumbersArchive.h"

@interface PrimeNumbersGeneratorViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIButton *actionButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak) IBOutlet UITextField *limitField;

@property (nonatomic, strong) PrimeNumbersGenerator *primeNumberGenerator;
@property (nonatomic, strong) PrimeNumbersArchive *primeNumbersArchive;

@end

@implementation PrimeNumbersGeneratorViewController

static const int MaximumValue = 100000000; //Bigger values requires better primes number algorithm. Current algorithm takes too much memory. 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.primeNumbersArchive = [[PrimeNumbersArchive alloc] init];
    self.primeNumbersArchive.cachingEnabled = YES;
}

- (IBAction)handleActionButtonClick:(UIButton *)sender {
    if (self.primeNumberGenerator.isGenerating) {
        [self cancelGeneration];
    }
    else {
        [self startGeneration];
    }
    
    [self.limitField resignFirstResponder];
}

- (void)cancelGeneration {
    [self.primeNumberGenerator cancelGeneration];
    [self.actionButton setTitle:NSLocalizedString(@"Generate", @"Generate") forState:UIControlStateNormal];
    [self.activityIndicatorView stopAnimating];
}

- (void)startGeneration {
    [self.delegate primeNumbersGeneratorViewControllerDidStartGeneration:self];
    
    [self.activityIndicatorView startAnimating];
    [self.actionButton setTitle:NSLocalizedString(@"Cancel", @"Cancel") forState:UIControlStateNormal];
    
    NSInteger limit = [self.limitField.text integerValue];
    if ([[[self.primeNumbersArchive archivedNumbers] lastObject] integerValue] < limit) {
        self.primeNumberGenerator = [[PrimeNumbersGenerator alloc] initWithLimit:limit];
        [self.primeNumberGenerator generateWithCompletionBlock:^(NSArray *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self finishWithResult:result];
            });
        }];
    }
    else {
        NSArray *result = [[self.primeNumbersArchive archivedNumbers] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF < %@", @(limit)]];
        [self finishWithResult:result];
    }
}

- (void)finishWithResult:(NSArray *)result {
    [self.delegate primeNumbersGeneratorViewController:self didFinishWithResult:result];
    
    [self.activityIndicatorView stopAnimating];
    [self.actionButton setTitle:NSLocalizedString(@"Generate", @"Generate") forState:UIControlStateNormal];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self handleActionButtonClick:nil];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet *set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString *filteredString = [[string componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    return ([string isEqualToString:filteredString] && ([newString integerValue] <= MaximumValue));
}

@end
