//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Henry Wang on 4/8/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer (any subclass calling super initializer will call this one)
- (instancetype)initWithCardCount:(NSUInteger)cardCount
                        usingDeck:(Deck *)Deck;

// The following two public method signatures are unchanged from lecture.
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (NSUInteger)numCardsOnTable;

// Keeps track of the overall score
@property (nonatomic, readonly) int gameScore;

// Keeps track of the points given in one matching to help the controller update the output
@property (nonatomic, readonly) int matchScore;

// Keeps track of whether we should look for a matching or not. Also helps the controller update the output
@property (nonatomic) BOOL shouldMatch;

// Keeps track of the current cards in play (chosen but not matched). It's used to keep track of whether a matching decision should be made as well as which cards the matchingLabel should print.
@property (nonatomic) NSMutableArray *cardsInPlay;

// Current deck.
@property (nonatomic) Deck *deck;


@end
