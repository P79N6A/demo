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
        }

    },

    //判断高空导弹来时，猴哥是否蹲下(响应之前设置的帧事件)
    judgeDown:function(){
        if(this.king.getComponent('King').state == 'down'){
            console.log("down---------------------");
        }else{
            cc.director.loadScene('over');
        }
    },  

    //判断低空导弹来时，猴哥是否跳起
    judgeJump:function(){
        if(this.king.getComponent('King').state == 'jump'){
            console.log("jump---------------------");
        }else{
            cc.director.loadScene('over');
        }
    },

    // LIFE-CYCLE CALLBACKS:

    onLoad () {
        let self = this;
        //每隔2秒随机发射高空和低空导弹
        this.schedule(function(){
            if(Math.random()>0.5){
                this.getComponent(cc.Animation).play('bomb_high');
            }else{
                this.getComponent(cc.Animation).play('bomb_low');
            }
        },5);

    },

    start () {

    },

    // update (dt) {},
});
