class Outro extends dn.Process {
	public function new() {
		super(Main.ME);
		createRoot(Main.ME.root);

        var wid = Const.AUTO_SCALE_TARGET_WID;
        var hei = Const.AUTO_SCALE_TARGET_HEI;

		var tf = new h2d.Text(Assets.fontLarge, root);
		tf.text = "GAME OVER";
		tf.x = wid*0.475 - tf.textWidth*tf.scaleX*0.5;
		tf.y = hei*0.35;

		var tf = new h2d.Text(Assets.fontMedium, root);
		tf.text = "Score: " + Game.ME.score;
		tf.x = wid*0.475 - tf.textWidth*tf.scaleX*0.5;
		tf.y = hei*0.55;

		var tf = new h2d.Text(Assets.fontTiny, root);
		tf.text = "Click to play again";
		tf.x = wid*0.475 - tf.textWidth*tf.scaleX*0.5;
		tf.y = hei*0.8;

		var i = new h2d.Interactive(w(), h(), root);
		i.onClick = function(_) {
          Main.ME.transition(this, function() new Intro(), 0xff<<24|0x290A33);
        }
    }
}