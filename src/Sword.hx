import ceramic.Assets;
import ceramic.SpriteSheet;

class Sword extends TaggedSprite {
	var rotator:RotatorCenter;

	// var collider:Quad;

	public function new(assets:Assets, rotator:RotatorCenter) {
		super([Tags.PlayerWeapon], 0, 1);
		this.rotator = rotator;

		sheet = new SpriteSheet();
		sheet.texture = assets.texture(Images.PIRATE_MAIN_WEAPON);
		sheet.grid(9, 31);
		sheet.addGridAnimation('default', [0], 0);
		animation = 'default';

		initArcadePhysics();
		arcade.body.updateSize(12, 64);

		anchor(0.5, 0.5);

		scale(2);

		gravity(0, 0);

		// for debugging
		// collider = new Quad();
		// collider.color = Color.RED;

		// collider.x = x;
		// collider.y = y;

		// collider.width = body.width;
		// collider.height = body.height;

		// for debugging
		// onCollide(this, (v1, v2) -> {
		// 	trace('collide sword');
		// 	trace('--');

		// 	collider.color = Color.GREEN;
		// });

		// offCollide((v1, v2) -> {
		// 	trace('off collide sword');
		// 	trace('--');

		// 	collider.color = Color.RED;
		// });

		onCollide(this, (v1, v2) -> {
			log.debug('collide ${v1}, ${v2}');

			if (v2 is Enemy) {
				var enemy:Enemy = cast v2;

				enemy.takeDamange(true, this.damage.value);
			}
		});
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

		// for debugging
		// collider.x = this.body.x;
		// collider.y = this.body.y;
		// collider.rotation = this.rotation;
	}
}
