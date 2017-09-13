//
//  ViewController.m
//  YYH_UIBezierPath
//
//  Created by 杨昱航 on 2017/6/6.
//  Copyright © 2017年 杨昱航. All rights reserved.
//

#import "ViewController.h"
#import "BezierPathView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    BezierPathView * View=[[BezierPathView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    View.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:View];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
