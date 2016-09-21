//
//  DD_SlipMenuView.m
//  简单的多级滑动菜单
//
//  Created by 小超人 on 16/9/19.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "PP_SlipMenuView.h"
/**  宏定义 */
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define PPLog NSLog(@"当前的的方法名--->%s",__func__);


@interface PP_SlipMenuView ()
{
    
    NSInteger numOnePage; // 顶部展示的标题数量
}

@property (assign, nonatomic) NSInteger currentIndex;// 当前展示视图对应的下标
@property (strong, nonatomic) NSArray<UIViewController *> *childrenVc;// 子控制器
@property (strong, nonatomic) NSArray<NSString *> *titles; // 标题数组
@property (strong, nonatomic) UIViewController *parentVc;// 父控制器
@property (strong, nonatomic) UIPanGestureRecognizer *pan;// 手势
@property (strong, nonatomic) UIScrollView *titlesView;// 顶部
@property (strong, nonatomic) UIView *lineView; // 标题的下划线

@end

const float titleHH = 50.0f;
//const int numOnePage = 3;// 一页显示几个标题
// 定义一个滑动方向枚举
typedef enum : NSUInteger
{
    MoveDirectionLeft,
    MoveDirectionRight,
} MoveDirection;

@implementation PP_SlipMenuView

// 懒加载
- (NSArray<UIViewController *> *)childrenVc
{
    if (!_childrenVc)
    {
        _childrenVc = [NSArray new];
    }
    return _childrenVc;
}

- (instancetype)initWithParentVc:(UIViewController *)parentVc childrenVc:(NSArray<UIViewController *> *)childrenVc childrenTitles:(NSArray<NSString *> *)titles frame:(CGRect)frame numTitleOnePage:(NSInteger)numTitleOnePage
{
    // 给对应的属性赋值
    _childrenVc = childrenVc;
    _parentVc = parentVc;
    _titles = titles;
    numOnePage = numTitleOnePage;
    
    if (self = [super initWithFrame:frame])
    {
    // 处理视图控制器
        // 默认显示第一个控制器的内容
        _currentIndex = 0;
        [self insertSubview:_childrenVc[0].view atIndex:0];
       
    // pan手势处理切换
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panChangeVc:)];
        [self addGestureRecognizer:_pan];
        
    // 顶部控制菜单
        _titlesView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, kScreenW, titleHH + 20))];
        _titlesView.contentSize = CGSizeMake(kScreenW / numOnePage * _childrenVc.count, titleHH);
        _titlesView.backgroundColor = [UIColor whiteColor];
        _titlesView.bounces = NO;
        _titlesView.showsHorizontalScrollIndicator = NO;
        [self insertSubview:_titlesView atIndex:1];
        
    // 添加标题 Button
        [self addTittleButtons];
        // 对应的 Button 下面的划线
         _lineView = [[UIView alloc] initWithFrame:CGRectMake(_currentIndex * kScreenW / numOnePage, titleHH, kScreenW / numOnePage, 20)];
        _lineView.backgroundColor = [UIColor blackColor];
        [_titlesView addSubview:_lineView];
         
    }
    return self;
}

// 布局 Title Button 就是顶部菜单点击可以切换
/*
 根据页面的多少逐一创建 Button，
 tag 值为对应的下标加1000，这样便于我们根据对应的下标去找到对应的 Button
 依次设置在 ScroView 上的位置，并添加_titlesView（ScrollView 上面）
 */
