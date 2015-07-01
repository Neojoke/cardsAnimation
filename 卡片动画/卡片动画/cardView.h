//
//  cardView.h
//  卡片动画
//
//  Created by Neo on 15/6/27.
//  Copyright (c) 2015年 KuBao. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface cardView : UIView
@property(nonatomic)IBInspectable UIColor * bgColor;
@property(nonatomic)IBInspectable CGFloat cornerRadius;
@property(nonatomic)IBInspectable CGFloat buttonConnerRadius;
@property(nonatomic)IBInspectable UIColor * tapColor1;
@property(nonatomic)IBInspectable UIColor * tapColor2;
@property(nonatomic)IBInspectable CGSize circleSize;
@property(nonatomic)IBInspectable CGSize shadowSize;
-(void)config;
@end
