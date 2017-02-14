# Projétil simples, anda em movimento retilíneo uniforme

WIDTH = 1.0 / 96.0
HEIGHT = 1.0 / 96.0

DEFAULT_SPEED = 1.0 / 24.0

#--------------------------------------------------------------------------
# Construtor
#--------------------------------------------------------------------------
def initialize shooter, angle = 0.0, speed = DEFAULT_SPEED	
	pos = shooter.position

	super(
		shooter,
		pos.x - WIDTH / 2, pos.y - HEIGHT / 2,
		pos.x + WIDTH / 2, pos.y + HEIGHT / 2,
		angle
	)
	
	self.velocity = Vec2.for_angle(angle) * speed
end
#--------------------------------------------------------------------------
# Cor do objeto
#--------------------------------------------------------------------------
def color
	if shooter.is_a? Player
		return Color.new(0, 255, 255)
	else
		return Color.new(255, 255, 0)
	end
end