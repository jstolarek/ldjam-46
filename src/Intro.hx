class Intro extends dn.Process {
	public function new() {
		super(Main.ME);
		createRoot(Main.ME.root);

		var tf = new h2d.Text(Assets.fontMedium, root);
		tf.text = "Ludum Dare 46";
		tf.x = 512*0.5 - tf.textWidth*tf.scaleX*0.5;
		tf.y = 288*0.62;

		tw.createMs(tf.alpha, 500|0>1, 500);

		var i = new h2d.Interactive(w(), h(), root);

		i.onClick = function(_) {
          Main.ME.transition(this, function() new Game());
        }
	}
}
