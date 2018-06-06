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
        cc.sys.localStorage.setItem('userName','czljcb');
    },

    // called every frame
    update: function (dt) {

    },

    btnClick () {


        cc.log(cc.sys.capabilities);
        return;
        this.label.string = cc.sys.localStorage.getItem('userName');        
        cc.log(cc.sys.localStorage.getItem('userName'));
        return;
        alert('is windowPixelResolution  = ' + cc.sys.windowPixelResolution.toString);
        console.log(cc.sys.windowPixelResolution.width);
        
        return;
        alert('is browserVersion  = ' + cc.sys.browserVersion);
        return;
        alert('is browserType  = ' + cc.sys.browserType);
        return;
        alert('is os  = ' + cc.sys.os);
        return;
        alert('is language  = ' + cc.sys.language);
        return;
        alert('is platform  = ' + cc.sys.platform);
        return;
        alert('is browser system = ' + cc.sys.isBrowser);
        return;
        alert('is mobile system = ' + cc.sys.isMobile);
        return;
        alert('is native system = '+cc.sys.isNative);
        return;
        cc.sys.openURL('http://www.jianshu.com');
        return;
        cc.director.loadScene("game", function () {
            alert(123)
        });
    },


});
