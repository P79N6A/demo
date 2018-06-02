cc.Class({
    extends: cc.Component,

    properties: {
        sheepAnim: {
            default: null,
            type: cc.Animation
        }
        // foo: {
        //    default: null,
        //    url: cc.Texture2D,  // optional, default is typeof default
        //    serializable: true, // optional, default is true
        //    visible: true,      // optional, default is true
        //    displayName: 'Foo', // optional
        //    readonly: false,    // optional, default is false
        // },
        // ...
    },

    // use this for initialization
    onLoad: function () {
        var anim = this.sheepAnim;
        this._playAnimCallback = function() {
            anim.play('sheep_jump');
        };
        this.scheduleOnce(this._playAnimCallback, 2);
    },

    // called every frame
    update: function (dt) {

    },
});
