//
//  L3SDKCardsView.h
//  Parallax
//
//  Created by Domenico Vacchiano on 01/04/15.
//  Copyright (c) 2015 LamCube. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSUInteger, L3SDKCardOptions) {
    L3SDKCardOptionsIsSwipeableCard = 1 << 0
};


@protocol L3SDKCardsViewDelegate <NSObject>
@optional
- (void)L3SDKCardsView_Scrolling:(UISwipeGestureRecognizerDirection)scrollDirection;
- (void)L3SDKCardsView_CardWillRemove:(UIView*)view;
- (void)L3SDKCardsView_CardDidlRemove:(UIView*)view;
- (void)L3SDKCardsView_AllCardRemoved;
- (void)L3SDKCardsView_UpperLimitReached;
- (void)L3SDKCardsView_BottomLimitReached;
@end


@interface L3SDKCardsView : UIView
@property (nonatomic,assign)IBOutlet id<L3SDKCardsViewDelegate> delegate;
@property (readonly,nonatomic,strong)NSMutableArray*cards;
@property (nonatomic,assign)CGRect zeroFrame;
@property (nonatomic,assign) CGFloat cardWidth;
-(void)addCard:(UIView*)card;
-(void)addCard:(UIView*)card withOptions:(L3SDKCardOptions)options;
-(void)drawView;
@end
