#import "IQBarButtonItemConfiguration+Cxsdcontent.h"
@implementation IQBarButtonItemConfiguration (Cxsdcontent)
+ (BOOL)initWithBarButtonSystemItemActionCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 8 == 0;
}
+ (BOOL)initWithImageActionCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 14 == 0;
}
+ (BOOL)initWithTitleActionCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 32 == 0;
}

@end
