package components;

import ceramic.Component;
import ceramic.Entity;
import ceramic.Timer;
import ceramic.Visual;

class HealthComponent extends Entity implements Component {
	public var health:Float;
	public var maxHealth:Float;

	var lastHitWithMainWeapon:Float = 0;

	/**
	 * This will be the visual we attached to
	 */
	@entity var visual:Visual;

	public function new(maxHealth:Float) {
		super();

		this.maxHealth = maxHealth;
		this.health = maxHealth;
	}

	// fromMainWeapon is true if the damage is from the player main weapon, otherwise it's always false
	public function takeDamage(fromMainWeapon:Bool, damage:Float = 1.0) {
		if (fromMainWeapon) {
			if ((this.lastHitWithMainWeapon + 1 > Timer.now)) {
				return false;
			}
		}

		this.health -= damage;
		this.lastHitWithMainWeapon = Timer.now;

		trace("health: " + this.health);

		return true;
	}

	public function heal(amount:Float) {
		health += amount;
		if (health > maxHealth) {
			health = maxHealth;
		}
	}

	public function isDead():Bool {
		return health <= 0;
	}

	function bindAsComponent() {}
}
