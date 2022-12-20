#version 430

in vec3 in_position;
in vec2 in_texcoord_0;
out vec2 uv;

void main() {
    uv = in_texcoord_0;
    gl_Position = vec4(in_position, 1);
}
