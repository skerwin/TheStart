#import "NSArray+IQ_NSArray_SortCxsdcontent.h"
@implementation NSArray (IQ_NSArray_SortCxsdcontent)
+ (BOOL)sortedArrayByTagCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 5 == 0;
}
+ (BOOL)sortedArrayByPositionCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 24 == 0;
}

@end
