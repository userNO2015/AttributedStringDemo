//
//  BBAttributedString.m
//  属性字符串
//
//  Created by 吴帮雷 on 2018/5/19.
//  Copyright © 2018年 吴帮雷. All rights reserved.
//  

#import "BBAttributedString.h"
#import "EmoticonsHelper.h"

//你的正则
#define EMOTICONZHENGZE @"\\[\\([a-zA-Z0-9\u4e00-\u9fa5]+\\)\\]"

@implementation BBAttributedString

+ (NSMutableAttributedString *)stringToAttributeString:(NSString *)text{
    //先把普通的字符串text转化生成Attributed类型的字符串
    NSMutableAttributedString * attStr = [[NSMutableAttributedString        alloc]initWithString:text];
    //正则表达式 ,例如  [(呵呵)] = 😑
    NSString * zhengze = EMOTICONZHENGZE;
    NSError * error;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:zhengze options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re)
    {
        //打印错误😓
        NSLog(@"error😓=%@",[error localizedDescription]);
    }
    NSArray * arr = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];//遍历字符串,获得所有的匹配字符串
    NSBundle *bundle = [NSBundle mainBundle];
    NSString * path = [bundle pathForResource:@"tb_png" ofType:@"plist"];  //plist文件,制作一个 数组,包含文字,表情图片名称
    NSArray * face = [[NSArray alloc]initWithContentsOfFile:path];//获取 所有的数组
    //如果有多个表情图，必须从后往前替换，因为替换后Range就不准确了
    for (int j =(int) arr.count - 1; j >= 0; j--) {
        //NSTextCheckingResult里面包含range
        NSTextCheckingResult * result = arr[j];
        for (int i = 0; i < face.count; i++) {
            if ([[text substringWithRange:result.range] isEqualToString:face[i][@"key"]])//从数组中的字典中取元素
            {
                NSString * imageName = [NSString stringWithString:face[i][@"picture"]];
                //添加附件,图片
                NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];
                //调节表情大小
                textAttachment.bounds=CGRectMake(0, 0, 20, 20);
                textAttachment.image = [UIImage imageNamed:imageName];
                NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //替换未图片附件
                [attStr replaceCharactersInRange:result.range withAttributedString:imageStr];
                break;
            }
        }
    }
    return attStr;
}
//把带有图片的属性字符串转成普通的字符串
+ (NSString *)attributedStringToString:(NSAttributedString *)attributedText
{
    NSMutableAttributedString * resutlAtt = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
    EmoticonsHelper * helper = [EmoticonsHelper new];
    //枚举出所有的附件字符串
    [attributedText enumerateAttributesInRange:NSMakeRange(0, attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        //从字典中取得那一个图片
        NSTextAttachment * textAtt = attrs[@"NSAttachment"];
        if (textAtt)
        {
            UIImage * image = textAtt.image;
            NSString * text = [helper stringFromImage:image];
            [resutlAtt replaceCharactersInRange:range withString:text];
        }
    }];
    return resutlAtt.string;
}

+(CGSize)getAttributedTextSize:(NSString *)text
{
    //先把普通的字符串text转化生成Attributed类型的字符串
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:text];
    NSString *zhengze = EMOTICONZHENGZE;
    NSError *error;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:zhengze options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re)
    {
        NSLog(@"正则表达式匹配错误%@" ,[error localizedDescription]);
    }
    NSArray * arr = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    if (!arr.count)//说明字符串中没有表情通配符,是普通的文本,则计算文本size
    {
        NSDictionary *dic=@{NSFontAttributeName: [UIFont systemFontOfSize:20]};
        CGSize size1=[text boundingRectWithSize:CGSizeMake(160, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        return size1;
    }
    NSBundle *bundle = [NSBundle mainBundle];
    NSString * path = [bundle pathForResource:@"tb_png" ofType:@"plist"];
    NSArray * face = [[NSArray alloc]initWithContentsOfFile:path];
    //如果有多个表情图，必须从后往前替换，因为替换后Range就不准确了
    for (int j =(int) arr.count - 1; j >= 0; j--) {
        //NSTextCheckingResult里面包含range
        NSTextCheckingResult * result = arr[j];
        for (int i = 0; i < face.count; i++) {
            if ([[text substringWithRange:result.range] isEqualToString:face[i][@"key"]])
            {
                NSString * imageName = [NSString stringWithString:face[i][@"picture"]];
                NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];
                textAttachment.image = [UIImage imageNamed:imageName];
                NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                [attStr replaceCharactersInRange:result.range withAttributedString:imageStr];
                break;
            }
        }
    }
    CGSize size2 = [attStr boundingRectWithSize:CGSizeMake(180, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    size2.height+=40;  //表情文字增加高度
    return size2;//返回属性字符串的尺寸
}

@end
