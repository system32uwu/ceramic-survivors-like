import ceramic.Sprite;

abstract class TaggedSprite extends Sprite {
	@component public var tags:TagsComponent;
	@component public var health:HealthComponent;
	@component public var damage:DamageComponent;

	public function new(tags:Array<Tags>, maxHealth:Float, damage:Float) {
		super();
		this.tags = new TagsComponent(tags);
		this.health = new HealthComponent(maxHealth);
		this.damage = new DamageComponent(damage);
	}
}
