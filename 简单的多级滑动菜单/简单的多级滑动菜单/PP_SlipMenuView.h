//
//  DD_SlipMenuView.h
//  简单的多级滑动菜单
//
//  Created by 小超人 on 16/9/19.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PP_SlipMenuView : UIView

// 初始话方法：
/*
 ParentVc:       你在哪个试图控制中使用
 childrenVc:     你要展示那些控制器的 View
 childrenTitles: 每一个展示的视图的标题（Button 的 Title）
 frame:          展示的位置
 numTitleOnePage:每一页显示几个标题（顶部Button）
 */
- (instancetype)initWithParentVc:(UIViewController *)parentVc
                      childrenVc:(NSArray<UIViewController *>*)childrenVc
                  childrenTitles:(NSArray<NSString *>*)titles
                           frame:(CGRect)frame
                  numTitleOnePage:(NSInteger)numTitleOnePage;


@end
