package game_utils;

import ceramic.Color;
import ceramic.Quad;
import ceramic.Sprite;
import components.*;
import game_utils.Tags;

abstract class TaggedSprite extends Sprite {
	@component public var tags:TagsComponent;
	@component public var health:HealthComponent;
	@component public var damage:DamageComponent;
	@component public var knockback:KnockbackComponent;

	var scaleFactor:Float = 2.0;

	public var collider:Quad;

	public var debug:Bool = false;

	public function new(tags:Array<Tags>, maxHealth:Float, damage:Float, knockback:Float, debug:Bool = false) {
		super();
		scale(scaleFactor, scaleFactor);
		this.debug = debug;
		this.tags = new TagsComponent(tags);
		this.health = new HealthComponent(maxHealth);
		this.knockback = new KnockbackComponent(knockback);
		this.damage = new DamageComponent(damage);

		size(width * scaleFactor, height * scaleFactor);

		if (debug) {
			collider = new Quad();
			collider.color = Color.RED;

			collider.x = x;
			collider.y = y;
			collider.depth = 200;
		}

		onDestroy(null, (v) -> {
			if (collider != null) {
				collider.destroy();
			}
		});
	}

	public override function update(dt:Float):Void {
		super.update(dt);
		if (collider != null) {
			collider.width = width;
			collider.height = height;
			collider.x = x;
			collider.y = y;
			collider.rotation = rotation;
		}
	}
}
