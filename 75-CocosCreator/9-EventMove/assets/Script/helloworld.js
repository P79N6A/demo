

var common = require("common");

cc.Class({
    extends: cc.Component,

    properties: {
        label: {
            default: null,
            type: cc.Label
        },
        sprite: {
            default: null,
            type: cc.Sprite
        },
        monster: {
            default: null,
            type: cc.Sprite
        },
 
        // defaults, set visually when attaching this script to the Canvas
        text: 'Hello, World!'
    },

    monsterMove: function (time){
        
        var tmp = this.monster.node.y;

        var moveUp = cc.moveBy(Math.abs(250-tmp)/200 *time,cc.p(0,250-tmp));
        var moveDown = cc.moveBy(time,cc.p(0,-200));
        var moveUp2 = cc.moveBy(Math.abs(tmp-50)/200 *time,cc.p(0,tmp-50));
        
        this.monster.node.runAction(cc.repeatForever(cc.sequence(moveUp,moveDown,moveUp2)))
    },

    



    // use this for initialization
    onLoad: function () {


        cc.log('onLoad--helloword');

        var nodes = this.node.children;
        cc.log(nodes);
        var monster = this.node.getChildByName('alert');
        cc.log(monster);
        var label = cc.find('alert/New Label',this.node);
        cc.log(label);
        label = cc.find('Canvas/alert/New Label');
        cc.log(label);
        Global.backLabel = label;
        common.backLabel = label;
        this.label.string = this.text;
        this.monsterMove(5);

        var self = this;
        var listener = cc.systemEvent.on(cc.SystemEvent.EventType.KEY_DOWN, (event)=>{
            //alert(123)
            //cc.log(this);
            //cc.log(self);
            switch(event.keyCode){
                case 38:{
                    //alert('shang')
                    //self.sprite.node.y += 50;
                    self.sprite.node.runAction(cc.moveBy(0.001,cc.p(0,50)));
                };
                break;

                case 40:{
                    //alert('xia')
                    //self.sprite.node.y -= 50;
                    self.sprite.node.runAction(cc.moveBy(0.001,cc.p(0,-50)));

                };
                break;

                case 39:{
                    //alert('right')
                    //self.sprite.node.x += 50;
                    self.sprite.node.runAction(cc.moveBy(0.001,cc.p(50,0)));

                };
                break;

                case 37:{
                    //alert('left')
                    //self.sprite.node.x -= 50;
                    self.sprite.node.runAction(cc.moveBy(0.001,cc.p(-50,0)));

                };
                break;
            };
        },this.node);

        return;
        
        var mouseListener = cc.eventManager.addListener({
            event: cc.EventListener.KEYBOARD,
            onKeyPressed:  function(keyCode, event){
                switch(keyCode){
                    case 38:{
                        //alert('shang')
                        self.sprite.node.y += 50;
                    };
                    break;

                    case 40:{
                        //alert('xia')
                        self.sprite.node.y -= 50;

                    };
                    break;

                    case 39:{
                        //alert('right')
                        self.sprite.node.x += 50;

                    };
                    break;

                    case 37:{
                        //alert('left')
                        self.sprite.node.x -= 50;
                    };
                    break;
                }
             }
        }, this.node);
    
    },

    // called every frame
    update: function (dt) {

    },

});


function stop(){
   var cocos = cc.find("Canvas/cocos");
   var monster = cc.find("Canvas/monster");

   monster.stopAllActions();
   cc.systemEvent.off(cc.SystemEvent.EventType.KEY_DOWN, (event)=>{
        alert('callback')
   },this);
}


module.exports = {
    stop: stop,
};

