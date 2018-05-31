cc.Class({
    extends: cc.Component,

    properties: {
        label: {
            default: null,
            type: cc.Label
        },
        // defaults, set visually when attaching this script to the Canvas
        text: 'Hello, World!',


        ctor: function () {
            // 子构造函数被调用前，父构造函数已经被调用过，所以 this.name 已经被初始化过了
            cc.log("ctor");    // "node"
            // 重新设置 this.name
        }
    
        // userID: 20,
        // height: 20,
        // type: "actor",
        // target: null,
        // obj: cc.Node,
        // pos: cc.Vec2,
        // color: cc.Color,
        // bgColor:  new cc.Color(233,123,123),

        // anys: [],
        // bools: [cc.Boolean],
        // strings: [cc.String],
        // floats: [cc.Float],
        // ints: [cc.Integer],
  
        // values: [cc.Vec2],
        // nodes: [cc.Node],
        // frames: [cc.SpriteFrame],

        // score: {
        //     default: 0,
        //     displayName: "Score (player)",
        //     tooltip: "The score of player",
        // },

        // names: {
        //     default: [],
        //     type: [cc.String]   // 用 type 指定数组的每个元素都是字符串类型
        // },
    
        // enemies: {
        //     default: [],
        //     type: [cc.Node]     // type 同样写成数组，提高代码可读性
        // },
    
  
    },

    

    // use this for initialization
    onLoad: function () {
        this.label.string = this.text;
        //var node = this.getComponent("cc.Label");
        console.log("-------");

   
        // this.node.on('say-hello', function ( event ) {
        //       console.log(eval.type);
        // }.bind(this));

        // // 使用枚举类型来注册
        // this.node.on(cc.Node.EventType.MOUSE_DOWN, this._mouseDown, this);
        // // 使用事件名来注册
        // this.node.on('mousedown', function (event) {
        //     console.log('Mouse down');
        // }, this);

  
        cc.systemEvent.on(cc.SystemEvent.EventType.KEY_DOWN, this.onKeyDown, this);
        cc.systemEvent.on(cc.SystemEvent.EventType.KEY_UP, this.onKeyUp, this);

        //console.log(node);
    },

    onKeyDown: function (event){
        cc.log(event.keyCode)
        console.log("---+onKeyDown+----");

        var node = this.getComponent(cc.Label);

        var action = cc.moveTo(2,100,100);
        this.label.node.runAction(action);

        // var url = 'http://www.gdtv.cn/m2o/channel/channel_info.php?id=25';
        // var xhr = new XMLHttpRequest();
        // xhr.onreadystatechange = function () {
        //     if (xhr.readyState == 4 && (xhr.status >= 200 && xhr.status < 400)) {
        //         var response = xhr.responseText;
        //         console.log(response);
        //     }
        // };
        // xhr.open("GET", url, true);
        // xhr.send();
       
    },
    onKeyUp: function (){
        console.log("---+onKeyUp+----");
    },

    start: function () {
        console.log("---+++----");
        // this.node.emit('say-hello', {
        //   msg: 'Hello, this is Cocos Creator',
        // });
        this.node.dispatchEvent( new cc.Event.EventCustom('say-hello', true) );

      },
    

    // called every frame
    // update: function (dt) {
    //     // console.log(dt)

    //     // var node = this.node;
    //     // node.x = 10;
    // },
});
