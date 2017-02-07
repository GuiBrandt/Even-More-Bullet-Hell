// Shader de fragmento simples, passa a cor RGBA recebida pelo uniform "color"
// para o programa

#version 150 core

uniform vec4 color;
out vec4 outColor;

void main() {
	outColor = color;
}