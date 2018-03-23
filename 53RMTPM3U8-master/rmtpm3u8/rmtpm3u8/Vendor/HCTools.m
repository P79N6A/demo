//
//  HCTools.m
//  zhonghaijinchao
//
//  Created by 川何 on 16/8/16.
//  Copyright © 2016年 WLJF. All rights reserved.
//

#import "HCTools.h"

static NSString * oldText;

@implementation HCTools
+(instancetype) newTools{
    static HCTools *instance;
    instance = [[self alloc] init];
    return instance;
}

+(NSArray *)stringToJSONarray:(NSString *)jsonStr{
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp]; //
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}

+(void)setoldtext:(NSString *)str{
    oldText = str;
}
+(BOOL)limitEnglishWithStr:(NSString*)str Max:(int)max Min:(int)min {
    NSString *wordEn = [NSString stringWithFormat:@"^[a-zA-Z]{%d,%d}$",min -1,max - 1];//@"^[a-zA-Z]{%d,%d}$" 纯英文 //当前是位数限制就可以了
    NSPredicate *wordenPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",wordEn];
    return [wordenPre evaluateWithObject:str];
}
    

+(NSString*) limitNumberWithStr:(NSString*)str Round:(int)round Dicimal:(int)dicimal{
    if( ![str containsString:@"."]){
        if (str.length > round) {
            str = [str substringToIndex:round];
//            str = oldText;
        }
        return str;

    }
    else
    {
        NSString *xiao = [str substringFromIndex:[str  rangeOfString:@"."].location +1];
        if (xiao.length > dicimal) {
//            if (!oldText) {
                xiao = [xiao substringToIndex:dicimal];
//             }else{
//                str = oldText;
// 
//            }
//            return str;
        }
        NSString *zheng = [str substringToIndex:[str  rangeOfString:@"."].location ];
        if (zheng.length > round) {
//            if (!oldText) {
                zheng = [zheng substringToIndex:round];
//            }else{
//                str = oldText;
//            }
//            return str;
        }
        return [NSString stringWithFormat:@"%@.%@",zheng,xiao];
        
    }
//    oldText = str ;
//    return str;
    
}


+ (NSArray *)jsonStringToArray:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp]; //
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}
+(BOOL)validatePasswordString:(NSString *)password{
    NSString * MOBIL = @"^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{6,16}$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBIL];
    if ([identityCardPredicate evaluateWithObject:password]) {
        if ([password containsString:@" "]) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return NO;
    }
}
//验证座机号码
+(BOOL)validateLocalPhoneNumber:(NSString *)localphone{
    NSString * MOBIL = @"^((\\d{3,4}-)?\\d{7,8})$|^(0[0-9][0-9]\\d{8})$";//d{3}-/d{8}|/d{4}-/d{7}
    //^0(10|2[0-5789]|\\d{3})\\d{7,8}$
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBIL];
    return [identityCardPredicate evaluateWithObject:localphone];
}
///d{3}-/d{8}|/d{4}-/d{7}
+ (BOOL) validatePhoneNumber: (NSString *)phoneNumber
{
    BOOL flag;
    if (phoneNumber.length < 11) {
        flag = NO;
        return flag;
    }
    NSString * MOBIL = @"^[1][3,4,5,7,8][0-9]{9}$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBIL];
    
    return [identityCardPredicate evaluateWithObject:phoneNumber];
}

+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        
        flag = NO;
        return flag;
        
    }
    
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
    
}


//验证邮编
+ (BOOL) validatePostCode: (NSString *)postCode{
    BOOL flag;
    if (postCode.length < 6) {
        flag = NO;
        return flag;
    }
    NSString * Codekey = @"[0-9]\\d{5}(?!\\d)";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Codekey];
    
    return [identityCardPredicate evaluateWithObject:postCode];

}
//验证电子邮箱
+ (BOOL) validateEamilAddrr: (NSString *)email{
    
    NSString * emalKey = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emalKey];
    return [identityCardPredicate evaluateWithObject:email];

}
//TODO:
//-(BOOL)prviteyValidateWithCode:(NSString*)code where:(NSString*)thisStr{
//    NSString * Codekey = code;
//    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",thisStr];
//    return [identityCardPredicate evaluateWithObject:Codekey];
//}


