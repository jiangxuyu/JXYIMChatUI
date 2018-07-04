//
//  ViewController.m
//  IMChatUIDemo
//
//  Created by 骚姜的HHBoy on 2018/6/28.
//  Copyright © 2018 骚姜的HHBoy. All rights reserved.
//

#import "ViewController.h"
#import "JXYChatView.h"

@interface ViewController ()

@property (nonatomic, strong) JXYChatView *imChatView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imChatView];
}


- (JXYChatView *)imChatView {
    JXYChatView *imChatView = [[JXYChatView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    return imChatView;
}


@end
