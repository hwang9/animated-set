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
- (UIView *)returnBlankButton;
- (void)updateButton:(UIView *)cardButton inputCard:(Card *)card;

- (UIView *)addCardButton;
- (CGRect) getFrameAtIndex:(NSUInteger)index;
- (void)updateUI;

@property (nonatomic, strong) CardMatchingGame *game;    //instance of the model
@property (weak, nonatomic) IBOutlet UIView *cardsView;  //the view where the buttons will live
@property (nonatomic) NSMutableArray *cardButtons;       //array of card buttons
@property (nonatomic) BOOL isPile;                       //true if we currently have a pile

@end
