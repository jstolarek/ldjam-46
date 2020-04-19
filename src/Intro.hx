class Intro extends dn.Process {
	public function new() {
		super(Main.ME);
		createRoot(Main.ME.root);

        var wid = Const.AUTO_SCALE_TARGET_WID;
        var hei = Const.AUTO_SCALE_TARGET_HEI;

		var logo = Assets.tiles.h_get("title", 0.5,0.5, root);
        logo.anim.play("title", 9999);
        $type(logo);
		logo.setPosition(wid*0.5, hei*0.3);
		tw.createMs(logo.alpha, 0>1, 1500);

		var tf = new h2d.Text(Assets.fontMedium, root);
		tf.text = "Ludum Dare 46";
		tf.x = wid*0.5 - tf.textWidth*tf.scaleX*0.5;
		tf.y = hei*0.62;

		tw.createMs(tf.alpha, 500|0>1, 1500);

		var i = new h2d.Interactive(w(), h(), root);

		i.onClick = function(_) {
          Main.ME.transition(this, function() new Game());
        }
	}
}
