//
//  BBAttributedString.h
//  属性字符串
//
//  Created by 吴帮雷 on 2018/5/19.
//  Copyright © 2018年 吴帮雷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BBAttributedString : NSObject
//把普通字符串转成属性字符串
+ (NSMutableAttributedString *)stringToAttributeString:(NSString *)text;
//把带有图片的属性字符串转成普通的字符串
+ (NSString *)attributedStringToString:(NSAttributedString *)attributedText;
//计算大小
+(CGSize)getAttributedTextSize:(NSString *)text;

@end
