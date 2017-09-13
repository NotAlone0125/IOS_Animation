//
//  ViewController.m
//  YYH_WaveAnimation
//
//  Created by 杨昱航 on 2017/6/12.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

#import "ViewController.h"

#import "YYHAnimationView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    YYHAnimationView * view=[[YYHAnimationView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2)];
    [self.view addSubview:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
