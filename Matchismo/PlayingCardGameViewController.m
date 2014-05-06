//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Henry Wang on 4/10/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

// Overrides the superclass's method by creating an appropriate deck of playing cards.
- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

// Creates a specific button for the Set game
- (UIView *) returnBlankButton
{
    return [[PlayingCardView alloc] init];
}

- (NSUInteger)numCardsAtStart
{
    return 16;
}

// Overrides the superclass's method by providing the correct values for the card
- (void)updateButton:(UIView *)cardButton inputCard:(Card *)card
{
    PlayingCardView * currentCardButton = ((PlayingCardView *)cardButton);
    PlayingCard * currentCard = ((PlayingCard *)card);
    
    //If the button is in play and was just chosen, do a flip animation
    if ([self.game.cardsInPlay containsObject:card] && currentCardButton.faceUp != card.isChosen) {
        [UIView transitionWithView:currentCardButton
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            currentCardButton.rank = currentCard.rank;
                            currentCardButton.suit = currentCard.suit;
                            currentCardButton.faceUp = card.isChosen;
                            
                            if (card.isMatched) cardButton.alpha = 0.4;
                            
                            [currentCardButton setNeedsDisplay];
                        }
                        completion:nil];
    }
    //else, just update the fields and display
    else {
        currentCardButton.rank = currentCard.rank;
        currentCardButton.suit = currentCard.suit;
        currentCardButton.faceUp = card.isChosen;
        
        if (card.isMatched) cardButton.alpha = 0.4;
        
        [currentCardButton setNeedsDisplay];
    }
}

@end
