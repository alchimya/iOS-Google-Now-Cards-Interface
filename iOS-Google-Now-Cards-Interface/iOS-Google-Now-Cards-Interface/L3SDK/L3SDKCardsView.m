//
//  L3SDKCardsView.m
//  Parallax
//
//  Created by Domenico Vacchiano on 01/04/15.
//  Copyright (c) 2015 LamCube. All rights reserved.
//

#import "L3SDKCardsView.h"
#define CARD_X_MARGIN   20
#define CARD_Y_MARGIN   10

@interface L3SDKCardsView ()
    @property (nonatomic,assign) UISwipeGestureRecognizerDirection gestureDirection;
    @property (nonatomic,assign)CGPoint gestureStartPoint;
    @property (nonatomic,assign)UIView*gestureView;
    @property (nonatomic,assign)CGRect zeroFrame;
@end


@implementation L3SDKCardsView

@synthesize cards;
@synthesize subViews;
@synthesize delegate;

-(void)addCard:(L3SDKCard*)card{

    if (!cards) {
        cards=[[NSMutableArray alloc]initWithCapacity:10];
    }
    [cards addObject:card];
    [self addSubview:card];
}


- (void)drawRect:(CGRect)rect {
    
    self.zeroFrame=self.frame;
    [super drawRect:rect];
    [self setupHeight];
    
    
}

-(void)addSubviewAtBottom:(UIView *)view{
    
    
    if (!subViews) {
        subViews=[[NSMutableArray alloc]initWithCapacity:10];
    }
    [subViews addObject:view];
    [self addSubview:view];
   
    
}


-(void)setupHeight{

    int height=0;
    

    //cards loop
    for (int i=0; i<self.cards.count; i++) {
        L3SDKCard*card=[self.cards objectAtIndex:i];
        card.frame=CGRectMake(
                              card.frame.origin.x,
                              height, self.frame.size.width-CARD_X_MARGIN, card.frame.size.height);
        card.center = CGPointMake(self.frame.size.width / 2, card.center.y+CARD_Y_MARGIN);
        height+=card.frame.size.height+CARD_Y_MARGIN;
    }
    //additional views loop
    for (int i=0; i<self.subViews.count; i++) {
        UIView*view=[self.subViews objectAtIndex:i];
        view.frame=CGRectMake(
                              view.frame.origin.x,
                              height, self.frame.size.width-CARD_X_MARGIN, view.frame.size.height);
        view.center = CGPointMake(self.frame.size.width / 2, view.center.y+CARD_Y_MARGIN);
        height+=view.frame.size.height+CARD_Y_MARGIN;
    }

    
    if (self.cards.count==0 && self.subViews.count!=0) {
        //if the are not cards but there are subviews, sets the start height equal to the view height
        UIView*firstSubView=(UIView*)[self.subViews objectAtIndex:0];
        self.frame=CGRectMake(
                              self.frame.origin.x,
                              self.superview.frame.size.height-firstSubView.frame.size.height-(CARD_Y_MARGIN*2),
                              self.frame.size.width,
                              firstSubView.frame.size.height+CARD_Y_MARGIN);
    }else{
        self.frame=CGRectMake(
                              self.frame.origin.x,
                              self.frame.origin.y,
                              self.frame.size.width, height);
    }

 
    
}


-(id)initWithFrame:(CGRect)frame{


    self=[super initWithFrame:frame];
    if (self) {
        [self drawRect:frame];
    }
    return self;
    
}
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    //set start touch point
    self.gestureStartPoint = [touch locationInView:self];
    //get view from touch
    self.gestureView = [self hitTest:self.gestureStartPoint withEvent:event];
    
}

