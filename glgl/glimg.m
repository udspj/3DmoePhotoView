//
//  glimg.m
//  glgl
//
//  Created by udspj on 13-8-9.
//
//

#import "glimg.h"

@implementation glimg

@synthesize effect;
@synthesize position,rotateY,velocity,imgsize;

typedef struct {
    GLKVector3 Position[3];
    GLKVector4 Color[4];
    GLKVector2 Texture[2];
}Vertex;

static Vertex Vertices[] = {
    {{1, -1, 0}, {1, 1, 1, 0.7}, {1, 0}},
    {{1, 1, 0}, {1, 1, 1, 0}, {1, 1}},
    {{-1, 1, 0}, {1, 1, 1, 0}, {0, 1}},
    {{-1, -1, 0}, {1, 1, 1, 0.7}, {0, 0}}
};

//static GLubyte Indices[] = {
//    0, 1, 2,
//    2, 3, 0
//};

-(id)initWithImg:(NSString *)imgName projection:(GLKMatrix4)proMatrix{
    if ((self = [super init])) {
        effect = [[GLKBaseEffect alloc] init];
        NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft,nil];
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:nil];
        
        texture = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
        if (texture == nil) {
            NSLog(@"Error loading file: %@", [error localizedDescription]);
            return nil;
        }
        self.imgsize = CGSizeMake(texture.width, texture.height);
        scaleposition[0] = GLKVector3Make(1, -1, 0);
        scaleposition[1] = GLKVector3Make(1, imgsize.height/imgsize.width, 0);
        scaleposition[2] = GLKVector3Make(-1, imgsize.height/imgsize.width, 0);
        scaleposition[3] = GLKVector3Make(-1, -1, 0);
        promatrix = proMatrix;
    }
    return self;
}
-(void)update:(NSTimeInterval)dt {
    //GLKVector2 distanceTraveled = GLKVector2MultiplyScalar(self.velocity, dt);
    self.position = GLKVector2Add(self.position, self.velocity);
    
}
-(void)render{
    effect.texture2d0.name = texture.name;
    effect.texture2d0.enabled = YES;
    
    effect.transform.projectionMatrix = promatrix;
    
    //正常图形
    modelmatrix = GLKMatrix4MakeTranslation(self.position.x, self.position.y, -10.0f);
    modelmatrix = GLKMatrix4RotateY(modelmatrix, self.rotateY);
    effect.transform.modelviewMatrix = modelmatrix;
    
    [effect prepareToDraw];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    long offset = (long)&Vertices;
    //glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *) (offset + 0));
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, scaleposition);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *) (offset + offsetof(Vertex, Texture)));
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
    //图形的倒影
    modelmatrix = GLKMatrix4Translate(modelmatrix, 0, -2, 0);
    modelmatrix = GLKMatrix4RotateY(modelmatrix, M_PI);
    modelmatrix = GLKMatrix4RotateZ(modelmatrix, M_PI);
    effect.transform.modelviewMatrix = modelmatrix;
    
    [effect prepareToDraw];
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void *) (offset + offsetof(Vertex, Color)));
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    glDisableVertexAttribArray(GLKVertexAttribColor);
}


@end
