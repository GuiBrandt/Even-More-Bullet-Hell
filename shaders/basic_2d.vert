// Shader de vértice 2D básico, passa diretamente os valores recebidos 
// para o programa

#version 130

in vec2 vertex;

void main() {
	gl_Position.xy = vertex;
}