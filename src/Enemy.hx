import ceramic.Assets;
import ceramic.Color;
import ceramic.SpriteSheet;

class Enemy extends TaggedSprite {
	public function new(assets:Assets) {
		super([Tags.Enemy], 3, 0);
		initArcadePhysics();

		sheet = new SpriteSheet();
		sheet.texture = assets.texture(Images.ENEMY_1);
		sheet.grid(16, 24);

		sheet.addGridAnimation('idle', [4, 5, 6, 7], 0.1);
		sheet.addGridAnimation('run', [8, 9, 10, 11], 0.1);

		anchor(0.5, 0.5);

		quad.roundTranslation = 1;

		animation = 'idle';

		anchor(0, 2);

		scale(2);

		gravity(0, 0);

		autoComputeSize = true;
	}

	public function takeDamange(fromMainWeapon:Bool, damage:Float) {
		var hit = this.health.takeDamage(fromMainWeapon, damage);

		if (hit) {
			this.tween(QUAD_EASE_IN, 1, 0, 1, (v1, v2) -> {
				if (v1 < 1) {
					this.quad.color = Color.RED;
				} else {
					this.quad.color = Color.WHITE;
				}
			});

			if (this.health.isDead()) {
				this.destroy();
			}
		}
	}

	override function update(dt:Float) {
		super.update(dt);
	}
}
