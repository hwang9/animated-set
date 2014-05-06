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

- (UIView *) returnBlankButton
{
    return [[SetCardView alloc] init];
}

- (NSUInteger)numCardsAtStart
{
    return 12;
}


// Override the superclass's method by returning the proper images for the card when (un)chosen
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfronttint" : @"cardfront"];
}

- (void)updateUI
{
    if(self.game.shouldMatch && self.game.matchScore > 0) {
        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
        for (Card *card in self.game.cardsInPlay) {
            NSUInteger cardIndex = [self.game indexOfCard:card];
            __block UIView *button = [self.cardButtons objectAtIndex:cardIndex];
            [indexSet addIndex:cardIndex];
            [UIView transitionWithView:button duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                button.frame = CGRectMake(0, 0, 0, 0);
            } completion:^(BOOL finished) {
                if(finished) [button removeFromSuperview];
            }];
        }
        [self.cardButtons removeObjectsAtIndexes:indexSet];
        [self.game removeMatchedCards];
    }
    [super updateUI];
}


- (IBAction)addThreeCards:(UIButton *)sender {
    if (self.isPile || ![self.game drawThreeCards])
        return;
    else {
        for (int i=0; i < 3; i++) {
            __block UIView *button = [self addCardButton];
            [self.cardsView addSubview:button];
            [UIView transitionWithView:button duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                button.frame = [self getFrameAtIndex:([self.cardButtons count] - 1)];
            } completion:nil];
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
