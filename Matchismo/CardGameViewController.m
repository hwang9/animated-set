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


@property (nonatomic) Grid *cardsGrid;
@property (nonatomic) UIView *pile;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation CardGameViewController


// Update the UI whenever the view is loaded.
- (void)viewDidLoad
{
    [self updateUI];
}

- (void)viewDidLayoutSubviews
{
    [self updateUI];
}

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

- (UIView *)addCardButton
{
    //UIButton *cardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIView *cardButton = [self returnBlankButton];
    cardButton.frame = CGRectMake(0, 0, 0, 0);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCardButton:)];
    [cardButton addGestureRecognizer:tap];
    [self.cardButtons addObject:cardButton];
    return cardButton;
}

- (UIView *) returnBlankButton
{
    return nil;
}


- (UIView *)pile
{
    if (!_pile) {
        _pile = [self returnBlankButton];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [_pile addGestureRecognizer:panGesture];
        [_pile addGestureRecognizer:tapGesture];
    }
    return _pile;
}

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

- (void)addGestures:(UIView *)pile
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [pile addGestureRecognizer:panGesture];
    [pile addGestureRecognizer:tapGesture];
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
    if (self.isPile) return;
    for (UIView *button in self.cardButtons) {
        [UIView transitionWithView:button duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            button.frame = CGRectMake(0, 0, 0, 0);
        } completion:^(BOOL finished){
            [button removeFromSuperview];
        }];
    }
    self.game = nil;
    self.cardsGrid = nil;
    self.cardButtons = nil;
    
    [self updateUI];
    
}
- (IBAction)touchCardButton:(UITapGestureRecognizer *)sender
{
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender.view];
    
    [self.game chooseCardAtIndex:cardIndex];
    
    // Updates the UI
    [self updateUI];
    
    if (self.game.shouldMatch) {
        self.game.cardsInPlay = nil;
        if (self.game.matchScore <= 0) {
            [self.game.cardsInPlay addObject:[self.game cardAtIndex:cardIndex]];
        }
    }
}

- (CGRect)getFrameAtIndex:(NSUInteger)index
{
    self.cardsGrid.minimumNumberOfCells = [self.game numCardsOnTable];
    self.cardsGrid.size = self.cardsView.bounds.size;
    NSUInteger colCount = [self.cardsGrid columnCount];
    return [self.cardsGrid frameOfCellAtRow:index/colCount inColumn:index%colCount];
}

// This method updates the UI and returns a boolean value to let the touchCardButton method know whether it should keep the most recent card or not.
- (void)updateUI
{
    for (UIView *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        [UIView transitionWithView:cardButton duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            cardButton.frame = [self getFrameAtIndex:cardIndex];
        } completion:nil];
        
        Card *card = [self.game cardAtIndex:cardIndex];
        
        [self updateButton:cardButton inputCard:card];
        
        if (card.isMatched) cardButton.gestureRecognizers = nil;
        
        //[cardButton setAttributedTitle:[self attTitleForCard:card] forState:UIControlStateNormal];
        
        //[cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        
        //cardButton.enabled = card.isMatched ? NO : YES;
    }
    
    // Updates scoreLabel
    self.scoreLabel.text = [NSString stringWithFormat:@"Score :%d", self.game.gameScore];
}

- (void)updateButton:(UIView *)cardButton inputCard:(Card *)card
{
}

- (IBAction)combineCardsOnPinch:(UIPinchGestureRecognizer *)sender {
    
    self.isPile = TRUE;
    if (sender.state == UIGestureRecognizerStateBegan) {
        __block CGPoint center = [self.cardsView center];
        __block NSUInteger width = 60;
        __block NSUInteger height = 90;
        for (UIView *button in self.cardButtons) {
            width = button.frame.size.width;
            height = button.frame.size.height;
            [UIView transitionWithView:button duration:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
                button.frame = CGRectMake(center.x - width/2, center.y - height/2, width, height);
            }completion:^(BOOL finished){
                if (finished) [button removeFromSuperview];
            }];
        }
        self.pile.frame = CGRectMake(center.x - width/2, center.y - height/2, width, height);
        
        Card *card = [self.game cardAtIndex:0];
        
        [self updateButton:self.pile inputCard:card];
        
        //[self.pile setAttributedTitle:[self attTitleForCard:card] forState:UIControlStateNormal];
        
        //[self.pile setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        [self.cardsView addSubview:self.pile];
    }
}


- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    CGPoint panPoint = [sender locationInView:self.cardsView];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self attachPileToPoint:panPoint];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.attachment.anchorPoint = panPoint;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachment];
        //self.cardsView.path = nil;
    }
}

- (void)attachPileToPoint:(CGPoint)anchorPoint
{
    if (self.pile) {
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.pile attachedToAnchor:anchorPoint];
        UIView *pile = self.pile;
        //self.pile = nil;
        __weak CardGameViewController *weakSelf = self;
        self.attachment.action = ^{
            UIBezierPath *path = [[UIBezierPath alloc] init];
            [path moveToPoint:weakSelf.attachment.anchorPoint];
            [path addLineToPoint:pile.center];
            //weakSelf.cardsView.path = path;
        };
        [self.animator addBehavior:self.attachment];
    }
}

- (IBAction)handleTapGesture:(UITapGestureRecognizer *)sender
{
    CGPoint origin = self.pile.frame.origin;
    NSUInteger width = self.pile.frame.size.width;
    NSUInteger height = self.pile.frame.size.height;
    for (UIView *button in self.cardButtons) {
        button.frame = CGRectMake(origin.x, origin.y, width, height);
        [self.cardsView addSubview:button];
    }
    [self.pile removeFromSuperview];
    self.pile = nil;
    self.isPile = FALSE;
    [self updateUI];
}

// Different games have different decks. Keep this abstract.
- (Deck *)createDeck
{
    return nil;
}

- (NSUInteger)numCardsAtStart
{
    return 0;
}

// Different games will want to express their titles differently. Keep this abstract.
- (NSAttributedString *)attTitleForCard:(Card *)card
{
    return nil;
}


// Different games will require different background images. Keep this abstract.
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return nil;
}


@end
