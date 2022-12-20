#version 450

layout (local_size_x = 16, local_size_y = 16, local_size_z = 1) in;

// refer to this https://www.khronos.org/opengl/wiki/Data_Type_(GLSL)#Opaque_types
layout(rgba32f, location=0) uniform image2D texture_buffer;

/*
   +----------+---------+----------+
    1:x-1,y+1 | 2:x,y+1 | 3:x+1,y+1
   +----------+---------+----------+
    4:x-1, y  | 5:x, y  | 6:x+1,y
   +----------+---------+----------+
    7:x-1,y-1 | 8:x,y-1 | 9:x+1,y-1
   +----------+---------+----------+
*/

void main() {
    ivec2 texelIndex = ivec2(gl_GlobalInvocationID.xy);

    int x = texelIndex.x;
    int y = texelIndex.y;

    int v1 = int(imageLoad(texture_buffer, ivec2(x-1,y+1)).w);
    int v2 = int(imageLoad(texture_buffer, ivec2(x  ,y+1)).w);
    int v3 = int(imageLoad(texture_buffer, ivec2(x+1,y+1)).w);
    int v4 = int(imageLoad(texture_buffer, ivec2(x-1,y  )).w);
    int v5 = int(imageLoad(texture_buffer, ivec2(x  ,y  )).w);
    int v6 = int(imageLoad(texture_buffer, ivec2(x+1,y  )).w);
    int v7 = int(imageLoad(texture_buffer, ivec2(x-1,y-1)).w);
    int v8 = int(imageLoad(texture_buffer, ivec2(x  ,y-1)).w);
    int v9 = int(imageLoad(texture_buffer, ivec2(x+1,y-1)).w);

    int vs = v1+v2+v3+v4+v6+v7+v8+v9;

    // If the cell is dead, then it springs to life only in the case that it has 3 live neighbors OR
    // If the cell is alive, then it stays alive if it has either 2 or 3 live neighbors 
    if ((v5 == 0 && vs == 3) || (v5 == 1 && (vs == 2 || vs == 3))) {
        imageStore(texture_buffer, texelIndex, vec4(1));
    }
    else {
        imageStore(texture_buffer, texelIndex, vec4(0));
    }
}