// Shader de vértice 2D básico, passa diretamente os valores recebidos 
// para o programa

#version 150 core

in vec2 vertex;

void main() {
	gl_Position.xy = vertex;
	gl_Position.zw = vec2(0.0, 1.0);
}