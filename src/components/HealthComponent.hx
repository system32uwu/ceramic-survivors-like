package components;

import ceramic.Timer;

class HealthComponent extends ValueComponent {
	public var mainWeaponHitDuration:Float = 1; // enemy can't be hit with main weapon more than once per second
	public var lastHitWithMainWeapon:Float = 0;

	public function new(maxHealth:Float) {
		super(maxHealth, maxHealth);
	}

	// fromMainWeapon is true if the damage is from the player main weapon, otherwise it's always false
	public function takeDamage(fromMainWeapon:Bool, damage:Float = 1.0) {
		if (fromMainWeapon) {
			if (this.isInvulnerableToMainWeapon()) {
				return false;
			}
		}

		this.value -= damage;
		this.lastHitWithMainWeapon = Timer.now;

		return true;
	}

	public function isInvulnerableToMainWeapon():Bool {
		return this.lastHitWithMainWeapon + this.mainWeaponHitDuration > Timer.now;
	}

	public function heal(amount:Float) {
		this.increaseByAmount(amount > maxValue ? maxValue : amount);
	}

	public function isDead():Bool {
		return value <= 0;
	}
}
