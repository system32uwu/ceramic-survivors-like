package characters;

import ceramic.Assets;
import ceramic.Color;
import ceramic.SpriteSheet;
import ceramic.Timer;
import game_utils.TaggedSprite;
import game_utils.Tags;

class Enemy extends TaggedSprite {
	public var player:Player;
	public var playerPosOffsetX:Float;
	public var playerPosOffsetY:Float;
	public var randomXSpeed:Float;
	public var randomYSpeed:Float;

	var minXSpeed:Float = 1;
	var minYSpeed:Float = 1;
	var maxXSpeed:Float = 1.6;
	var maxYSpeed:Float = 1.8;
	var currentKnockbackX:Float = 0;
	var currentKnockbackY:Float = 0;

	var angle:Float = 0;
	var _dx:Float = 0;
	var dx:Float = 0;
	var dy:Float = 0;

	var lastPathCalculation:Float = 0;

	public function new(assets:Assets, player:Player, debug:Bool = false) {
		super([Tags.Enemy], 3, 0, 3, debug);
		initArcadePhysics();
		this.player = player;

		sheet = new SpriteSheet();
		// sheet.texture = assets.texture(Images.ENEMY_1);
		// sheet.grid(16, 24);

		// sheet.addGridAnimation('idle', [4, 5, 6, 7], 0.1);
		// sheet.addGridAnimation('run', [8, 9, 10, 11], 0.1);

		sheet.texture = assets.texture(Images.ENEMY_1V_2);
		sheet.grid(16, 24);

		sheet.addGridAnimation('idle', [4, 5, 6, 7], 0.1);
		sheet.addGridAnimation('run', [8, 9, 10, 11], 0.1);
		sheet.addGridAnimation('attack', [12, 13, 14, 15], 0.125);

		quad.roundTranslation = 1;

		animation = 'idle';

		anchor(0.5, 0.5);

		gravity(0, 0);

		// size(24, 24);

		makeOffsets();
		makeSpeeds();
	}

	function makeOffsets() {
		playerPosOffsetX = (Math.random() * 10) * (Math.random() > 0.5 ? 1 : -1);
		playerPosOffsetY = (Math.random() * 10) * (Math.random() > 0.5 ? 1 : -1);
	}

	function makeSpeeds() {
		randomXSpeed = (Math.random() + 1 * maxXSpeed);
		randomYSpeed = (Math.random() + 1 * maxYSpeed);
	}

	public function takeDamage(fromMainWeapon:Bool, damage:Float, knockback:Float) {
		var hit = this.health.takeDamage(fromMainWeapon, damage);

		if (hit) {
			this.tween(QUAD_EASE_IN, this.health.mainWeaponHitDuration / 3, 0.8, 1, (v1, v2) -> {
				this.quad.alpha = v1;
				this.quad.color = v1 < 0.95 ? Color.RED : Color.WHITE;

				currentKnockbackX = (Math.random() * knockback) * -1;
				currentKnockbackY = (Math.random() * knockback) * -1;

				if (v2 == this.health.mainWeaponHitDuration / 3) {
					currentKnockbackX = 0;
					currentKnockbackY = 0;
				}
			});
		}

		return hit;
	}

	function makePath() {
		// in order to avoid all enemies going to the exact same spot, we'll add a random offset to the player's position
		_dx = player.x - x + playerPosOffsetX;

		dx = _dx;
		dy = player.y - y + playerPosOffsetY;

		dx = dx < 0 ? dx - player.width / 4 : dx + player.width / 4;
		dy = dy < 0 ? dy - player.height / 4 : dy + player.height / 4;

		angle = Math.atan2(dy, dx);

		this.lastPathCalculation = Timer.now;
	}

	override function update(dt:Float) {
		if (Timer.now >= this.lastPathCalculation + 0.25) {
			makePath();
		}

		velocityX = (Math.cos(angle) * 50) * randomXSpeed * (currentKnockbackX != 0 ? currentKnockbackX : 1);
		velocityY = (Math.sin(angle) * 50) * randomYSpeed * (currentKnockbackY != 0 ? currentKnockbackY : 1);

		scaleX = ((velocityX > 1 && _dx > 1) ? scaleFactor : -scaleFactor);

		// using dx and dy, calculate if the player is in range to be hit
		// if so, attack
		// if not, move towards player
		if (Math.abs(dx) <= width + playerPosOffsetX && Math.abs(dy) <= height + playerPosOffsetY) {
			// attack
			velocityX /= 1000;
			velocityY /= 1000;
			animation = 'attack';
		} else {
			animation = 'run';
		}

		super.update(dt);
	}
}
