//
//  UIStoryboard+Theme.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-10.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "UIStoryboard+Theme.h"

@implementation UIStoryboard (Theme)

+ (UIStoryboard *)storyboardWithName:(NSString *)name{
    NSString *theme = [[NSUserDefaults standardUserDefaults] stringForKey:@"Storyboard_Theme"];
    if((theme==nil) || [theme isEqualToString:@""]){
        return [UIStoryboard storyboardWithName:name bundle:nil];
    }else{
        return [UIStoryboard storyboardWithName:[NSString stringWithFormat:@"%@_%@", name, theme] bundle:nil];
    }
}

@end
