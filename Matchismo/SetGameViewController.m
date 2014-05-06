//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Henry Wang on 4/22/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetDeck.h"
#import "SetCard.h"
#import "SetCardView.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController



// Override the superclass's method by calling alloc/init on the proper deck
- (Deck *)createDeck
{
    return [[SetDeck alloc] init];
}

// Creates a specific button for the Set game
- (UIView *) returnBlankButton
{
    return [[SetCardView alloc] init];
}

// Number of cards at the start of the game
- (NSUInteger)numCardsAtStart
{
    return 12;
}

// If three cards are matched, we should remove them from the screen before calling the generic updateUI function.
- (void)updateUI
{
    if(self.game.shouldMatch && self.game.matchScore > 0) {
        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];  //set of indices to remove
        
        for (Card *card in self.game.cardsInPlay) {
            
            NSUInteger cardIndex = [self.game indexOfCard:card];
            __block UIView *button = [self.cardButtons objectAtIndex:cardIndex];
            [indexSet addIndex:cardIndex];
            
            [UIView transitionWithView:button
                              duration:0.5
                               options:UIViewAnimationOptionCurveEaseOut
                            animations:^{
                                button.frame = CGRectMake(0, 0, 0, 0);      //cards shrink into the top left corner
                            }
                            completion:^(BOOL finished) {       //remove cards from the view when animation is done

                                if(finished) [button removeFromSuperview];
                            }];
        }
        
        [self.cardButtons removeObjectsAtIndexes:indexSet];
        [self.game removeMatchedCards];
    }
    [super updateUI];
}

// If the "Add 3 Cards!" button is pressed, add the cards into the view and update the UI.
- (IBAction)addThreeCards:(UIButton *)sender {
    
    if (self.isPile || ![self.game drawThreeCards])
        return;              //Don't do anything if cards are in a pile or if we've exhausted our deck.
    
    else {
        for (int i=0; i < 3; i++) {
            __block UIView *button = [self addCardButton];
            [self.cardsView addSubview:button];
            
            [UIView transitionWithView:button
                              duration:0.5
                               options:UIViewAnimationOptionCurveEaseIn
                            animations:^{               //ease cards into their proper position.
                                button.frame = [self getFrameAtIndex:([self.cardButtons count] - 1)];
                            }
                            completion:nil];
        }
    }
    [super updateUI];
}

// Overrides the superclass's method by providing the correct values for the card
- (void)updateButton:(UIView *)cardButton inputCard:(Card *)card
{
    
    
    SetCardView * currentCardButton = ((SetCardView *)cardButton);
    SetCard * currentCard = ((SetCard *)card);
    currentCardButton.number = currentCard.number;
    currentCardButton.symbol = currentCard.symbol;
    currentCardButton.shading = currentCard.shading;
    currentCardButton.color = currentCard.color;
    currentCardButton.chosen = currentCard.chosen;
    
    [currentCardButton setNeedsDisplay];
}


@end
