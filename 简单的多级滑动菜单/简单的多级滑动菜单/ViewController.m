//
//  ViewController.m
//  简单的多级滑动菜单
//
//  Created by 小超人 on 16/9/19.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "ViewController.h"
#import "PP_SlipMenuView.h"
#import "TableViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *vc1 = [UIViewController new];
    vc1.view.backgroundColor = [UIColor redColor];
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = [UIColor yellowColor];
    UIViewController *vc3 = [UIViewController new];
    vc3.view.backgroundColor = [UIColor greenColor];
    UIViewController *vc4 = [UIViewController new];
    vc4.view.backgroundColor = [UIColor greenColor];
    TableViewController *vc5 = [TableViewController new];
    
    
    
    NSMutableArray *arraVc = [NSMutableArray new];
    NSMutableArray *arraTitle = [NSMutableArray new];
    for (int i = 0 ; i <= 10 ; i++)
    {
        UIViewController *vc = [UIViewController new];
        vc.view.backgroundColor = [UIColor colorWithRed:(arc4random()%173)/346.0 + 0.5 green:(arc4random()%173)/346.0 + 0.5  blue:(arc4random()%173)/346.0 + 0.5  alpha: 1];
        [arraVc addObject:vc];
        [arraTitle addObject:[NSString stringWithFormat:@"第%d页",i]];
    }
    
    PP_SlipMenuView *pp_View = [[PP_SlipMenuView alloc] initWithParentVc:self childrenVc:@[vc1,vc2,vc3,vc4,vc5] childrenTitles:@[@"姚明",@"奥尼尔",@"艾弗森",@"欧文",@"韦德"] frame:self.view.bounds numTitleOnePage:3];
//     PP_SlipMenuView *pp_View = [[PP_SlipMenuView alloc] initWithParentVc:self childrenVc:arraVc childrenTitles:arraTitle frame:self.view.bounds numTitleOnePage:3];
    
    [self.view addSubview:pp_View];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
