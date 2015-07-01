//
//  circleView.h
//  卡片动画
//
//  Created by Neo on 15/6/23.
//  Copyright (c) 2015年 KuBao. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface circleView : UIView
@property(nonatomic)IBInspectable UIColor * lineColor;
-(void)setCircleStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated;
@end
