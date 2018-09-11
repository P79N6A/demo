//
//  AppDelegate.m
//  VipPlay
//
//  Created by Jay on 24/8/18.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "AppDelegate.h"
#include <ctype.h>
//#import "NSURLProtocol+WKWebVIew.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


NSString * tohex(int tmpid)
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}


NSString * esp(NSString * src){
    int i;
    
    
    NSString* tmp = @"";
    
    
    for (i=0; i<[src length]; i++) {
        unichar c  = [src characterAtIndex:(NSUInteger)i];
        
        
        if(isdigit(c)||isupper(c)|islower(c)){
            tmp = [NSString stringWithFormat:@"%@%c",tmp,c];
        }else if((int)c <256){
            tmp = [NSString stringWithFormat:@"%@%@",tmp,@"%"];
            if((int)c <16){
                tmp =[NSString stringWithFormat:@"%@%@",tmp,@"0"];
            }
            tmp = [NSString stringWithFormat:@"%@%@",tmp,tohex((int)c)];
            
        }else{
            tmp = [NSString stringWithFormat:@"%@%@",tmp,@"%u"];
            tmp = [NSString stringWithFormat:@"%@%@",tmp,tohex(c)];
            
        }
        
        
    }
    
    
    return tmp;
}
Byte getInt(char c){
    if(c>='0'&&c<='9'){
        return c-'0';
    }else if((c>='a'&&c<='f')){
        return 10+(c-'a');
    }else if((c>='A'&&c<='F')){
        return 10+(c-'A');
    }
    return c;
}
int  getIntStr(NSString *src,int len){
    if(len==2){
        Byte c1 = getInt([src characterAtIndex:(NSUInteger)0]);
        Byte c2 = getInt([src characterAtIndex:(NSUInteger)1]);
        return ((c1&0x0f)<<4)|(c2&0x0f);
    }else{
        
        Byte c1 = getInt([src characterAtIndex:(NSUInteger)0]);
        
        Byte c2 = getInt([src characterAtIndex:(NSUInteger)1]);
        Byte c3 = getInt([src characterAtIndex:(NSUInteger)2]);
        Byte c4 = getInt([src characterAtIndex:(NSUInteger)3]);
        return( ((c1&0x0f)<<12)
               |((c2&0x0f)<<8)
               |((c3&0x0f)<<4)
               |(c4&0x0f));
    }
    
}
NSString* unesp(NSString* src){
    int lastPos = 0;
    int pos=0;
    unichar ch;
    NSString * tmp = @"";
    while(lastPos<src.length){
        NSRange range;
        
        range = [src rangeOfString:@"%" options:NSLiteralSearch range:NSMakeRange(lastPos, src.length-lastPos)];
        if (range.location != NSNotFound) {
            pos = (int)range.location;
        }else{
            pos = -1;
        }
        
        if(pos == lastPos){
            
            if([src characterAtIndex:(NSUInteger)(pos+1)]=='u'){
                NSString* ts = [src substringWithRange:NSMakeRange(pos+2,4)];
                
                int d = getIntStr(ts,4);
                ch = (unichar)d;
                NSLog(@"%@%C",tohex(d),ch);
                tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"%C",ch]];
                
                lastPos = pos+6;
                
            }else{
                NSString* ts = [src substringWithRange:NSMakeRange(pos+1,2)];
                int d = getIntStr(ts,2);
                ch = (unichar)d;
                tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"%C",ch]];
                lastPos = pos+3;
            }
            
        }else{
            if(pos ==-1){
                NSString* ts = [src substringWithRange:NSMakeRange(lastPos,src.length-lastPos)];
                
                tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"%@",ts]];
                lastPos = (int)src.length;
            }else{
                NSString* ts = [src substringWithRange:NSMakeRange(lastPos,pos-lastPos)];
                
                tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"%@",ts]];
                lastPos  = pos;
            }
        }
    }
    
    return tmp;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [NSURLProtocol wk_registerScheme:@"http"];
//    [NSURLProtocol wk_registerScheme:@"https"];

    NSString *content = @"%u7b2c01%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2Fr0kBJIRF7ZD3sLRN%23%u7b2c02%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2Fr1Hen3gKgdQ1nXDB%23%u7b2c03%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FSaG6EdtN5cdTTdSY%23%u7b2c04%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2F0G8chjNonU0mOjqP%23%u7b2c05%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FRBmug6C7twVZR22p%23%u7b2c06%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FYDxRNjQwD8v3ohUX%23%u7b2c07%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2F7y2mpLySOPQmT4D0%23%u7b2c08%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FkSFrZKjwFE9WYotG%23%u7b2c09%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FvokreCsHA0nXrNWh%23%u7b2c10%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FZiqPzin7jXz9YzAo%23%u7b2c11%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2F0nQdNQn4mvOhA2Q8%23%u7b2c12%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FeWl2dqgOX5OpsYvn%23%u7b2c13%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FRGIDPoSJwoKFTiwa%23%u7b2c14%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FQuNEoifrIfxHBHIG%23%u7b2c15%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2Fv7WqLyR1rnNSYkdT%23%u7b2c16%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FeoGlNnZiDGdYso8m%23%u7b2c17%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FwQ1yKCjDETqqRP7v%23%u7b2c18%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FHJRG7HNDzbitMtS2%23%u7b2c19%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FqaKhbmFPPAlQ0PDI%23%u7b2c20%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FLOQ7cVTTvEIk8ywM%23%u7b2c21%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FArQs20ucPmv8wC8N%23%u7b2c22%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FNYS7lksSQnwWqboT%23%u7b2c23%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2F3BS3qkc42qMESKuM%23%u7b2c24%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FwWgOb6JgrSNE5W66%23%u7b2c25%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FciOU35ihIP5Urp1G%23%u7b2c26%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FvyIfb3LqrAixfea1%23%u7b2c27%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2F4yKyLIlcxvnsW8sR%23%u7b2c28%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FNEpChe7LiiHs9psi%23%u7b2c29%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FxtvXpXiEaqglHP4w%23%u7b2c30%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FzkHTNnmCYrrOS3bO%23%u7b2c31%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FbCfh21zgdY9OaoTq%23%u7b2c32%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2F1M65lXwrGliAi0Vd%23%u7b2c33%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2F6oL0ZTuqF4oh8e30%23%u7b2c34%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2Fr8DymlTIy0wDL2nQ%23%u7b2c35%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FaEbWujBXl7FIWThi%23%u7b2c36%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FuGz3EXYTqQL7HqPU%23%u7b2c37%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2F1duMCUdzZSH37GwN%23%u7b2c38%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2FSGRTS8a6bKvpBz7y%23%u7b2c39%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2F7BuLzKuYmUw3dKcs%23%u7b2c40%u96c6%24https%3A%2F%2Fme.guiji365.com%2Fshare%2Fo0LRwBy9QwFertyC";
    NSString *str = unesp(content);

    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
