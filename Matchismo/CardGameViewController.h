//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Henry Wang on 4/3/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

// abstract methods:
- (Deck *)createDeck;
- (NSUInteger)numCardsAtStart;
- (NSAttributedString *)attTitleForCard:(Card *)card;
- (UIImage *)backgroundImageForCard:(Card *)card;

- (void)updateUI;

@property (nonatomic, strong) CardMatchingGame *game;

@end