//合并pdf
+ (NSString *)joinPDF:(NSArray *)listOfPaths {
    // File paths
    NSString *fileName = @"ALL.pdf";
    NSString *pdfPathOutput = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    CFURLRef pdfURLOutput = (  CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:pdfPathOutput]);
    
    NSInteger numberOfPages = 0;
    // Create the output context
    CGContextRef writeContext = CGPDFContextCreateWithURL(pdfURLOutput, NULL, NULL);
    
    for (NSString *source in listOfPaths) {
        CFURLRef pdfURL = (  CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:source]);
        
        //file ref
        CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL);
        numberOfPages = CGPDFDocumentGetNumberOfPages(pdfRef);
        
        // Loop variables
        CGPDFPageRef page;
        CGRect mediaBox;
        
        // Read the first PDF and generate the output pages
        for (int i=1; i<=numberOfPages; i++) {
            page = CGPDFDocumentGetPage(pdfRef, i);
            mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
            CGContextBeginPage(writeContext, &mediaBox);
            CGContextDrawPDFPage(writeContext, page);
            CGContextEndPage(writeContext);
        }
        
        CGPDFDocumentRelease(pdfRef);
        CFRelease(pdfURL);
    }
    CFRelease(pdfURLOutput);
    
    // Finalize the output file
    CGPDFContextClose(writeContext);
    CGContextRelease(writeContext);
    
    return pdfPathOutput;
}

//from 是标准值,屏幕的layer 值
+ (CGRect) fromRect:(CGRect)fromrect To:(CGRect)torect{
    CGFloat racew = torect.size.width / kScreenW ;
    CGFloat raceh = torect.size.height / kScreenH;
    
    
    return  CGRectMake(fromrect.origin.x * racew - 20, fromrect.origin.y * racew - 20, fromrect.size.width * racew +40, fromrect.size.height * raceh + 40);
    
}
//double 很重要
+(NSString *)stringFromTimeStemp:(double)longtime{
    
    NSDate *dateStop = [NSDate dateWithTimeIntervalSince1970:longtime/1000];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *strtimeString = [format stringFromDate:dateStop];

    return strtimeString;
}

+(NSArray*)jsonorarrayGaurd:(id)item{
    if ([item isKindOfClass:[NSArray class]]) {
        return item;
    }
    NSError *errorJson;
    NSArray *jsonDict = [NSJSONSerialization JSONObjectWithData:[item dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&errorJson];
    if (errorJson != nil) {
#ifdef DEBUG
        NSLog(@"fail to get dictioanry from JSON: %@, error: %@", self, errorJson);
#endif
    }
    return jsonDict;

}
+(UIView*)lineviewWithHeight:(CGFloat)height Width:(CGFloat)width Color:(UIColor *)color{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height /2.0)];
    view.backgroundColor = color;
    return view;
}


+(UIButton*)buttonNormalWithFrame:(CGRect)frame title:(NSString*)title titleColor:(UIColor*)titlecolor titleFount:(UIFont*)titlefont backgroundColor:(UIColor*)bccolor corner:(CGFloat)corner{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn jk_setBackgroundColor:bccolor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titlecolor forState:UIControlStateNormal];
    btn.titleLabel.font = titlefont;
    if (corner>0) {
        kRViewBorderRadius(btn, corner);
    }
    return btn;
}

+(UIButton*)buttonNormalEasyFrame:(CGRect)frame titleColor:(UIColor*)titlecolor titleFountFloat:(CGFloat)fontFloat backgroundColor:(UIColor*)bccolor corner:(CGFloat)corner  title:(NSString*)title {
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn jk_setBackgroundColor:bccolor forState:UIControlStateNormal];
    [btn jk_setBackgroundColor:bccolor forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titlecolor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontFloat];
    if (corner>0) {
        kRViewBorderRadius(btn, corner);
    }
    return btn;
}

+(UIButton*)buttonEnableWithFrame:(CGRect)frame title:(NSString*)title titleFount:(UIFont*)titlefont disTitle:(NSString*)distitle titleColor:(UIColor*)titlecolor distitleColor:(UIColor*)distitlecolor backgroundColor:(UIColor*)bccolor disBcColor:(UIColor*)disbccolor corner:(CGFloat)corner{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn jk_setBackgroundColor:bccolor forState:UIControlStateNormal];
    [btn jk_setBackgroundColor:disbccolor forState:UIControlStateDisabled];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:distitle forState:UIControlStateDisabled];
    [btn setTitleColor:titlecolor forState:UIControlStateNormal];
    [btn setTitleColor:distitlecolor forState:UIControlStateDisabled];
    btn.titleLabel.font = titlefont;
    if (corner>0) {
        kRViewBorderRadius(btn, corner);
    }
    return btn;
}

