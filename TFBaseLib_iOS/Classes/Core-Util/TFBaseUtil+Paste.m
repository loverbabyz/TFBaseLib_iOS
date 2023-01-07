//
//  TFBaseUtil+Paste.m
//  TFBaseLib
//
//  Created by Daniel on 15/10/16.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFBaseUtil+Paste.h"

void tf_pasteString(NSString* string)
{
    return [TFBaseUtil pasteString:string];
}

void tf_pasteImage(UIImage* image)
{
    return [TFBaseUtil pasteImage:image];
}

@implementation TFBaseUtil (Paste)

//设置需要粘贴的文字或图片
+(void)pasteString:(NSString*)string
{
    [[UIPasteboard generalPasteboard] setString:string];
}

+(void)pasteImage:(UIImage*)image
{
    [[UIPasteboard generalPasteboard] setImage:image];
}

@end
