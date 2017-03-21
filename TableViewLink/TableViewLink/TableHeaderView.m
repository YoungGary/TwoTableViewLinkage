//
//  TableHeaderView.m
//  TableViewLink
//
//  Created by YOUNG on 2017/3/21.
//  Copyright © 2017年 Young. All rights reserved.
//

#import "TableHeaderView.h"

@implementation TableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor grayColor];
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 20)];
        self.name.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.name];
    }
    return self;
}

@end
