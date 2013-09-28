/***********************************************************************************
 * This software is under the MIT License quoted below:
 ***********************************************************************************
 *
 * Copyright (c) 2010 Olivier Halligon
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 ***********************************************************************************/


#import "OHASBasicHTMLParser.h"
#import "NSAttributedString+Attributes.h"
#import "NSString+Base64.h"

#if __has_feature(objc_arc)
#define MRC_AUTORELEASE(x) (x)
#else
#define MRC_AUTORELEASE(x) [(x) autorelease]
#endif

@implementation OHASBasicHTMLParser

NSDictionary *emotDicts =nil;

+(void)initialize {
    [super initialize];
    if (emotDicts!=nil) {
        return;
    }
    emotDicts =
    [@{@"吵架":@"1-10-3",
     @"疑问":@"1-11-3",
     @"惊讶":@"1-12-3",
     @"笑脸":@"1-1-3",
     @"吐舌":@"1-13-3",
     @"眨眼":@"1-14-3",
     @"惊悚":@"1-15-3",
     @"睡觉":@"1-16-3",
     @"犯困":@"1-17-3",
     @"高傲":@"1-18-3",
     @"看天":@"1-19-3",
     @"听歌":@"1-20-3",
     @"疲惫":@"1-21-3",
     @"脸红":@"1-22-3",
     @"着迷":@"1-2-3",
     @"对眼":@"1-23-3",
     @"小声":@"1-24-3",
     @"呕吐":@"1-25-3",
     @"舔嘴":@"1-26-3",
     @"鄙视":@"1-27-3",
     @"皱眉":@"1-28-3",
     @"发愣":@"1-29-3",
     @"头晕":@"1-30-3",
     @"爆踩":@"1-31-3",
     @"犯衰":@"1-32-3",
     @"龇牙":@"1-3-3",
     @"受伤":@"1-33-3",
     @"独眼":@"1-34-3",
     @"禁声":@"1-35-3",
     @"切头":@"1-36-3",
     @"偷笑":@"1-4-3",
     @"害羞":@"1-5-3",
     @"挤泪":@"1-6-3",
     @"大哭":@"1-7-3",
     @"帅气":@"1-8-3",
     @"冒火":@"1-9-3",
     @"力量":@"2-10-3",
     @"鬼魅":@"2-11-3",
     @"三鬼":@"2-12-3",
     @"数一":@"2-20-4",
     @"数二":@"2-21-4",
     @"数三":@"2-22-4",
     @"数四":@"2-23-4",
     @"数五":@"2-24-4",
     @"数六":@"2-25-4",
     @"数七":@"2-26-4",
     @"数八":@"2-27-4",
     @"数九":@"2-28-4",
     @"数十":@"2-29-4",
     @"红烛":@"2-3-3",
     @"数零":@"2-34-2",
     @"@符":@"2-36-1",
     @"#符":@"2-37-1",
     @"!符":@"2-40-1",
     @"Z睡":@"2-44-1",
     @"篮球":@"2-47-1",
     @"马汗":@"2-7-3",
     @"西瓜":@"3-11-3",
     @"药丸":@"3-12-3",
     @"肥猪":@"3-13-3",
     @"吃饭":@"3-15-3",
     @"炮竹":@"3-16-3",
     @"香烟":@"3-18-3",
     @"情书":@"3-19-3",
     @"杯啤":@"3-20-3",
     @"民币":@"3-21-3",
     @"礼物":@"3-22-3",
     @"雪花":@"3-2-3",
     @"闹钟":@"3-23-3",
     @"电视":@"3-24-3",
     @"大便":@"3-25-3",
     @"月夜":@"3-26-3",
     @"手机":@"3-27-4",
     @"电话":@"3-28-3",
     @"药箱":@"3-30-3",
     @"拥抱":@"3-31-3",
     @"红心":@"3-3-4",
     @"咖啡":@"3-35-3",
     @"汽车":@"3-40-1",
     @"相机":@"3-41-1",
     @"飞机":@"3-43-1",
     @"心碎":@"3-4-4",
     @"彩虹":@"3-45-1",
     @"盛开":@"3-5-3",
     @"枯萎":@"3-6-3",
     @"红唇":@"3-8-3",
     @"蜡烛":@"4-10-3",
     @"诞树":@"4-11-3",
     @"鸡腿":@"4-12-3",
     @"粽子":@"4-1-3",
     @"南瓜":@"4-15-3",
     @"粽包":@"4-17-3",
     @"红旗":@"4-20-4",
     @"诞头":@"4-22-6",
     @"女孩":@"4-2-4",
     @"诞帽":@"4-25-3",
     @"小钟":@"4-26-3",
     @"二十":@"4-27-1",
     @"十二":@"4-28-1",
     @"男孩":@"4-3-4",
     @"五星":@"4-4-3",
     @"蛋糕":@"4-6-3",
     @"裤衩":@"4-7-3",
     @"胸罩":@"4-8-3",
     @"烦躁":@"5-10-2",
     @"很囧":@"5-11-2",
     @"平淡":@"5-1-2",
     @"雷到":@"5-12-2",
     @"花痴":@"5-13-2",
     @"亲嘴":@"5-14-2",
     @"羞涩":@"5-15-2",
     @"羞笑":@"5-16-2",
     @"捂眼":@"5-17-2",
     @"可怜":@"5-18-2",
     @"呜咽":@"5-19-2",
     @"封嘴":@"5-20-2",
     @"吐气":@"5-21-2",
     @"咧笑":@"5-2-2",
     @"生病":@"5-22-2",
     @"防御":@"5-23-2",
     @"踌躇":@"5-24-2",
     @"圆眼":@"5-25-2",
     @"抠鼻":@"5-26-2",
     @"加油":@"5-27-2",
     @"啊啊":@"5-28-2",
     @"犯晕":@"5-29-2",
     @"什么":@"5-30-2",
     @"空白":@"5-31-2",
     @"鼓掌":@"5-3-2",
     @"无聊":@"5-32-2",
     @"睡啦":@"5-33-2",
     @"便秘":@"5-34-2",
     @"不理":@"5-35-2",
     @"方衰":@"5-36-2",
     @"方帅":@"5-37-2",
     @"方傻":@"5-38-2",
     @"方呕":@"5-39-2",
     @"黑线":@"5-40-2",
     @"方鄙":@"5-41-2",
     @"方龇":@"5-4-2",
     @"方汗":@"5-42-2",
     @"方锤":@"5-43-2",
     @"方钱":@"5-44-2",
     @"方添":@"5-45-2",
     @"吐舌":@"5-46-2",
     @"鼻涕":@"5-47-2",
     @"拜佛":@"5-48-2",
     @"好样":@"5-49-2",
     @"道法":@"5-50-2",
     @"偶也":@"5-51-2",
     @"方红":@"5-5-2",
     @"勾引":@"5-52-2",
     @"欧克":@"5-53-2",
     @"握手":@"5-54-2",
     @"抱拳":@"5-55-2",
     @"看低":@"5-56-2",
     @"阴险":@"5-6-2",
     @"偷笑":@"5-7-2",
     @"方怒":@"5-8-2",
     @"方泪":@"5-9-2",
     @"鸡痴":@"6-10-1",
     @"鸡吼":@"6-1-1",
     @"鸡面":@"6-11-1",
     @"鸡跳":@"6-12-1",
     @"鸡骂":@"6-13-1",
     @"鸡睡":@"6-14-1",
     @"鸡抽":@"6-15-1",
     @"鸡线":@"6-16-1",
     @"鸡汗":@"6-17-1",
     @"鸡哭":@"6-18-1",
     @"鸡惑":@"6-2-1",
     @"鸡照":@"6-26-1",
     @"鸡鸣":@"6-3-1",
     @"鸡舞":@"6-4-1",
     @"鸡拜":@"6-5-1",
     @"鸡闭":@"6-6-1",
     @"鸡雷":@"6-7-1",
     @"鸡趴":@"6-8-1",
     @"鸡吖":@"6-9-1"} retain];
}


