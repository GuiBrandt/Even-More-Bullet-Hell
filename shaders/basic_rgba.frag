// Shader de fragmento simples, passa a cor RGBA recebida pelo uniform "color"
// para o programa

#version 130

uniform vec4 color;
out vec4 out_color;

void main() {
	out_color = color;
}