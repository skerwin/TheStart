#import <UIKit/UIKit.h>
#import "UITextView+PlaceHolder.h"
#import <objc/runtime.h>

@interface UITextView (PlaceHolderCxsdcontent)
+ (BOOL)setPlaceHolderCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)placeHolderCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)textViewChangedCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)textViewBeginChangedCxsdcontent:(NSInteger)CXSDContent;

@end
