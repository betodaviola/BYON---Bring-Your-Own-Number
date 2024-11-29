// invert_vertex.glsl
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

attribute vec4 position; // The position of the vertex
attribute vec2 texcoord; // The texture coordinate of the vertex

varying vec2 texCoord; // Pass the texture coordinate to the fragment shader

void main() {
    texCoord = texcoord; // Pass the texture coordinate to the fragment shader
    gl_Position = position; // Set the position of the vertex
}
