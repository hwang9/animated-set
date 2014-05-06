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
#import "Grid.h"

@interface CardGameViewController () <UIDynamicAnimatorDelegate>

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;


@property (nonatomic) Grid *cardsGrid;                       //grid to help position card buttons
@property (nonatomic) UIView *pile;                          //view of the pile
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;    //label to display the score

@end

@implementation CardGameViewController


// Update the UI whenever the view is loaded.
- (void)viewDidLoad
{
    [self updateUI];
}

// Update UI when orientation is changed.
- (void)viewDidLayoutSubviews
{
    [self updateUI];
}

// Lazy instantiator for the animator
- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        if (self.cardsView) {
            _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardsView];
            _animator.delegate = self;
        } else {
            NSLog(@"Tried to create an animator with no reference view.");
        }
    }
    return _animator;
}

// Creates a card button, adds it to our array, and returns the newly created button
- (UIView *)addCardButton
{
    UIView *cardButton = [self returnBlankButton];
    cardButton.frame = CGRectMake(0, 0, 0, 0);        //all new buttons start at the upper left corner
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCardButton:)];
    [cardButton addGestureRecognizer:tap];
    
    [self.cardButtons addObject:cardButton];
    return cardButton;
}

// Adds the pan and tap gestures for the pile view.
- (void)addGestures:(UIView *)pile
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [pile addGestureRecognizer:panGesture];
    [pile addGestureRecognizer:tapGesture];
}

// Lazy instantiator for the pile view. Create the button, add gesture recognizers, and return.
- (UIView *)pile
{
    if (!_pile) {
        _pile = [self returnBlankButton];
        [self addGestures:_pile];
    }
    return _pile;
}

// Lazy instantiator for the cardButtons array. Adds [self numCardsAtStart] cards to the array to begin with.
- (NSMutableArray *)cardButtons
{
    if (!_cardButtons) {
        _cardButtons = [[NSMutableArray alloc] init];
        for (int i=0; i<[self numCardsAtStart]; i++) {
            [self.cardsView addSubview:[self addCardButton]];
        }
    }
    return _cardButtons;
}

// Lazy instantiator for the cardsGrid grid. Sets bounds to our cardsView bounds and minimumNumberOfCells to the number of cards we start with. An aspect ratio of 2/3 seems to be appropriate for cards.
- (Grid *)cardsGrid
{
    if(!_cardsGrid) {
        _cardsGrid = [[Grid alloc] init];
        _cardsGrid.size = self.cardsView.bounds.size;
        _cardsGrid.cellAspectRatio = 0.66;
        _cardsGrid.minimumNumberOfCells = [self numCardsAtStart];
    }
    return _cardsGrid;
}


// Simple getter for the game property that includes lazy instantiation.
- (CardMatchingGame *)game
{
    if(!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self numCardsAtStart] usingDeck:[self createDeck]];
    }
    return _game;
}

// This method takes care of the resets needed when the Redeal button is pressed. It reinitializes the game and updates the UI.
- (IBAction)touchRedealButton {
    // Do not allow redeals when cards are in a pile
    if (self.isPile) return;
    
    for (UIView *button in self.cardButtons) {    //fade out all buttons on screen
        [UIView transitionWithView:button
                          duration:0.5
                           options:UIViewAnimationOptionCurveEaseOut
                        animations:^{
                            button.frame = CGRectMake(0, 0, 0, 0);
                        }
                        completion:^(BOOL finished){
                            [button removeFromSuperview];
                        }];
    }
    
    self.game = nil;
    self.cardsGrid = nil;
    self.cardButtons = nil;
    
    [self updateUI];
    
}

// Tap gesture recognizer for the card buttons.
- (IBAction)touchCardButton:(UITapGestureRecognizer *)sender
{
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender.view];
    
    [self.game chooseCardAtIndex:cardIndex];  //Calls on the model to handle algorithms
    
    [self updateUI];                          // Updates the UI
    
    // If we have enough cards for a match, remove the cards from game.cardsInPlay. If a match was not found, add the last card back in.
    if (self.game.shouldMatch) {
        self.game.cardsInPlay = nil;
        if (self.game.matchScore <= 0) {
            [self.game.cardsInPlay addObject:[self.game cardAtIndex:cardIndex]];
        }
    }
}

