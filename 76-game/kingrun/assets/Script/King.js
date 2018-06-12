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
         // 主角跳跃高度
        jumpHeight: 0,
        // 主角跳跃持续时间
        jumpDuration: 0,
        //主角状态
        state:'run',

    },

    //跑
    run:function(){
        var an = this.node.getComponent(cc.Animation);
        this.getComponent(cc.Animation).play('king_run');
        this.state = 'run';
    },


        //跳
    jump:function(){
        if(this.state == 'run'){
            this.state = 'jump';
            this.getComponent(cc.Animation).stop();
            this.node.runAction(cc.sequence(cc.jumpBy(this.jumpDuration, cc.p(0,0), this.jumpHeight, 1),
                                cc.callFunc(function() {
                                    this.run();
                                }, this)));
        }
    },

    //弯腰跑
    down:function(){
        if(this.state == 'run'){
            this.state = 'down';
            this.node.runAction(cc.scaleTo(0.05, 1, 0.5));
        }
    },

    //腰累了
    downRelease:function(){
        if(this.state == 'down'){
            this.node.runAction(cc.sequence(cc.scaleTo(0.05, 1, 1),
                                cc.callFunc(function() {
                                    this.run();
                                }, this)));
        }
    },

    // LIFE-CYCLE CALLBACKS:

    // onLoad () {},

    start () {

    },

    // update (dt) {},
});
