// Shader de vértice 2D básico, passa diretamente os valores recebidos 
// para o programa

#version 130

in vec4 vertex;

out vec4 tex_coord;

void main() {
	gl_Position.xy = vertex.xy;
	tex_coord.xy = vertex.zw;
}