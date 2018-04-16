//
//  VoiceConverter.m
//  Jeans
//
//  Created by Jeans Huang on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VoiceConverter.h"
#import "interf_dec.h"
#import "dec_if.h"
#import "interf_enc.h"
#import "amrFileCodec.h"

@implementation VoiceConverter

+ (int)amrToWav:(NSString*)_amrPath wavSavePath:(NSString*)_savePath{
    NSData *amrData = [NSData dataWithContentsOfFile:_amrPath];
    NSData *wavData = DecodeAMRToWAVE(amrData);
    if (wavData==Nil || [wavData length]==0) {
        return 0;
    }
    NSFileManager *fileMG = [NSFileManager defaultManager];
    if ([fileMG fileExistsAtPath:_savePath]) {
        [fileMG removeItemAtPath:_savePath error:Nil];
    }
    [fileMG createFileAtPath:_savePath contents:wavData attributes:Nil];
//    if (! DecodeAMRFileToWAVEFile([_amrPath cStringUsingEncoding:NSASCIIStringEncoding], [_savePath cStringUsingEncoding:NSASCIIStringEncoding]))
//        return 0;
    
    return 1;
}

+ (int)wavToAmr:(NSString*)_wavPath amrSavePath:(NSString*)_savePath{
    
    NSData *wavData = [NSData dataWithContentsOfFile:_wavPath];
    NSData *amrData = EncodeWAVEToAMR(wavData, 1, 16);
    if (amrData==Nil || [amrData length]==0) {
        return 0;
    }
    NSFileManager *fileMG = [NSFileManager defaultManager];
    if ([fileMG fileExistsAtPath:_savePath]) {
        [fileMG removeItemAtPath:_savePath error:Nil];
    }
    [fileMG createFileAtPath:_savePath contents:amrData attributes:Nil];
    //if (EncodeWAVEFileToAMRFile([_wavPath cStringUsingEncoding:NSASCIIStringEncoding], [_savePath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16))
    //    return 0;
    
    return 1;
}
    
    
@end
