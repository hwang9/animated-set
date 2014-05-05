//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Henry Wang on 4/8/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, strong) NSMutableArray *cards; //of Card
@property (nonatomic, readwrite) int gameScore;
@property (nonatomic, readwrite) int matchScore;

@end

@implementation CardMatchingGame

static const int MATCH_BONUS = 4;
// This constant is now negative to better reflect the differences between matches and mismatches.
static const int MISMATCH_PENALTY = -2;
static const int COST_TO_CHOOSE = 1;

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

// Simple getter for cardsInPlay that includes lazy instantiation
- (NSMutableArray *)cardsInPlay
{
    if (!_cardsInPlay) _cardsInPlay = [[NSMutableArray alloc] init];
    return _cardsInPlay;
}

// Contains the logic for choosing a card at the index passed in. Similar to the method written in lecture, but an array of all cards in play is first constructed, then match is called with all these cards at once.
- (void)chooseCardAtIndex:(NSUInteger)index
{
    NSMutableArray *otherCards = [[NSMutableArray alloc] init];
    Card *card = [self cardAtIndex:index];
    
    // Let the game know that it should calculate a matching score only if we have enough faceup cards.
    if ([self.cardsInPlay count] == [card numOtherCardsToMatch])
        self.shouldMatch = TRUE;
    else
        self.shouldMatch = FALSE;
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            [self.cardsInPlay removeObject:card];
            self.shouldMatch = FALSE;
        } else {
            if (self.shouldMatch) {
                // Construct our array of otherCards first
                for (Card *otherCard in self.cards) {
                    if(otherCard.isChosen && !otherCard.isMatched)
                    {
                        [otherCards addObject:otherCard];
                    }
                }
                
                // Call match on all our cards.
                self.matchScore = [card match:otherCards];
                
                if (self.matchScore) {
                    self.matchScore *= MATCH_BONUS;
                    self.gameScore += self.matchScore;
                    card.matched = YES;
                    // Update all other cards in play.
                    for (Card *otherCard in otherCards) {
                        otherCard.matched = YES;
                    }
                } else {
                    self.matchScore = MISMATCH_PENALTY;
                    self.gameScore += self.matchScore;
                    // Update all other cards in play.
                    for (Card *otherCard in otherCards) {
                        otherCard.chosen = NO;
                    }
                }
            }
            card.chosen = YES;
            [self.cardsInPlay addObject:card];
            self.gameScore -= COST_TO_CHOOSE;
        }
    }
}

- (NSUInteger)numCardsOnTable
{
    return [self.cards count];
}

// The following methods have not been changed from lecture.
- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}


- (instancetype)initWithCardCount:(NSUInteger)cardCount
                        usingDeck:(Deck *)deck
{
    self = [super init];
    
    self.deck = deck;
    if (self && cardCount >= 2) {
        for (int i=0; i < cardCount; i++) {
            Card *card = [self.deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (instancetype)init
{
    return nil;
}

@end
