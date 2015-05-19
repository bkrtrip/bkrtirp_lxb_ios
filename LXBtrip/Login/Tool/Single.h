//
//  Single.h
//  LXBtrip
//
//  Created by MACPRO on 15/5/11.
//  Copyright (c) 2015年 LXB. All rights reserved.
//
//.h
#define single_interface(class) +(class *)shared##class;
//.m
#define single_implementation(class) \
static class *instance; \
+ (id)shared##class {   \
if (instance == nil) {  \
instance = [[self alloc] init]; \
}   \
return instance;    \
}   \
+ (id)allocWithZone:(struct _NSZone *)zone {    \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{    \
instance = [super allocWithZone:zone];  \
}); \
return instance;    \
}
