//
//  imgsViewController.h
//  glgl
//
//  Created by udspj on 13-8-9.
//
//

#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>
#import "glimg.h"

@interface imgsViewController : GLKViewController{
    GLKMatrix4 projectionmatrix;
    int picnum;
    int midnum;
    int i;
    float dis;
    float movedis;
    BOOL isleft;
    BOOL change;
    NSArray *picarray;
    NSMutableArray *imgarray;
    CGPoint touchpoint;
}

@property(strong)EAGLContext *context;
@property(strong)GLKBaseEffect *effect;

-(void)buildPictures;

@end
