//
//  CardGameHistoryViewController.m
//  Matchismo
//
//  Created by Henry Wang on 4/23/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import "CardGameHistoryViewController.h"

@interface CardGameHistoryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation CardGameHistoryViewController

// Update the UI whenever our view is loaded
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

// Go through the matching outputs one by one, printing each out on a separate line
- (void)updateUI
{
    NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] init];
    for (NSAttributedString *attStr in self.cardMatchingHistory) {
        [mutableAttStr appendAttributedString:attStr];
        [mutableAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    self.textView.attributedText = mutableAttStr;
}


@end