+(UIButton*)buttonSelectFrame:(CGRect)frame titlenormalColor:(UIColor*)norColor titleselColor:(UIColor*)selColor boardColor:(UIColor*)boardcolor boardWith:(CGFloat)boardwith normalBackgroundColor:(UIColor*)normalBColor selBackgroundColor:(UIColor*)selBColor titleFont:(UIFont *)titlefont corner:(CGFloat)corner title:(NSString*)title selTitle:(NSString*)seltitle{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [btn jk_setBackgroundColor:normalBColor forState:UIControlStateNormal];
    [btn jk_setBackgroundColor:selBColor forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:seltitle forState:UIControlStateSelected];
    [btn setTitleColor:norColor forState:UIControlStateNormal];
    [btn setTitleColor:selColor forState:UIControlStateSelected];
    btn.titleLabel.font = titlefont;
    if (corner>0 || boardcolor == nil) {
        if (boardwith>0) {
            kRViewBorderRadiusAndCorlor(btn, corner, boardwith, boardcolor);

        }else{
            kRViewBorderRadius(btn, corner);

        }
    }
        return btn;

}

+(UILabel*)labelWithFrame:(CGRect)frame textAlignment:(NSTextAlignment)alignment titleColor:(UIColor *)color title:(NSString*)title titlefont:(NSNumber*)fontnum  {
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:frame];
    titlelabel.font = [UIFont systemFontOfSize:fontnum.doubleValue];
    titlelabel.textColor = color;
    titlelabel.textAlignment = alignment;
    titlelabel.text = title;
    return titlelabel;
}

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
       textFieldNumber:(NSUInteger)textFieldNumber
          actionNumber:(NSUInteger)actionNumber
          actionTitles:(NSArray *)actionTitle
      textFieldHandler:(textFieldHandler)textFieldHandler
         actionHandler:(actionHandler)actionHandler {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (textFieldNumber > 0) {
        for (int i = 0; i < textFieldNumber; i++) {
            [alertC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textFieldHandler(textField, i);
            }];
        }
    }
    if (actionNumber > 0) {
        for (NSUInteger i = 0; i < actionNumber; i++) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
                actionHandler(action, i);
            }];
            [alertC addAction:action];
        }
    }
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertC animated:YES completion:nil];
}

- (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
       textFieldNumber:(NSUInteger)textFieldNumber
          actionNumber:(NSUInteger)actionNumber
          actionTitles:(NSArray *)actionTitle
      textFieldHandler:(textFieldHandler)textFieldHandler
         actionHandler:(actionText)actionText{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (textFieldNumber > 0) {
        for (int i = 0; i < textFieldNumber; i++) {
            [alertC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textFieldHandler(textField, i);
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
            }];
        }
    }
    if (actionNumber > 0) {
        for (NSUInteger i = 0; i < actionNumber; i++) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                actionText(action,_textString, i);
            }];
            [alertC addAction:action];
        }
    }
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertC animated:YES completion:nil];
}
- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    _textString = textField.text;
    
}

+ (void)actionSheettWithTitle:(NSString *)title
                      message:(NSString *)message
                 actionNumber:(NSUInteger)actionNumber
                 actionTitles:(NSArray *)actionTitle
                actionHandler:(actionHandler)actionHandler {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    if (actionNumber > 0) {
        for (NSUInteger i = 0; i < actionNumber; i++) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
                actionHandler(action, i);
            }];
            [alertC addAction:action];
        }
    }
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertC animated:YES completion:nil];
}

+(CGSize)labeSizeWithString:(NSString*)string Font:(CGFloat)font{
    NSMutableAttributedString * maxPriceAttStr = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    return  [maxPriceAttStr size];
}
+ (float) heightForString:(NSString *)value andWidth:(float)width{
    //获取当前文本的属性
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
//    _text.attributedText = attrStr;
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}
+ (float) heightForString:(NSString *)value andWidth:(float)width font:(float)font{
    //获取当前文本的属性
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:value];
    NSRange range = NSMakeRange(0, attrStr.length);
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font]  range:range];
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}
+(NSString *)notRounding:(double)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+(NSString *)changeFloat:(NSString *)stringFloat
{
    NSString *returnString;
    
    if ([stringFloat containsString:@"."]) {
        const char *floatChars = [stringFloat UTF8String];
        NSUInteger length = [stringFloat length];
        NSUInteger zeroLength = 0;
        int i = (int)length - 1;
        for(; i>=0; i--)
        {
            if(floatChars[i] == '0'/*0x30*/) {
                zeroLength++;
            } else {
                if(floatChars[i] == '.')
                {
                    i--;
                }
                break;
            }
        }
        if(i == -1) {
            returnString = @"0";
        } else {
            
            returnString = [stringFloat substringToIndex:i+1];
            
        }
    }else{
        returnString = stringFloat;
        
    }
    return returnString;
}