+(NSDictionary*)tagMappings
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            
            ^NSAttributedString*(NSAttributedString* str, NSTextCheckingResult* match)
            {
                NSRange textRange = [match rangeAtIndex:1];
                if (textRange.length>0)
                {
                    NSMutableAttributedString* foundString = [[str attributedSubstringFromRange:textRange] mutableCopy];
                    [foundString setTextBold:YES range:NSMakeRange(0,textRange.length)];
                    return MRC_AUTORELEASE(foundString);
                } else {
                    return nil;
                }
            }, @"<b>(.+?)</b>",
            
            ^NSAttributedString*(NSAttributedString* str, NSTextCheckingResult* match)
            {
                NSRange textRange = [match rangeAtIndex:1];
                if (textRange.length>0)
                {
                    NSMutableAttributedString* foundString = [[str attributedSubstringFromRange:textRange] mutableCopy];
                    [foundString setTextIsUnderlined:YES];
                    return MRC_AUTORELEASE(foundString);
                } else {
                    return nil;
                }
            }, @"<u>(.+?)</u>",
            
            ^NSAttributedString*(NSAttributedString* str, NSTextCheckingResult* match)
            {
                NSRange fontNameRange = [match rangeAtIndex:2];
                NSRange fontSizeRange = [match rangeAtIndex:4];
                NSRange textRange = [match rangeAtIndex:5];
                if ((fontNameRange.length>0) && (fontSizeRange.length>0) && (textRange.length>0))
                {
                    NSString* fontName = [str attributedSubstringFromRange:fontNameRange].string;
                    CGFloat fontSize = [str attributedSubstringFromRange:fontSizeRange].string.floatValue;
                    NSMutableAttributedString* foundString = [[str attributedSubstringFromRange:textRange] mutableCopy];
                    [foundString setFontName:fontName size:fontSize];
                    return MRC_AUTORELEASE(foundString);
                } else {
                    return nil;
                }
            }, @"<font name=(['\"])(.+?)\\1 size=(['\"])(.+?)\\3>(.+?)</font>",
            
            ^NSAttributedString*(NSAttributedString* str, NSTextCheckingResult* match)
            {
                NSRange colorRange = [match rangeAtIndex:2];
                NSRange textRange = [match rangeAtIndex:3];
                if ((colorRange.length>0) && (textRange.length>0))
                {
                    NSString* colorName = [str attributedSubstringFromRange:colorRange].string;
                    UIColor* color = OHUIColorFromString(colorName);
                    NSMutableAttributedString* foundString = [[str attributedSubstringFromRange:textRange] mutableCopy];
                    [foundString setTextColor:color];
                    return MRC_AUTORELEASE(foundString);
                } else {
                    return nil;
                }
            }, @"<font color=(['\"])(.+?)\\1>(.+?)</font>",
            
            ^NSAttributedString*(NSAttributedString* str, NSTextCheckingResult* match)
            {
                NSRange linkRange = [match rangeAtIndex:2];
                NSRange textRange = [match rangeAtIndex:3];
                if ((linkRange.length>0) && (textRange.length>0))
                {
                    NSString* link = [str attributedSubstringFromRange:linkRange].string;
                    NSMutableAttributedString* foundString = [[str attributedSubstringFromRange:textRange] mutableCopy];
                    [foundString setLink:[NSURL URLWithString:link] range:NSMakeRange(0,textRange.length)];
                    return MRC_AUTORELEASE(foundString);
                } else {
                    return nil;
                }
            }, @"<a href=(['\"])(.+?)\\1>(.+?)</a>",
            
            ^NSAttributedString*(NSAttributedString* str, NSTextCheckingResult* match)
            {
                NSRange linkRange = [match rangeAtIndex:1];
                NSRange textRange = [match rangeAtIndex:1];
                if ((linkRange.length>0) && (textRange.length>0))
                {
                    NSMutableAttributedString* foundString = [[str attributedSubstringFromRange:textRange] mutableCopy];
                    [foundString setTextColor:[UIColor blueColor]];
                    return MRC_AUTORELEASE(foundString);
                } else {
                    return nil;
                }
            }, @"(#[a-zA-Z0-9\\u4e00-\\u9fa5]+?#)",
            
            ^NSAttributedString*(NSAttributedString* str, NSTextCheckingResult* match)
            {
                NSRange linkRange = [match rangeAtIndex:1];
                NSRange textRange = [match rangeAtIndex:1];
                if ((linkRange.length>0) && (textRange.length>0))
                {
                    NSString* link = [str attributedSubstringFromRange:linkRange].string;
                    NSMutableAttributedString* foundString = [[str attributedSubstringFromRange:textRange] mutableCopy];
                    link = [link base64EncodedString];
                    NSURL *url = [NSURL URLWithString:link];
                    [foundString setLink:url range:NSMakeRange(0,[foundString length])];
                    return MRC_AUTORELEASE(foundString);
                } else {
                    return nil;
                }
            }, @"(@[a-zA-Z0-9\\u4e00-\\u9fa5]+)",
            ^NSAttributedString*(NSAttributedString* str, NSTextCheckingResult* match)
            {
                NSRange linkRange = [match rangeAtIndex:1];
                NSRange textRange = [match rangeAtIndex:1];
                if ((linkRange.length>0) && (textRange.length>0))
                {
                    NSString* link = [str attributedSubstringFromRange:linkRange].string;
                    NSMutableAttributedString* foundString = [[str attributedSubstringFromRange:textRange] mutableCopy];
                    link = [link base64EncodedString];
                    NSURL *url = [NSURL URLWithString:link];
                    [foundString setLink:url range:NSMakeRange(0,[foundString length])];
                    return MRC_AUTORELEASE(foundString);
                } else {
                    return nil;
                }
            }, @"(\\s(视频链接|微刊链接)$)",
            ^NSAttributedString*(NSAttributedString* str, NSTextCheckingResult* match)
            {
                NSRange linkRange = [match rangeAtIndex:1];
                NSRange textRange = [match rangeAtIndex:1];
                if ((linkRange.length>0) && (textRange.length>0))
                {
                    NSString* link = [str attributedSubstringFromRange:linkRange].string;
//                    NSMutableAttributedString* foundString = [[str attributedSubstringFromRange:NSMakeRange(0,0)] mutableCopy];
//                    [foundString setEmoit:link range:NSMakeRange(0,[foundString length])];
                    
                    
                    //render empty space for drawing the image in the text //1
                    CTRunDelegateCallbacks callbacks;
                    callbacks.version = kCTRunDelegateVersion1;
                    callbacks.getAscent = ascentCallback;
                    callbacks.getDescent = descentCallback;
                    callbacks.getWidth = widthCallback;
                    callbacks.dealloc = deallocCallback;
                    
                    NSDictionary* imgAttr = [[NSDictionary dictionaryWithObjectsAndKeys: //2
                                              @"20", @"width",
                                              @"20", @"height",
                                              nil] retain];
                    
                    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, imgAttr); //3
                    NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                            //set the delegate
                                                            (id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                                            nil];
                    NSMutableAttributedString* foundString = [[NSMutableAttributedString alloc] initWithString:@" " attributes:attrDictionaryDelegate];
                    
                    [foundString setEmoit:[NSString stringWithFormat:@"%@.png|%@|%@",emotDicts[link],
                                           imgAttr[@"width"], imgAttr[@"height"]]];
                    
                    return MRC_AUTORELEASE(foundString);
                } else {
                    return nil;
                }
            }, @"\\[([a-zA-Z0-9\\u4e00-\\u9fa5]+?)\\]",
            
            nil];
}

/* Callbacks */
static void deallocCallback( void* ref ){
    [(id)ref release];
}
static CGFloat ascentCallback( void *ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback( void *ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"descent"] floatValue];
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"width"] floatValue];
}

@end


