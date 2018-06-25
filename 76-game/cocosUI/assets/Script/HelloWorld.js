cc.Class({
    extends: cc.Component,

    properties: {
        label: {
            default: null,
            type: cc.Label
        },
        // defaults, set visually when attaching this script to the Canvas
        text: 'Hello, World!'
    },

    // use this for initialization
    onLoad: function () {
        this.label.string = this.text;


    },

    clickAction: function(e,d){
        cc.log(e.target);
        cc.log(this.node);

        cc.log(d);

        var ret = jsb.reflection.callStaticMethod("NativeOcClass", 
                                           "callNativeUIWithTitle:andContent:",
                                           "cocos2d-js", 
                                           "Yes! you call a Native UI from Reflection");
    },

    // called every frame
    update: function (dt) {

    },
});
