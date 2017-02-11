// Shader de fragmento simples para mapear texturas
// A textura é recebida pelo uniform `sampler` e as coordenadas UV pelo uniform
// `uv`

#version 110

uniform sampler2D sampler;
uniform vec2 uv;

void main() {
	gl_FragColor = texture(sampler, uv).rgba;
}