// Returns the appropriate frame for the button at index.
- (CGRect)getFrameAtIndex:(NSUInteger)index
{
    self.cardsGrid.minimumNumberOfCells = [self.game numCardsOnTable];
    self.cardsGrid.size = self.cardsView.bounds.size;
    NSUInteger colCount = [self.cardsGrid columnCount];
    
    return [self.cardsGrid frameOfCellAtRow:index/colCount inColumn:index%colCount];
}

// Updates the UI
- (void)updateUI
{
    for (UIView *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        
        // Move each button from where it is to where it should be.
        [UIView transitionWithView:cardButton
                          duration:0.5
                           options:UIViewAnimationOptionCurveEaseIn
                        animations:^{
                            cardButton.frame = [self getFrameAtIndex:cardIndex];
                        }
                        completion:nil];
        
        Card *card = [self.game cardAtIndex:cardIndex];
        
        // Updates the button in the subclasses.
        [self updateButton:cardButton inputCard:card];
        
        // Disable all gesture recognizers when card is matched.
        if (card.isMatched) cardButton.gestureRecognizers = nil;
    }
    
    // Updates scoreLabel
    self.scoreLabel.text = [NSString stringWithFormat:@"Score :%d", self.game.gameScore];
}

// Pinch gesture recognizer to put cards into a pile
- (IBAction)combineCardsOnPinch:(UIPinchGestureRecognizer *)sender {
    
    self.isPile = TRUE;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint center = [self.cardsView center];
        NSUInteger width = 60;
        NSUInteger height = 90;
        
        for (UIView *button in self.cardButtons) {
            width = button.frame.size.width;
            height = button.frame.size.height;
            
            // Move all buttons to the center of the screen and remove from cardsView when the animation is done.
            [UIView transitionWithView:button
                              duration:0.3
                               options:UIViewAnimationOptionCurveLinear
                            animations:^{
                                button.frame = CGRectMake(center.x - width/2, center.y - height/2, width, height);
                            }
                            completion:^(BOOL finished){
                                if (finished) [button removeFromSuperview];
                            }];
        }
        
        self.pile.frame = CGRectMake(center.x - width/2, center.y - height/2, width, height);
        
        // Draw the state of the first card (top of the pile) onto the pile
        Card *card = [self.game cardAtIndex:0];
        [self updateButton:self.pile inputCard:card];
        
        [self.cardsView addSubview:self.pile];
    }
}

// Handles the pan gesture of the pile
- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    CGPoint panPoint = [sender locationInView:self.cardsView];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.pile attachedToAnchor:panPoint];
        [self.animator addBehavior:self.attachment];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.attachment.anchorPoint = panPoint;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachment];
    }
}

// Handles the tap gesture of the pile
- (IBAction)handleTapGesture:(UITapGestureRecognizer *)sender
{
    CGPoint origin = self.pile.frame.origin;
    NSUInteger width = self.pile.frame.size.width;
    NSUInteger height = self.pile.frame.size.height;
    
    // Put all buttons back on the cardsView where the pile is
    for (UIView *button in self.cardButtons) {
        button.frame = CGRectMake(origin.x, origin.y, width, height);
        [self.cardsView addSubview:button];
    }
    
    [self.pile removeFromSuperview];
    self.pile = nil;
    self.isPile = FALSE;
    
    // Let updateUI move the buttons back to their proper positions
    [self updateUI];
}

#pragma mark - Abstract methods

// Different games have different decks. Keep this abstract.
- (Deck *)createDeck
{
    return nil;
}

// Different games start with different layouts. Keep this abstract.
- (NSUInteger)numCardsAtStart
{
    return 0;
}

// Returns a generic view for a card button. More specific games should override this.
- (UIView *) returnBlankButton
{
    return [[UIView alloc] init];
}

// Different games will update their buttons differently. Keep this abstract.
- (void)updateButton:(UIView *)cardButton inputCard:(Card *)card
{
    return;
}


@end