-(UISwipeGestureRecognizerDirection)getGestureDirectionWithTouch:(UITouch*)touch {
    
    CGPoint gestureEndPoint = [touch locationInView:self];
    int dx = abs(self.gestureStartPoint.x - gestureEndPoint.x);
    int dy = -1 * (gestureEndPoint.y - self.gestureStartPoint.y);

    if(dx > 20) {
        // too much left/right, so don't do anything
        return UISwipeGestureRecognizerDirectionRight;
    }
    
    if(dy < 0) {
        // they moved down
        return UISwipeGestureRecognizerDirectionDown;
    }else if(dy > 0) {
        // they moved down
        return UISwipeGestureRecognizerDirectionUp;
    }
    
    return -1;
}
-(BOOL)canScroll:(UISwipeGestureRecognizerDirection)scrollDirection{
    

    if(scrollDirection==UISwipeGestureRecognizerDirectionUp && self.frame.origin.y<0) {
        //UP scrolling
        if (fabs(self.frame.origin.y)>=self.frame.size.height-self.superview.frame.size.height) {
            //scroll will stop when last bottom view is at bottom margin
            if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(L3SDKCardsView_OnUpperLimitReached)]) {
                [self.delegate L3SDKCardsView_OnUpperLimitReached];
            }
            return NO;
        }

    }else if(scrollDirection==UISwipeGestureRecognizerDirectionDown  && self.frame.origin.y>0) {
        //DOWN
        if (fabs(self.frame.origin.y)>=self.zeroFrame.origin.y ) {
            //scroll will stop when first view is on the initial frame y
            if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(L3SDKCardsView_OnBottomLimitReached)]) {
                [self.delegate L3SDKCardsView_OnBottomLimitReached];
            }
            return NO;
        }
    }
    
    //avoid vertical scoll if is not required (content of view < of height view)
    if (self.frame.size.height<self.superview.frame.size.height && (self.frame.origin.y>=self.zeroFrame.origin.y)) {
        return NO;
    }

    return YES;
    
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{

    UITouch *touch = [touches anyObject];
    CGPoint gestureEndPoint = [touch locationInView:self];
    
    //gets gesture direction
    self.gestureDirection=[self getGestureDirectionWithTouch:touch];
    BOOL canScroll=[self canScroll:self.gestureDirection];
    //send event
    if (canScroll) {
        if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(L3SDKCardsView_OnScrolling:)]) {
            [self.delegate L3SDKCardsView_OnScrolling:self.gestureDirection];
        }
    }

    if ((self.gestureDirection==UISwipeGestureRecognizerDirectionUp |self.gestureDirection==UISwipeGestureRecognizerDirectionDown) && canScroll) {
        //scroll containter view
        self.frame = CGRectOffset(self.frame,
                                  (0),
                                  (gestureEndPoint.y - self.gestureStartPoint.y));

        
    }else if (self.gestureDirection==UISwipeGestureRecognizerDirectionLeft | self.gestureDirection==UISwipeGestureRecognizerDirectionRight) {
        if ([self.gestureView isEqual:self]) {
            return;
        }
        //swipe card
        gestureEndPoint = [touch locationInView:self.gestureView];
        self.gestureView.frame = CGRectOffset(self.gestureView.frame,
                                         (gestureEndPoint.x - self.gestureStartPoint.x),
                                         (0));
        if (self.gestureView.alpha>0.4) {
            self.gestureView.alpha=self.gestureView.alpha-0.03;
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touchesEnded");
    
    
    if (![self.gestureView isEqual:self]) {
        //we are swiping a card
        float x=self.gestureView.frame.origin.x;
        if (fabs(x)>self.frame.size.width/2){
            //card will be deleted when x is greater than half width view
            [self.gestureView removeFromSuperview];
            [self.cards removeObject:self.gestureView];
            [self setupHeight];
            if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(L3SDKCardsView_OnCardRemoved:)]) {
                [self.delegate L3SDKCardsView_OnCardRemoved:(L3SDKCard*)self.gestureView];
            }
            if (self.cards.count==0) {
                if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(L3SDKCardsView_OnAllCardRemoved)]) {
                    [self.delegate L3SDKCardsView_OnAllCardRemoved];
                }
            }
        }else{
            //card will be positioned at the orginila position
            L3SDKCard*card=(L3SDKCard*)self.gestureView;
            self.gestureView.frame=card.zeroFrame;
            self.gestureView.alpha=1.0;
        }
    }

    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touchesCancelled");
}


@end