- (void)addTittleButtons
{
    for (int i = 0; i < _childrenVc.count; i++)
    {
        UIButton *title = [UIButton buttonWithType:(UIButtonTypeCustom)];
        title.backgroundColor = [UIColor grayColor];
        [title setTitle:_titles[i] forState:(UIControlStateNormal)];
        if (i == _currentIndex)
        {
            [title.titleLabel setFont:[UIFont systemFontOfSize:24]];
            [title setTitleColor:[UIColor purpleColor ] forState:(UIControlStateNormal)];
            
        }else{
            [title.titleLabel setFont:[UIFont systemFontOfSize:17]];
            [title setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        }

        [title setTitleColor:[UIColor redColor] forState:(UIControlStateHighlighted)];
        [title addTarget:self action:@selector(chooseTitle:) forControlEvents:(UIControlEventTouchUpInside)];
        title.frame = CGRectMake(i * kScreenW / 3.0, 0, kScreenW / 3.0, titleHH);
        title.tag = 1000 + i;
        [_titlesView addSubview:title];
    }
}

// 点击标题的事件，切换页面到对应的页面
- (void)chooseTitle:(UIButton *)sender
{
    // 点击不是当前的标题才会去切换
    if (_currentIndex != sender.tag - 1000)
    {
       // 移除当前的
        [_childrenVc[_currentIndex].view removeFromSuperview];
    
        //  展示点击的 设置 Frame 很关键要  因为手势的时候回去修改  这里让其展示在整个屏幕上
        _childrenVc[sender.tag - 1000].view.frame = self.bounds;
        [self insertSubview:_childrenVc[sender.tag - 1000].view atIndex:0];
        _currentIndex = sender.tag - 1000;
    }
    // 移动下划线
    [self moveLineView];
}
// 移动下划线
- (void)moveLineView
{
    // 用手势滑动时候 我们既要移动下划线  也要把对应的 Button 的字体颜色大小改了
    for (UIView *view in _titlesView.subviews)
    {
        // 遍历找到 Button
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)view;
            if (button.tag == _currentIndex + 1000)
            {
                [button.titleLabel setFont:[UIFont systemFontOfSize:24]];
                [button setTitleColor:[UIColor purpleColor ] forState:(UIControlStateNormal)];
                
            }else{
                [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
                [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            }
        }
    }
    // 算好位置 动画调整到相应的位置
    [UIView animateWithDuration:0.1f animations:^{
        /*
          页面的宽度 / 一个页面展示的 Button 数 = Button 的宽度
         当前下划线的 x = 当前的下标 * Button 的宽度
         */
        _lineView.frame = CGRectMake(_currentIndex * kScreenW / numOnePage, titleHH, kScreenW / numOnePage, 20);
    }];
   
    /*
     下面的两个判断是一个展示的关键部分，我们可以根据自己的想法调整！
     1、当下划线的x 超过一个屏幕宽的时候，那么就是说明已经到了我们视线之外了，我们要调整_titlesView的偏移量使之能看见，我这里是让她保持在最右面！
     2、这个判断是当要展示的 Button 在左侧我们视线之外的时候，我们让_titlesView偏移量为 0让我们能看见（因为这里只有第一个会出现这样的情况）
     */
    if (_lineView.frame.origin.x >= kScreenW )
    {
        NSLog(@"走这个方法当前的下标%ld",_currentIndex);
        [_titlesView setContentOffset:CGPointMake( kScreenW / numOnePage * (_currentIndex +1 - numOnePage), 0) animated:YES];
    }
    if (_titlesView.contentOffset.x >= CGRectGetMaxX(_lineView.frame))
    {
        NSLog(@"左滑动 走这个方法当前的下标%ld",_currentIndex);
        [_titlesView setContentOffset:CGPointMake( kScreenW *0, 0) animated:YES];
    }
}


// 手势切换视图
- (void)panChangeVc:(UIPanGestureRecognizer *)pan
{
    
    // 向左滑 x 为负 向右滑 x 为正  （末位置 减 初始位置）
    CGPoint panOffSet = [pan translationInView:self];
    float changeX = panOffSet.x;
    
    // 获取 当前的视图位置
    CGRect frame = _childrenVc[_currentIndex].view.frame;
    
    // 清空手势的偏移量
    [_pan setTranslation:(CGPointZero) inView:self];
    
    // 处理左右视图
    float resulet = frame.origin.x + (changeX < 0 ? - DBL_EPSILON : DBL_EPSILON);
  ( resulet <=0 ) ?  [self leftScroll:changeX frame:frame] : [self rightScroll:changeX frame:frame] ;
    
}


// 左滑视图  出现右侧视图
- (void)leftScroll:(float)offX frame:(CGRect)frame
{
  
    if (_currentIndex == _childrenVc.count - 1)
    {
        NSLog(@"最后一个左滑 不处理");
        return;
    }
   
    float tempX = frame.origin.x + offX;
    if (_currentIndex == 0)
    {// 左滑动的时候不松手又往右滑动 在第一个视图的时候不允许 当然也可以设置成循环滚动  到最后一个
        tempX = tempX >=0 ? 0 :tempX;
    }
    
    // 移动当前的视图
    _childrenVc[_currentIndex].view.frame = CGRectMake(tempX, frame.origin.y, frame.size.width, frame.size.height);
    
    // 找到下一个页面
    UIView *subView = _childrenVc[_currentIndex + 1].view;
    
    // 设置 Frame 很关键  让他出现当前页面的右侧
    subView.frame = CGRectMake(tempX + frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
    
    if (![self.subviews containsObject:subView])
    {
        [self insertSubview:subView atIndex:0];
    }
    if (_pan.state == UIGestureRecognizerStateEnded)
    {// 手势停止的时候确定一下到底要展示哪一个页面
        MoveDirection result = tempX <= - kScreenW / 2 ? [self leftOut:_childrenVc[_currentIndex].view rightIn:subView] : [self leftIn:_childrenVc[_currentIndex].view  rightOut:subView];
        _currentIndex = result == MoveDirectionLeft ? _currentIndex + 1 : _currentIndex;
        [self moveLineView];// 调整 Button 文字和下划线
    }
}

- (MoveDirection)leftOut:(UIView *)leftView rightIn:(UIView *)rightView
{
   /*
    当手势结束的时候  左边的视图移除  右侧的视图占据整个屏幕
    */
    [UIView animateWithDuration:0.3f animations:^{
        leftView.frame = CGRectOffset(self.bounds, - kScreenW, 0);
        rightView.frame = self.bounds;
    } completion:^(BOOL finished) {
        [leftView removeFromSuperview];
    }];
    return MoveDirectionLeft;
}
- (MoveDirection)leftIn:(UIView *)leftView rightOut:(UIView *)rightView
{
    /*
     当手势结束的时候  左边的视图移除  右侧的视图占据整个屏幕
     */
    [UIView animateWithDuration:0.3f animations:^{
        rightView.frame = CGRectOffset(self.bounds, kScreenW, 0);
        leftView.frame = self.bounds;
    } completion:^(BOOL finished) {
       [rightView removeFromSuperview];
    }];
    return MoveDirectionRight;
}



// 右滑视图 出现左侧视图
- (void)rightScroll:(float)offX frame:(CGRect)frame
{
    
    if (_currentIndex == 0)
    {
        NSLog(@"第一个右滑 不处理");
        return;
    }
    
    float tempX = frame.origin.x + offX;
    if (_currentIndex == _childrenVc.count - 1)
    {
        tempX = tempX <=0 ? 0 :tempX;
    }

    // 移动当前的视图
    _childrenVc[_currentIndex].view.frame = CGRectMake(tempX, frame.origin.y, frame.size.width, frame.size.height);
    
    UIView *subView = _childrenVc[_currentIndex - 1].view;
    subView.frame = CGRectMake(tempX - frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
    
    if (![self.subviews containsObject:subView])
    {
         [self insertSubview:subView atIndex:0];
    }
    if (_pan.state == UIGestureRecognizerStateEnded)
    {
        MoveDirection result = tempX <=  kScreenW / 2 ? [self leftOut:subView rightIn:_childrenVc[_currentIndex].view] : [self leftIn:subView  rightOut:_childrenVc[_currentIndex].view];
        _currentIndex = result == MoveDirectionLeft ? _currentIndex : _currentIndex - 1;
       [self moveLineView];
    }

}









@end
