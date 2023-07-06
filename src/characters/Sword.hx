package characters;

import ceramic.Assets;
import ceramic.SpriteSheet;
import components.KnockbackComponent;
import game_utils.*;

class Sword extends TaggedSprite {
	var rotator:RotatorCenter;

	// var collider:Quad;

	public function new(assets:Assets, rotator:RotatorCenter, debug:Bool = false) {
		super([Tags.PlayerWeapon], 0, 1, 2, debug);
		this.rotator = rotator;

		sheet = new SpriteSheet();
		sheet.texture = assets.texture(Images.PIRATE_MAIN_WEAPON);
		sheet.grid(9, 31);
		sheet.addGridAnimation('default', [0], 0);
		animation = 'default';

		initArcadePhysics();

		anchor(0.5, 0.5);

		gravity(0, 0);

		size(14, 20);

		onCollide(this, (v1, v2) -> {
			if (v2 is Enemy) {
				var enemy:Enemy = cast v2;

				var wasHit = enemy.takeDamage(true, this.damage.value, this.knockback.value);

				if (wasHit && enemy.health.isDead()) {
					enemy.dispose();
				}
			}
		});

		depth = 100;
	}

	override function update(dt:Float) {
		updateRotationAndPosition(dt);
		super.update(dt);
	}

	function updateRotationAndPosition(dt:Float) {
		var angleInRadians = rotator.rotation * Math.PI / 180;
		var _x = Math.cos(angleInRadians) * 20;
		var _y = Math.sin(angleInRadians) * 20;

		// the player sprite is 16x24, but the sword is 9x31
		this.x = (rotator.x + _x * 4 - (16 - 9) + 4);
		this.y = (rotator.y + _y * 4 + 4); // no need to adjust for y

		this.rotation = rotator.rotation + 90;

		arcade.body.rotation = this.rotation;
	}
}
