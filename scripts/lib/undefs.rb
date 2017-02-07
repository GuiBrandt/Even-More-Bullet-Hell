=begin 

	undefs.rb

	Remoção de algumas classes que não deveriam existir na engine e alias para
	funções com nome do RGSS

=end

Object.__send__ :remove_const, :Plane
Object.__send__ :remove_const, :RPG
Object.__send__ :remove_const, :Sprite
Object.__send__ :remove_const, :Tilemap
Object.__send__ :remove_const, :Window

alias bz_main rgss_main
undef rgss_main

alias bz_stop rgss_stop
undef rgss_stop