//
//  Model.h
//  TableViewLink
//
//  Created by YOUNG on 2017/3/21.
//  Copyright © 2017年 Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Property.h"

@interface CateGoryModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, strong) NSArray *spus;

@end

@interface FoodModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *foodId;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, assign) NSInteger praise_content;
@property (nonatomic, assign) NSInteger month_saled;
@property (nonatomic, assign) float min_price;




@end