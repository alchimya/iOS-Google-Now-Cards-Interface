//
//  ViewController.m
//  iOS-Google-Now-Cards-Interface
//
//  Created by Domenico Vacchiano on 02/04/15.
//  Copyright (c) 2015 LamCube. All rights reserved.
//

#import "ViewController.h"
#import "L3SDKCardsView.h"
#import "L3SDKCard.h"

@interface ViewController ()
//see links on Main.storyboard
@property (nonatomic,strong)IBOutlet UIView*headerView;
@property (nonatomic,strong)IBOutlet L3SDKCardsView*containerView;
@property (nonatomic,strong)UIButton*moreButton;
-(void)addCards;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCards];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    //if you want to add cards here, you have to use the drawView method
    //[self addCards:YES];
}
-(void)addCards{
   [self addCards:NO];
}
-(void)addCards:(BOOL)drawView{
    
    //sets delegate
    self.containerView.delegate=self;
    
    //card setup
    //NOTE It's needed to specify only the height of the card
    L3SDKCard*card;
    //card1
    card=[[L3SDKCard alloc]initWithFrame:CGRectMake(0, 0, 0, 100)];
    [self.containerView addCard:card withOptions:L3SDKCardOptionsIsSwipeableCard];
    
    //card2
    card=[[L3SDKCard alloc]initWithFrame:CGRectMake(0, 0, 0, 150)];
    [self.containerView addCard:card withOptions:L3SDKCardOptionsIsSwipeableCard];
    
    //card3
    card=[[L3SDKCard alloc]initWithFrame:CGRectMake(0, 0, 0, 80)];
    [self.containerView addCard:card withOptions:L3SDKCardOptionsIsSwipeableCard];
    //card4
    card=[[L3SDKCard alloc]initWithFrame:CGRectMake(0, 0, 0, 120)];
    [self.containerView addCard:card withOptions:L3SDKCardOptionsIsSwipeableCard];
    //card5
    card=[[L3SDKCard alloc]initWithFrame:CGRectMake(0, 0, 0, 220)];
    [self.containerView addCard:card withOptions:L3SDKCardOptionsIsSwipeableCard];
    
    
    //add a view (UIButton) at bottom
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.containerView.frame.size.width, 40)];
    [self.moreButton setTitle:@"More" forState:UIControlStateNormal];
    self.moreButton.backgroundColor=[UIColor whiteColor];
    [self.moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.moreButton.titleLabel.font= [UIFont italicSystemFontOfSize:16.0f];
    [self.containerView addCard:self.moreButton];
    
    if (drawView) {
        [self.containerView drawView];
    }
    
}
-(CGFloat)getAlphaHeader{
    //calculate alpha by a containteview current y and "original" y
    return self.containerView.frame.origin.y/self.containerView.zeroFrame.origin.y;
}
//////////////////////////////////////////////////////////////////////////////////
//EVENTS
#pragma mark - L3SDKCardsView_ events delegate
- (void)L3SDKCardsView_Scrolling:(UISwipeGestureRecognizerDirection)scrollDirection{
    self.headerView.alpha=[self getAlphaHeader];
}
- (void)L3SDKCardsView_CardWillRemove:(UIView*)view{
    NSLog(@"card will remove");
}
- (void)L3SDKCardsView_CardDidlRemove:(UIView*)view{
    NSLog(@"card did remove");
    self.headerView.alpha=[self getAlphaHeader];
}
- (void)L3SDKCardsView_AllCardRemoved{
    self.headerView.alpha=1;
}
- (void)L3SDKCardsView_UpperLimitReached{
    self.headerView.alpha=0;
}
- (void)L3SDKCardsView_BottomLimitReached{
    self.headerView.alpha=1;
}

//////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
