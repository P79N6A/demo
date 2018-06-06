cc.Class({
    extends: cc.Component,

    properties: {
        label: {
            default: null,
            type: cc.Label
        },
        audioSource: {
         type: cc.AudioSource,
         default: null
        },
        audio: {
            url: cc.AudioClip,
            default: null
        },


        // defaults, set visually when attaching this script to the Canvas
        text: 'Hello, World!'
    },


    onDestroy: function () {
        cc.audioEngine.stop(this.current);
    },


    play: function () {
        this.audioSource.play();
        alert(123);
    },
    pause: function () {
        this.audioSource.pause();
        alert(456);
    },


    // use this for initialization
    onLoad: function () {
        this.label.string = this.text;
        this.current = cc.audioEngine.play(this.audio, false, 1);
    },

    // called every frame
    update: function (dt) {

    },
});
