// Shader de fragmento simples, passa a cor RGBA recebida pelo uniform "color"
// para o programa

#version 110

uniform vec4 color;

void main() {
	gl_FragColor = color;
}