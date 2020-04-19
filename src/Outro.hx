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
    }
}
