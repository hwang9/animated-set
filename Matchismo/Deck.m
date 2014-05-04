//
//  Deck.m
//  Matchismo
//
//  Created by Henry Wang on 4/3/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import "Deck.h"

@interface Deck()

@property (nonatomic, strong) NSMutableArray *cards;

@end

@implementation Deck

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

// Adds the card passed in at the top of the deck if the atTop flag is set, otherwise added at the bottom.
- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
}

// Adds the card at the bottom of the deck.
- (void)addCard:(Card *)card
{
    [self addCard:card atTop:NO];
}

// Draws a random card.
- (Card *)drawRandomCard
{
    Card *randomCard = nil;
    
    if([self.cards count]) {
        int index = arc4random()%[self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    
    return randomCard;
}

@end
