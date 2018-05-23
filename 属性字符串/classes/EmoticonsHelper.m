//
//  EmoticonsHelper.m
//  属性字符串
//
//  Created by 吴帮雷 on 2018/5/19.
//  Copyright © 2018年 吴帮雷. All rights reserved.
//

#import "EmoticonsHelper.h"

@implementation EmoticonsHelper

//获取图片中文名字
- (NSString *)stringFromImage:(UIImage *)image
{
    NSArray *face=[self getAllImagePaths];
    
    NSData * imageD = UIImagePNGRepresentation(image);
    
    NSString * imageName;
    
    for (int i=0; i<face.count; i++)
    {
        UIImage *image=[UIImage imageNamed:face[i][@"picture"]];
        NSData *data=UIImagePNGRepresentation(image);
        if ([imageD isEqualToData:data])
        {
            imageName=face[i][@"key"];
            NSLog(@"匹配成功!");
        }
    }
    return imageName;
}

//获取图片数组
-(NSArray *)getAllImagePaths
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString * path = [bundle pathForResource:@"tb_png" ofType:@"plist"];
    NSArray * face = [[NSArray alloc]initWithContentsOfFile:path];
    return face;
}

@end
