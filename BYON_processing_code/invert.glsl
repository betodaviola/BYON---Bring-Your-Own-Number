// invert.glsl
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture; // The input texture
varying vec2 texCoord;     // The texture coordinates

void main() {
    vec4 color = texture2D(texture, texCoord); // Get the color of the current pixel
    gl_FragColor = vec4(vec3(1.0) - color.rgb, color.a); // Invert the colors
}
