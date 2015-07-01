//
//  ViewController.m
//  卡片动画
//
//  Created by Neo on 15/6/23.
//  Copyright (c) 2015年 KuBao. All rights reserved.
//

#import "ViewController.h"
#import <POP.h>
#import "circleView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "cardView.h"
#import <QuartzCore/QuartzCore.h>
#define sizePercent 0.1
@interface ViewController ()
@property(nonatomic,strong)NSMutableArray * cards;
@property(nonatomic)NSUInteger currentIndex;
@property(nonatomic)NSUInteger initialLocation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = 0;
    self.cards = [[NSMutableArray alloc]init];
    [self showCardZone];
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandle:)];
    [self.view addGestureRecognizer:pan];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
  
}
-(void)panHandle:(UIPanGestureRecognizer *)pan{
    CGPoint location = [pan locationInView:self.view];
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.initialLocation = location.x;
        cardView * cardView = [[[NSBundle mainBundle]loadNibNamed:@"cardView" owner:self options:nil]firstObject];
        cardView.frame = CGRectMake(0, 0, 300, 400);
        [cardView config];
        cardView.hidden = YES;
        [self.view addSubview:cardView];
        [self.view insertSubview:cardView belowSubview:[self.cards firstObject]];
        [self setScaleWithScalePercent:1-(self.cards.count-0)*sizePercent Duration:0.25f Card:cardView];
        [self setCenter:CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2+150-20-(sizePercent*0*400)) Duration:0.25 Card:cardView Index:0];
        [self.cards insertObject:cardView atIndex:0];
        return;
    }
    cardView * card = self.cards[self.cards.count-1];
    CGPoint transLcation = [pan translationInView:self.view];
    card.center = CGPointMake(card.center.x+transLcation.x, card.center.y+transLcation.y);
    CGFloat XOffPercent = (card.center.x-CGRectGetWidth(self.view.bounds)/2)/(CGRectGetWidth(self.view.bounds)/2);
    CGFloat scalePercent =1-fabs(XOffPercent)*0.3;
    CGFloat rotation = M_PI_2/4*XOffPercent;
    [self setScaleWithScalePercent:scalePercent Duration:0.0001f Card:card];
    [self setRorationWithAngle:rotation Duration:0.001f Card:card];
    [pan setTranslation:CGPointZero inView:self.view];
    for (int i =1; i<self.cards.count-1; i++) {
        CGFloat percent = fabs(XOffPercent);
        if (percent>1) {
            percent = 1;
        }
        cardView * subCard = self.cards[i];
        [self setScaleWithScalePercent:1-(sizePercent*(self.cards.count-1-i)-sizePercent*fabs(percent)) Duration:0.0001f Card:subCard];
        CGPoint subCardCenter = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2+150-20-sizePercent*400*(i-1+(fabs(percent))));
        NSLog(@"%@",[NSNumber numberWithFloat:XOffPercent]);
        [self setCenter:subCardCenter Duration:0.0001f Card:subCard Index:i];
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (card.center.x>60&&card.center.x<CGRectGetWidth(self.view.bounds)-60) {
            cardView * firstView = [self.cards firstObject];
            [firstView removeFromSuperview];
            [self.cards removeObjectAtIndex:0];
            [self cardReCenterOrDismiss:NO Card:card];
        }
        else
        {
            [self cardReCenterOrDismiss:YES Card:card];
            
        }
    }
}

-(void)showCardZone{
    for (int i = 0; i<4; i++) {
        cardView * card = [[[NSBundle mainBundle]loadNibNamed:@"cardView" owner:self options:nil] firstObject];
        card.frame = CGRectMake(0, 0, 300, 400);
        [card config];
        [self setScaleWithScalePercent:(1-sizePercent*(3-i)) Duration:0.0001 Card:card];
        CGPoint targetCenter = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2+150-20-(sizePercent*i*400));
        [self setCenter:targetCenter Duration:0.1f Card:card Index:i];
        card.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2-10*i+50);
        [self.view addSubview:card];
        [self.cards addObject:card];
        self.currentIndex = i;
    }
}
-(void)setCenter:(CGPoint)center Duration:(CGFloat)duration Card:(cardView *)card Index:(NSUInteger)index{
    POPBasicAnimation * bAni = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    bAni.toValue = [NSValue valueWithCGPoint:center];
    bAni.duration = duration;
    [bAni setCompletionBlock:^(POPAnimation *ani, BOOL is) {
        if (is) {
            card.hidden = NO;
        }
    }];
    [card pop_addAnimation:bAni forKey:@"center"];
}
-(void)setScaleWithScalePercent:(CGFloat) percent Duration:(CGFloat)duration Card:(cardView *)card{
    POPBasicAnimation * bAni = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    bAni.toValue = [NSValue valueWithCGSize:CGSizeMake(percent, percent)];
    bAni.duration = duration;
    [card.layer pop_addAnimation:bAni forKey:@"123"];
}
-(void)setRorationWithAngle:(CGFloat)angele Duration:(CGFloat)duration Card:(cardView *)card{
    POPBasicAnimation * bAni = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    bAni.duration = duration;
    bAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bAni.toValue = [NSNumber numberWithFloat:angele];
    [card.layer pop_addAnimation:bAni forKey:@"213"];
}
-(void)cardReCenterOrDismiss:(BOOL)isDismiss Card:(cardView *)card{
    if (isDismiss) {
        [self setRorationWithAngle:0 Duration:0.25 Card:card];
        if (card.center.x<CGRectGetWidth(self.view.bounds)/2) {
            [self setCenter:CGPointMake(0-150, card.center.y) Duration:0.25f Card:card Index:0];
        }
        else
        {
            [self setCenter:CGPointMake(CGRectGetWidth(self.view.bounds)+card.bounds.size.width/2,card.center.y) Duration:0.25f Card:card Index:0];
        }
        [self performSelector:@selector(cardRemove:) withObject:card afterDelay:0.25];
    }
    else
    {
        [self setScaleWithScalePercent:1 Duration:0.25f Card:card];
        [self setRorationWithAngle:0 Duration:0.25 Card:card];
        CGPoint targetCenter = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2+150-20-(sizePercent*3*400));
        [self setCenter:targetCenter Duration:0.25 Card:card Index:3];
        [self performSelector:@selector(cardRemove:) withObject:nil afterDelay:0.25];

    }
    
}
-(void)cardRemove:(cardView *)card{
    if (card) {
        [card removeFromSuperview];
        [self.cards removeObject:card];
    }
    for (int i = 0; i<self.cards.count; i++) {
        cardView * subCard = self.cards[i];
        [self setScaleWithScalePercent:(1-sizePercent*(self.cards.count-1-i)) Duration:0.0001 Card:subCard];
        CGPoint targetCenter = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2+150-20-(sizePercent*i*400));
        [self setCenter:targetCenter Duration:0.1f Card:subCard Index:i];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
