//
//  main.m
//  downloadTxt
//
//  Created by wu baofeng on 2019/7/27.
//  Copyright © 2019 wu baofeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HTMLReader/HTMLReader.h>


NSFileHandle *handle = nil;

NSStringEncoding enc = 0;

NSString *startUrl = @"https://m.45zw.la/txt/6502/1396010.html";
NSString *fileName = @"bcx.txt";
NSString *baseURl  = @"https://m.45zw.la";


void DownLoadURL(NSString *url)
{
    @autoreleasepool {
        NSError *error = nil;
        NSString *getString = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:enc error:&error];
        HTMLDocument *document = [[HTMLDocument alloc]initWithString:getString];
        
        HTMLElement *articleNode = [document firstNodeMatchingSelector:@"article"];
        
        NSString *TXTStr = articleNode.textContent;
        
        
        NSString *outString = [NSString stringWithFormat:@"echo '%@' >> %@",TXTStr,fileName];
        
        
        
        
        NSData *data = [TXTStr dataUsingEncoding:NSUTF8StringEncoding];
        [handle writeData:data];
        
        NSArray  *a_nodes = [document nodesMatchingSelector:@"a"];
        outString = nil;
        document = nil;
        getString = nil;
        error    = nil;
        articleNode = nil;
        
        
        for (HTMLElement *ele in a_nodes) {
            NSLog(@"%@",ele.textContent);
            if ([ele.textContent isEqualToString:@"下一章"]||[ele.textContent isEqualToString:@"下一页"]) {
                NSLog(@"%@",ele.attributes);
                for (NSString *key in ele.attributes.allKeys) {
                    if ([key isEqualToString:@"href"]) {
                        NSString *nextPageStr = [baseURl stringByAppendingString:[ele.attributes objectForKey:key]];
                        DownLoadURL(nextPageStr);
                        return;
                    }
                }
            }
        }
        
//        [handle closeFile];
    }
    
}





int main(int argc, const char * argv[]) {
    @autoreleasepool {
        system([@"rm -rf " stringByAppendingString:fileName].UTF8String);
        system([@"touch " stringByAppendingString:fileName].UTF8String);
        
        handle = [NSFileHandle fileHandleForWritingAtPath:fileName];
        
        
        enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        DownLoadURL(startUrl);
        
        
        
    }
    return 0;
}
