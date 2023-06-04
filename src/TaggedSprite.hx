import ceramic.Sprite;

abstract class TaggedSprite extends Sprite {
	@component public var tags:TagsComponent;

	public function new(tags:Array<Tags>) {
		super();
		this.tags = new TagsComponent(tags);
	}
}
