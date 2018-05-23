//
//  ViewController.m
//  属性字符串
//
//  Created by 吴帮雷 on 2018/5/19.
//  Copyright © 2018年 吴帮雷. All rights reserved.
//

#import "ViewController.h"
#import "BBAttributedString.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)change1:(id)sender{
    self.lbl_atext.attributedText = [BBAttributedString stringToAttributeString:self.tv.text];
}
- (IBAction)change2:(id)sender{
    self.lbl_text.text = [BBAttributedString attributedStringToString:self.lbl_atext.attributedText];
}
- (IBAction)input:(id)sender{
    NSRange range = [self.tv2 selectedRange];
    if (range.length > 0) {
        [self.tv2.textStorage deleteCharactersInRange:range];
    }
    [self.tv2.textStorage insertAttributedString:[BBAttributedString stringToAttributeString:@"[(害羞)]"] atIndex:self.tv2.selectedRange.location];
    self.tv2.selectedRange = NSMakeRange(self.tv2.selectedRange.location+1, 0);
    [self resetTextStyle];
}
- (void)resetTextStyle {
    NSRange wholeRange = NSMakeRange(0, self.tv2.textStorage.length);
    [self.tv2.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [self.tv2.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:wholeRange];
}
- (void)emoticonAttributedStringTextView:(UITextView *)textView andAttributedString:(NSAttributedString *)attributedString{
    [textView.textStorage insertAttributedString:attributedString atIndex:textView.selectedRange.location];
    textView.selectedRange = NSMakeRange(textView.selectedRange.location+1, 0);
    //重置格式
    NSRange wholeRange = NSMakeRange(0,textView.textStorage.length);
    [textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [textView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:wholeRange];
}

//取消键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)size:(id)sender{
    CGSize size = [BBAttributedString getAttributedTextSize:[BBAttributedString attributedStringToString:self.tv2.attributedText]];
    NSLog(@"w = %f , h = %f",size.width,size.height);
}
@end
