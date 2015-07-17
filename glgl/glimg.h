//
//  glimg.h
//  glgl
//
//  Created by udspj on 13-8-9.
//
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface glimg : NSObject{
    GLKTextureInfo *texture;
    GLKMatrix4 promatrix;
    GLKMatrix4 modelmatrix;
    GLKVector3 scaleposition[4];
}

@property(strong)GLKBaseEffect *effect;

@property(assign)GLKVector2 position;
@property(assign)GLKVector2 velocity;
@property(assign)float rotateY;
@property(assign)CGSize imgsize;

-(id)initWithImg:(NSString *)imgName projection:(GLKMatrix4)proMatrix;

-(void)render;
-(void)update:(NSTimeInterval)dt;

@end
