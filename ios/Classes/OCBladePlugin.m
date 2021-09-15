#import "OCBladePlugin.h"
#if __has_include(<blade/blade-Swift.h>)
#import <blade/blade-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "blade-Swift.h"
#endif

@implementation OCBladePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [BladePlugin registerWithRegistrar:registrar];
}
@end