+(void)nslogPropertyWithDic:(id)obj {
    
#if DEBUG
    
    NSDictionary *dic = [NSDictionary new];
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *tempDic = [(NSDictionary *)obj mutableCopy];
        dic = tempDic;
    } else if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *tempArr = [(NSArray *)obj mutableCopy];
        if (tempArr.count > 0) {
            dic = tempArr[0];
        } else {
            NSLog(@"无法解析为model属性，因为数组为空");
            return;
        }
    } else {
        NSLog(@"无法解析为model属性，因为并非数组或字典");
        return;
    }
    
    if (dic.count == 0) {
        NSLog(@"无法解析为model属性，因为该字典为空");
        return;
    }
    
    
    NSMutableString *strM = [NSMutableString string];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSString *className = NSStringFromClass([obj class]) ;
        NSLog(@"className:%@/n", className);
        if ([className isEqualToString:@"__NSCFString"] | [className isEqualToString:@"__NSCFConstantString"] | [className isEqualToString:@"NSTaggedPointerString"]) {
            [strM appendFormat:@"@property (nonatomic, copy) NSString *%@;\n",key];
        }else if ([className isEqualToString:@"__NSCFArray"] |
                  [className isEqualToString:@"__NSArray0"] |
                  [className isEqualToString:@"__NSArrayI"]){
            [strM appendFormat:@"@property (nonatomic, strong) NSArray *%@;\n",key];
        }else if ([className isEqualToString:@"__NSCFDictionary"]){
            [strM appendFormat:@"@property (nonatomic, strong) NSDictionary *%@;\n",key];
        }else if ([className isEqualToString:@"__NSCFNumber"]){
            [strM appendFormat:@"@property (nonatomic, strong) NSNumber *%@;\n",key];
        }else if ([className isEqualToString:@"__NSCFBoolean"]){
            [strM appendFormat:@"@property (nonatomic, assign) BOOL   %@;\n",key];
        }else if ([className isEqualToString:@"NSDecimalNumber"]){
            [strM appendFormat:@"@property (nonatomic, copy) NSString *%@;\n",[NSString stringWithFormat:@"%@",key]];
        }
        else if ([className isEqualToString:@"NSNull"]){
            [strM appendFormat:@"@property (nonatomic, copy) NSString *%@;\n",[NSString stringWithFormat:@"%@",key]];
        }else if ([className isEqualToString:@"__NSArrayM"]){
            [strM appendFormat:@"@property (nonatomic, strong) NSMutableArray *%@;\n",[NSString stringWithFormat:@"%@",key]];
        }
        
    }];
    NSLog(@"\n%@\n",strM);
    
#endif
    
}


+(NSString*)makestr:(NSString*)amount Point:(int)point{
    if ([amount containsString:@"."]) {
        NSRange range = [amount rangeOfString:@"."];
        return [amount substringToIndex:range.location + point + 1];

    }else{
        return amount;
    }
}


+(NSString *)notRoundingStr:(NSString*)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithString:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}



+(void)showAlertError:(NSString *)errorMsg {
    // 1.弹框提醒
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    // 弹出对话框
    [kRootViewController presentViewController:alert animated:true completion:nil];
}

+(NSString*)hideEmail:(NSString*)email{
    if ([email jk_isEmailAddress]) {
        NSRange aiterange = [email rangeOfString:@"@"];
        NSString *hidstring = nil ;
        if (aiterange.location > 1) {
            
            hidstring = [email stringByReplacingOccurrencesOfString:[email substringWithRange:NSMakeRange(1, aiterange.location - 1)] withString:@"****"];
        }
        
        return hidstring;
    }else{
        return nil;
    }
}

+(NSString*)hideString:(NSString*)hideString{
    if (hideString.length > 9) {
        NSString *hidstring = [hideString stringByReplacingOccurrencesOfString:[hideString substringWithRange:NSMakeRange(3, 4)] withString:@"****"];
        return hidstring;
    }else{
        return nil;
    }
}
@end
