package game_utils;

import ceramic.Sprite;

class RotatorCenter extends Sprite {
	var player:Sprite;

	public function new(player:Sprite) {
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
