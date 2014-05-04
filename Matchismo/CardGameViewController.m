//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Henry Wang on 4/3/14.
//  Copyright (c) 2014 Henry. All rights reserved.
//
//  Image Sources:
//  Cardback:http://www.creationdunproduitinnovant.com/blog/wp-content/uploads/2008/12/stanford_university_hoover_tower.jpg
//  AppIcon:http://ms.ahsd.org/teachers/brunom/cards.png
//  LaunchIcon: "http://fierceandnerdy.com/wp-content/uploads/2009/01/deckofcards.jpg"
//

#import "CardGameViewController.h"
#import "CardGameHistoryViewController.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

// This label prints whether the face-up cards are a match or not, as well as the points given to or taken away from the player.
@property (weak, nonatomic) IBOutlet UILabel *matchingLabel;

// This array saves the matchingLabel outputs as the game progresses to work with the history view.
@property (nonatomic) NSMutableArray *matchingLabelHistory;


@end

@implementation CardGameViewController


// Update the UI whenever the view is loaded.
- (void)viewDidLoad
{
    [self updateUI];
}

// Makes preparations when the History bar button item is pushed. Sends the history of all (mis)matches to the destination view controller.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CardGameHistoryViewController *historyView = segue.destinationViewController;
    historyView.cardMatchingHistory = self.matchingLabelHistory;
}


// Simple getter for the game property that includes lazy instantiation.
- (CardMatchingGame *)game
{
    if(!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    }
    return _game;
}

// Simple getter for matchingLabelHistory that includes lazy instantiation.
- (NSMutableArray *)matchingLabelHistory
{
    if(!_matchingLabelHistory) _matchingLabelHistory = [[NSMutableArray alloc] init];
    return _matchingLabelHistory;
}

// This method takes care of the resets needed when the Redeal button is pressed. It reinitializes the game and updates the UI.
- (IBAction)touchRedealButton {
    _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    
    self.matchingLabelHistory = nil;
    
    [self updateUI];
    
}

// This method takes care of the actions required when a user turns over a card.
- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    
    [self.game chooseCardAtIndex:cardIndex];
    
    Card *card = [self.game cardAtIndex:cardIndex];
    
    // Updates the UI
    BOOL shouldKeepCardInPlay = [self updateUI];
    
    // If we have a mismatch, we should keep the most recent card faceup and in play.
    if (shouldKeepCardInPlay)
        [self.game.cardsInPlay addObject:card];
}

// This method updates the UI and returns a boolean value to let the touchCardButton method know whether it should keep the most recent card or not.
- (BOOL)updateUI
{
    BOOL shouldKeepCardInPlay = FALSE;
    
    // Updates every button on the screen
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        [cardButton setAttributedTitle:[self attTitleForCard:card] forState:UIControlStateNormal];
        
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        
        cardButton.enabled = card.isMatched ? NO : YES;
    }
    
    // Updates scoreLabel
    self.scoreLabel.text = [NSString stringWithFormat:@"Score :%d", self.game.gameScore];
    
    // If we have enough cards to match, build the appropriate string for matchingLabel
    if (self.game.shouldMatch) {
        
        NSMutableAttributedString *attStr;
        
        // Begins matchingLabel with an appropriate prefix and the cards in play.
        if (self.game.matchScore > 0)
            attStr = [[NSMutableAttributedString alloc] initWithString:@"Matched "];
        else
            attStr = [[NSMutableAttributedString alloc] initWithString:@""];
        
        [attStr appendAttributedString:[self getCardsInPlay]];
        
        // The cards in play have all been marked already, so clear this array.
        self.game.cardsInPlay = nil;
        
        // Add to matchingLabel with the appropriate success/failure message.
        NSString *tmp;
        NSAttributedString *attTmp;
        
        if (self.game.matchScore > 0) {
            tmp = [NSString stringWithFormat:@" for %d points!", self.game.matchScore];
            attTmp = [[NSMutableAttributedString alloc] initWithString:tmp];
        }
        else {
            tmp = [NSString stringWithFormat:@" don't match! %d point penalty!", self.game.matchScore*(-1)];
            attTmp = [[NSMutableAttributedString alloc] initWithString:tmp];
            
            // Since we don't have a matching, we should update cardsInPlay to include our last one.
            shouldKeepCardInPlay = TRUE;
        }
        
        [attStr appendAttributedString:attTmp];
        
        // Updates the matching label
        self.matchingLabel.attributedText = attStr;
        
        // Add this (mis)match output to our matchingLabelHistory array.
        [self.matchingLabelHistory addObject:[self.matchingLabel.attributedText copy]];
        
    }
    // If we don't have enough cards to match, simply output the cards currently in play.
    else
        self.matchingLabel.attributedText = [self getCardsInPlay];
    
    return shouldKeepCardInPlay;
}

// This method returns a concatenation of the names of the cards that are currently in play.
- (NSAttributedString *)getCardsInPlay
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
    for (Card *card in self.game.cardsInPlay) {
        [attStr appendAttributedString:[self buildCardAttString:card]];
    }
    return attStr;
}


// Different games have different decks. Keep this abstract.
- (Deck *)createDeck
{
    return nil;
}

// Different games will want to express their titles differently. Keep this abstract.
- (NSAttributedString *)attTitleForCard:(Card *)card
{
    return nil;
}

// Different games will have different card names. Keep this abstract.
- (NSAttributedString *)buildCardAttString:(Card *)card
{
    return nil;
}

// Different games will require different background images. Keep this abstract.
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return nil;
}


@end
