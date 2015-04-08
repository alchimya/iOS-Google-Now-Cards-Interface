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
    @property (nonatomic,strong)NSMutableArray*cardsOptions;
    @property (nonatomic,assign)CGRect superviewFrame;
@end


@implementation L3SDKCardsView
@synthesize cards;
@synthesize delegate;
@synthesize zeroFrame;
@synthesize cardWidth;

#pragma mark - Init


- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    [self drawView];
    
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
    
    if(self){
        self.backgroundColor = [UIColor clearColor];
        cards=[[NSMutableArray alloc]initWithCapacity:10];
        self.cardsOptions=[[NSMutableArray alloc]initWithCapacity:10];
    }
    
    return self;
}


#pragma mark - Public Methods


-(void)addCard:(UIView*)card{
    [self addCard:card withOptions:-1];
}
-(void)addCard:(UIView*)card withOptions:(L3SDKCardOptions)options{
    [cards addObject:card];
   
    [self.cardsOptions addObject:[[NSValue alloc]  initWithBytes:&options objCType:@encode(L3SDKCardOptions)]];
    [self addSubview:card];
}
-(void)drawView{
    self.superviewFrame=self.superview.frame;
    self.zeroFrame=self.frame;
    [self setupHeight];
    [self setNeedsDisplay];
}
-(CGFloat)getCardWidth{
    return self.frame.size.width-CARD_X_MARGIN;;
}

#pragma mark - Card Layout
-(void)setupHeight{
    
    //height of container cards view
    int height=0;
    //y of container cards view
    CGFloat y=self.frame.origin.y;
    
    //views loop
    for (int i=0; i<self.cards.count; i++) {
        UIView*card=[self.cards objectAtIndex:i];
        card.frame=CGRectMake(
                              card.frame.origin.x,
                              height,
                              self.cardWidth,
                              card.frame.size.height);
        card.center = [self getCardCenter:card andXOffset:0 andYOffset:CARD_Y_MARGIN];
        height+=card.frame.size.height+CARD_Y_MARGIN;

    }
    
    
    //Note:If self.frame.origin.y<0 we will scroll down the view
    //This behavior will be useful when we are removing a card
    if (self.frame.origin.y<0) {
        if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(L3SDKCardsView_Scrolling:)]) {
            [self.delegate L3SDKCardsView_Scrolling:UISwipeGestureRecognizerDirectionDown];
        }
    }
    
    if (self.cards.count==1 && ![self viewCanSwipe:[self.cards objectAtIndex:0]] ) {
        //if there is only one view move the container at the bottom line
        y=self.superviewFrame.size.height-((UIView*)[self.cards objectAtIndex:0]).frame.size.height-(CARD_Y_MARGIN*2);
    }
    
    self.frame=CGRectMake(
                          self.frame.origin.x,
                          self.frame.origin.y<0 ? self.frame.origin.y+self.gestureView.frame.size.height :y,
                          self.frame.size.width,
                          height);
    
}





#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touchesBegan");
    UITouch *touch = [touches anyObject];
    
    
    //set start touch point
    self.gestureStartPoint = [touch locationInView:self];
    //get view from touch
    self.gestureView = [self hitTest:self.gestureStartPoint withEvent:event];

}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    //NSLog(@"touchesMoved");
    UITouch *touch = [touches anyObject];
    CGPoint gestureEndPoint = [touch locationInView:self];
    
    

    //gets gesture direction
    self.gestureDirection=[self getGestureDirectionWithTouch:touch];

    BOOL canScroll=[self canScroll:self.gestureDirection];
    //send event
    if (canScroll) {
        if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(L3SDKCardsView_Scrolling:)]) {
            [self.delegate L3SDKCardsView_Scrolling:self.gestureDirection];
        }
    }

    if ((self.gestureDirection==UISwipeGestureRecognizerDirectionUp |self.gestureDirection==UISwipeGestureRecognizerDirectionDown) && canScroll) {

        
        //scroll containter view
        self.frame = CGRectOffset(self.frame,
                                  (0),
                                  (gestureEndPoint.y - self.gestureStartPoint.y));

        
    }else if (self.gestureDirection==UISwipeGestureRecognizerDirectionLeft | self.gestureDirection==UISwipeGestureRecognizerDirectionRight) {
        //exit if view is self or is view can't swipe
        if ([self.gestureView isEqual:self] | ![self viewCanSwipe:self.gestureView]) {
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
            if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(L3SDKCardsView_CardWillRemove:)]) {
                [self.delegate L3SDKCardsView_CardWillRemove:self.gestureView];
            }
            
            [self removeView:self.gestureView];

            if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(L3SDKCardsView_CardDidlRemove:)]) {
                [self.delegate L3SDKCardsView_CardDidlRemove:self.gestureView];
            }
            
            if (self.cards.count==0) {
                if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(L3SDKCardsView_AllCardRemoved)]) {
                    [self.delegate L3SDKCardsView_AllCardRemoved];
                }
            }
        }else{
            //card will be positioned at the orginila position
            self.gestureView.center = [self getCardCenter:self.gestureView];
            self.gestureView.alpha=1.0;
        }
    }

    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touchesCancelled");
}

#pragma mark - Touch Utility
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
        if (fabs(self.frame.origin.y)>=self.frame.size.height-self.superviewFrame.size.height) {
            //scroll will stop when last bottom view is at bottom margin
            if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(L3SDKCardsView_UpperLimitReached)]) {
                [self.delegate L3SDKCardsView_UpperLimitReached];
            }
            return NO;
        }
        
    }else if(scrollDirection==UISwipeGestureRecognizerDirectionDown  && self.frame.origin.y>0) {
        //DOWN
        if (fabs(self.frame.origin.y)>=self.zeroFrame.origin.y ) {
            //scroll will stop when first view is on the initial frame y
            if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(L3SDKCardsView_BottomLimitReached)]) {
                [self.delegate L3SDKCardsView_BottomLimitReached];
            }
            return NO;
        }
    }

    
    //avoid vertical scoll if is not required (content of view < of height view)
    if ((self.frame.size.height + self.frame.origin.y)<self.superviewFrame.size.height && (self.frame.origin.y>=self.zeroFrame.origin.y)) {
        return NO;
    }
    

    return YES;
    
}


#pragma mark - Card Utility
-(int)getIndexOfView:(UIView*)view{
    return [self.cards indexOfObject:view];
}
-(void)removeView:(UIView*)view{
    
    int index=[self getIndexOfView:view];
    [self.gestureView removeFromSuperview];
    [self.cards removeObject:self.gestureView];
    [self.cardsOptions removeObjectAtIndex:index];
    [self setupHeight];
    
}
-(L3SDKCardOptions) getOptionsForView:(UIView*)view{
    int index=[self getIndexOfView:view];
    
    NSValue*value=[self.cardsOptions objectAtIndex:index];
    L3SDKCardOptions ret;
    [value getValue:&ret];
    
    
    return ret;
}
-(BOOL)viewCanSwipe:(UIView*)view{
    
    L3SDKCardOptions options=[self getOptionsForView:view];
    if (options==L3SDKCardOptionsIsSwipeableCard) {
        return YES;
    }
    return NO;

}
-(CGPoint)getCardCenter:(UIView*)card {
    return [self getCardCenter:card andXOffset:0 andYOffset:0];
}
-(CGPoint)getCardCenter:(UIView*)card andXOffset:(int)xOffset andYOffset:(int)yOffset{
    return CGPointMake(
                       (self.frame.size.width / 2)+xOffset,
                       card.center.y+yOffset
                       );
}

@end
