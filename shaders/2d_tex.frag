// Shader de fragmento simples para mapear texturas
// A textura é recebida pelo uniform `sampler` e as coordenadas UV pelo uniform
// `uv`

#version 130

uniform sampler2D sampler;

in vec4 tex_coord;

out vec4 out_color;

void main() {
	out_color = texture(sampler, tex_coord.xy).rgba;
}