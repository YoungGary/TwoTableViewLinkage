//
//  Model.m
//  TableViewLink
//
//  Created by YOUNG on 2017/3/21.
//  Copyright © 2017年 Young. All rights reserved.
//

#import "Model.h"

@implementation CateGoryModel : NSObject

+ (NSDictionary *)objectClassInArray
{
    return @{ @"spus": @"FoodModel" };
}

@end

@implementation FoodModel : NSObject

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{ @"foodId": @"id" };
}


@end
