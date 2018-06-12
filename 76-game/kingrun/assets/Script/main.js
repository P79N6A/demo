// Learn cc.Class:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/class.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/class.html
// Learn Attribute:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/reference/attributes.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/reference/attributes.html
// Learn life-cycle callbacks:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/life-cycle-callbacks.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/life-cycle-callbacks.html

cc.Class({
    extends: cc.Component,

    properties: {
        // foo: {
        //     // ATTRIBUTES:
        //     default: null,        // The default value will be used only when the component attaching
        //                           // to a node for the first time
        //     type: cc.SpriteFrame, // optional, default is typeof default
        //     serializable: true,   // optional, default is true
        // },
        // bar: {
        //     get () {
        //         return this._bar;
        //     },
        //     set (value) {
        //         this._bar = value;
        //     }
        // },
         king:{
            default:null,
            type:cc.Node,
        },

    },

    // LIFE-CYCLE CALLBACKS:

    onLoad () {
        var self = this;
        //左侧蹲，右侧跳
        this.node.on('touchstart',function(event){
            var visibleSize = cc.director.getVisibleSize();
            
            if(event.getLocationX()<visibleSize.width/2){
                self.king.getComponent('King').down();
                //self.king.down();

                cc.log('down');
            }else{
                self.king.getComponent('King').jump();
                //self.king.jump();

                                cc.log('jump');
            }
        });
        //左侧松手就恢复跑的状态
        this.node.on('touchend',function(event){
            var visibleSize = cc.director.getVisibleSize();
            if(event.getLocationX()<visibleSize.width/2){
                self.king.getComponent('King').downRelease();
            }else{
                // self.king.getComponent('King').jump();
            }
        });

    },

    start () {

    },

    // update (dt) {},
});
