import ceramic.Sprite;

class RotatorCenter extends Sprite {
	var player:Player;

	public function new(player:Player) {
		super();

		this.player = player;
	}

	override function update(dt:Float) {
		updatePosition(dt);
		updateRotation(dt);

		super.update(dt);
	}

	function updatePosition(dt:Float) {
		this.x = player.x;
		this.y = player.y;
	}

	function updateRotation(dt:Float) {
		rotation += 360 * dt / 3;
	}
}
