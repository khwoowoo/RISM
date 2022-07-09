"use strict";
//myAudio.pause(); // 일시 정지
const canvas = document.getElementById("jsCanvas");
const context = canvas.getContext("2d");
const WindowSizeX = canvas.width;
const WindowSizeY = canvas.height;

let deltatime = 0.378;
// const imageElem = new Image();

// imageElem.src = "resource/player/_player (3).png";
// imageElem.onload = function draw(){
//     context.drawImage(imageElem, 1, 1, imageElem.width / 2, imageElem.height / 2);//이미지1
// }


class Obj{
    constructor(filename, x, y){
        this.x = x;
        this.y = y;
        this.sprite = new Image();
        this.sprite.src = filename;
        this.sprite.onload = ()=>{
            context.drawImage(this.sprite, this.x, this.y, this.sprite.width / this.ratio, this.sprite.height / this.ratio);
        }
        this.ratio = 2;
        this.isDestroy = false;
    }

    getRandomInt(min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min)) + min; //최댓값은 제외, 최솟값은 포함
    }

    init(){}
    draw(){}
    update(event){}
}

class button extends Obj{
    constructor(scene, state, x, y){
        super(`resource/ingame/${state}.png`, x, y);
        this.scene = scene;
        this.state = state;
        this.isClick = false;
    }

    
    setPosistion(x, y){
        this.x = x;
        this.y = y;
    }

    init(){

    }

    draw(){
        context.drawImage(this.sprite, this.x, this.y, this.sprite.width / this.ratio, this.sprite.height / this.ratio);
    }

    Collision(event){
        let x = event.offsetX;
        let y = event.offsetY ;
        
        if(this.x <= x && x <= this.x + this.sprite.width / this.ratio &&
            this.y <= y && y <= this.y + this.sprite.height / this.ratio){
            if(event.type === 'click'){
                this.isClick = true;
            }else{
                this.isClick = false;
            }
            this.ratio = 1.7;
        }else{
            this.ratio = 2;
            this.isClick = false;
        }
    }

    databaseUpdate(){
        const form = document.getElementById('jsForm');
        const input = form.querySelector('#jsScore');
        const submit = form.querySelector('#jsSubmit');
        input.value = this.scene.player1.score;
        submit.click();
    }

    update(event){
        this.Collision(event);
        if(this.isClick === true){
            console.log('click');
            this.databaseUpdate();
            if(this.state === 'replay'){
                //location.reload();
            }else{
                //location.href = 'index.html';
            }
            this.isClick = false;
        }
    }
}

class EndUI extends Obj{
    constructor(scene, state){
        super(`resource/ingame/${state}.png`, WindowSizeX / 20, WindowSizeY / 15);
        this.scene = scene;
 
    }

    
    setPosistion(x, y){
        this.x = x;
        this.y = y;
    }

    init(){

    }

    draw(){
        context.drawImage(this.sprite, this.x, this.y, this.sprite.width / this.ratio, this.sprite.height / this.ratio);
    }


    update(event){
    }
}

class Background extends Obj{
    constructor(scene, x, y, type){
        super(`resource/background/background${type} (1).png`, x, y);
        this.scene = scene;
        this.speed = 10;
        this.curTime = 0;
        this.aniTime = 5;
        this.spriteCount = 4;
        this.curNum = 1;
        this.ratio = 1.8;
        this.type = type
        console.log(this.y, this.sprite.height / this.ratio);
    }

    
    setPosistion(x, y){
        this.x = x;
        this.y = y;
    }

    init(){

    }

    draw(){
        context.drawImage(this.sprite, this.x, this.y, this.sprite.width / this.ratio, this.sprite.height / this.ratio);
    }

    move(){
        this.y += this.speed * deltatime;
        if(this.y > WindowSizeY){
            this.y = WindowSizeY + 10 + (this.sprite.height / this.ratio) * (-2);
        }
    }

    Animation(){
        this.curTime += deltatime;

        if(this.aniTime < this.curTime){
            this.curNum++;

            if(this.curNum === this.spriteCount){
                this.curNum = 1;
            }
            this.sprite.src = `resource/background/background${this.type} (${this.curNum}).png`;
            this.curTime = 0;
        }
    }


    update(event){
        this.move();
        this.Animation();
    }
}

class Damage extends Obj{
    constructor(scene){
        super('resource/damage1.png', 0, 0);
        this.scene = scene;

        this.curTime = 0;
        this.aniTime = 25;
    }
    
    init(){

    }

    draw(){
        context.drawImage(this.sprite, this.x, this.y, this.sprite.width / this.ratio, this.sprite.height / this.ratio);
    }


    update(event){
        this.curTime += deltatime;

        if(this.aniTime < this.curTime && this.isDestroy === false){
            let pos = 0;
            let index = 0;
            this.scene.uiList.forEach(i=>{
                if(i === this){
                    pos = index;
                }
                index++;
            });
            this.scene.uiList.splice(pos, 1);
            this.isDestroy = true;
            delete this;
        }

    }
}

class Effect extends Obj{
    constructor(scene, x, y, type){
        super(`resource/effect/effect${type} (1).png`, x, y);
        this.scene = scene;
        this.type = type;

        this.curTimeAni = 0;
        this.aniTime = 5;
        this.spriteCount = 4;
        this.curNum = 1;
    }

    
    setPosistion(x, y){
        this.x = x;
        this.y = y;
    }

    init(){

    }

    draw(){
        context.drawImage(this.sprite, this.x, this.y, this.sprite.width / this.ratio, this.sprite.height / this.ratio);
    }

    Animation(){
        this.curTimeAni += deltatime;

        if(this.isDestroy === false && this.aniTime < this.curTimeAni){
            this.curNum++;

            if(this.curNum === this.spriteCount){
                this.curNum = 1;

                this.Delelte();
            }
            this.sprite.src = `resource/effect/effect${this.type} (${this.curNum}).png`;
            this.curTimeAni = 0;
        }
    }


    Delelte(){
        let pos = 0;
        let index = 0;
        this.scene.uiList.forEach(i=>{
            if(i === this){
                pos = index;
            }
            index++;
        });
        this.scene.uiList.splice(pos, 1);
        this.isDestroy = true;
        delete this;
    }

    update(event){
        this.Animation();
    }
}


class EnemyAtt extends Obj{
    constructor(scene, filename, x, y, type){
        super(filename, x, y);
        this.scene = scene;
        this.speed = 7;
        this.power = 10;
        this.type = type;
        this.ratio = 1.5;

        if (type === 100){
            this.ratio = 1.7;
        }
    }
    
    init(){

    }

    draw(){
        context.drawImage(this.sprite, this.x, this.y, this.sprite.width / this.ratio, this.sprite.height / this.ratio);
    }

    Delelte(){
        let pos = 0;
        let index = 0;
        //console.log(this.scene.enemyAttList);
        this.scene.enemyAttList.forEach(i=>{
            if(i === this){
                pos = index;
            }
            index++;
        });
        this.scene.enemyAttList.splice(pos, 1);
        this.isDestroy = true;
        delete this;
    }

    move(){
        if(this.type === 1){
            this.y += this.speed * deltatime;
            this.x += this.speed * deltatime * 0.5;
        }
        else if(this.type === 2){
            this.y += this.speed * deltatime;
            this.x += this.speed * deltatime * 0.2;
        }
        else if(this.type === 3){
            this.y += this.speed * deltatime;
        }
        else if(this.type === 4){
            this.y += this.speed * deltatime;
            this.x -= this.speed * deltatime * 0.2;
        }
        else if(this.type === 5){
            this.y += this.speed * deltatime;
            this.x -= this.speed * deltatime * 0.5;
        }
        else if(this.type === 100){
            this.y += this.speed * deltatime;
        }
    
        if(this.isDestroy === false && this.y > 720){
            this.Delelte();
        }
    }

    Collision(){
        if(this.type === 100){
            const length = Math.sqrt(Math.pow(this.x - this.scene.player1.x + 100, 2) +  Math.pow(this.y - this.scene.player1.y + 200, 2));
            if(this.isDestroy === false && length <= 100){
                console.log('EnemyAtt: Collision');
                this.scene.player1.heath -= this.power;
                this.scene.uiList.push(new Damage(this.scene));
    
                this.Delelte();
            }
        }
        else{
            const length = Math.sqrt(Math.pow(this.x - this.scene.player1.x + 30, 2) +  Math.pow(this.y - this.scene.player1.y, 2));
            if(this.isDestroy === false && length <= 70){
                console.log('EnemyAtt: Collision');
                this.scene.player1.heath -= this.power;
                this.scene.uiList.push(new Damage(this.scene));
    
                this.Delelte();
            }
        }

       
    }

    update(event){
        this.move();
        this.Collision();
    }
}

class MidBoss extends Obj{
    constructor(scene, x, y){
        super(`resource/enemy/midboss (1).png`, x, y);
        this.scene = scene;
        this.speed = 3;
        this.heath = 100;
        this.type = 100;
        this.ratio = 1.5;
        this.isMove = true;
        this.isAtt = false;

        this.isAtt = true;
        this.curTimeAtt = 0;
        this.attTime = 3;

        this.curTimeAni = 0;
        this.aniTime = 5;
        this.spriteCount = 19;
        this.curNum = 1;

        this.healthBar = new HealthBar(this, 'resource/healthbar.png', this.x + 40, this.y + 20, 3);
        this.scene.uiList.push(this.healthBar);

    }

    
    setPosistion(x, y){
        this.x = x;
        this.y = y;
    }

    init(){

    }

    draw(){
        context.drawImage(this.sprite, this.x, this.y, this.sprite.width / this.ratio, this.sprite.height / this.ratio);
    }

    move(){
        if(this.isMove === true){
            this.y += this.speed * deltatime;
            this.healthBar.y = this.y;
        }

        if(this.y > 10){
            this.isMove = false;
        }
    }
    Animation(){
        this.curTimeAni += deltatime;

        if(this.aniTime < this.curTimeAni){
            this.curNum++;

            if(this.curNum === this.spriteCount){
                this.curNum = 1;
            }

            if(this.curNum === 11){
                this.isAtt = true;
            }
            this.sprite.src = `resource/enemy/midboss (${this.curNum}).png`;
            this.curTimeAni = 0;
        }
    }

    Att(){
        if(this.isAtt === true){
            for(let i = 1; i < 6; i ++){
                const att = new EnemyAtt(this.scene, 'resource/enemy/enemy_bullet_4.png', this.x + 150, this.y + 100, i);
                this.scene.enemyAttList.push(att);
            }
            const att = new EnemyAtt(this.scene, 'resource/enemy/stone1.png', this.getRandomInt(0, WindowSizeX), -200, 100);
            this.scene.enemyAttList.push(att);
            this.isAtt = false;
        }
    }

    Delelte(){
        this.healthBar.Delelte();
        let pos = 0;
        let index = 0;
        this.scene.enemyList.forEach(i=>{
            if(i === this){
                pos = index;
            }
            index++;
        });
        this.scene.enemyList.splice(pos, 1);
        this.isDestroy = true;
        delete this;
    }

    update(event){
        // console.log(event, event.key, event.type);
        this.move();
        this.Animation();
        this.Att();
        
        if(this.isDestroy === false && this.heath < 0){
            this.scene.player1.score += 1000;
            this.scene.Background1.type = 2;
            this.scene.Background2.type = 2;
            this.scene.isCreateMonster = true;
            this.Delelte();
        }
    }
}

class LastBoss extends Obj{
    constructor(scene, x, y){
        super(`resource/enemy/lastboss (1).png`, x, y);
        this.scene = scene;
        this.speed = 3;
        this.heath = 100;
        this.type = 101;
        this.ratio = 1.5;
        this.isMove = true;
        this.direction = -1;
        this.isAtt = false;

        this.isAtt = true;
        this.curTimeAtt = 0;
        this.attTime = 3;

        this.curTimeAni = 0;
        this.aniTime = 5;
        this.spriteCount = 12;
        this.curNum = 1;

        this.healthBar = new HealthBar(this, 'resource/healthbar.png', this.x + 40, this.y + 20, 3);
        this.scene.uiList.push(this.healthBar);

    }

    
    setPosistion(x, y){
        this.x = x;
        this.y = y;
    }

    init(){

    }

    draw(){
        context.drawImage(this.sprite, this.x, this.y, this.sprite.width / this.ratio, this.sprite.height / this.ratio);
    }

    move(){
        if(this.isMove === true){
            this.y += this.speed * deltatime;
            this.healthBar.y = this.y;
        }else{
            this.x += this.speed * deltatime * this.direction;
            this.healthBar.x = this.x + 40;

            if(this.x + 100 < 0){
                this.direction = 1;
            }
            else if(this.x > WindowSizeX - 200){
                this.direction = -1;
            }
        }

        if(this.y > 10){
            this.isMove = false;
        }
        
    }
    Animation(){
        this.curTimeAni += deltatime;

        if(this.aniTime < this.curTimeAni){
            this.curNum++;

            if(this.curNum === this.spriteCount){
                this.curNum = 1;
            }

            if(this.curNum === 10){
                this.isAtt = true;
            }
            this.sprite.src = `resource/enemy/lastboss (${this.curNum}).png`;
            this.curTimeAni = 0;
        }
    }

    Att(){
        if(this.isAtt === true){
            for(let i = 1; i < 6; i ++){
                const att = new EnemyAtt(this.scene, 'resource/enemy/enemy bullet_3.png', this.x + 150, this.y + 100, i);
                this.scene.enemyAttList.push(att);
            }
            const att = new EnemyAtt(this.scene, 'resource/enemy/stone1.png', this.getRandomInt(0, WindowSizeX), -200, 100);
            this.scene.enemyAttList.push(att);
            this.isAtt = false;
        }
    }

    Delelte(){
        this.healthBar.Delelte();
        let pos = 0;
        let index = 0;
        this.scene.enemyList.forEach(i=>{
            if(i === this){
                pos = index;
            }
            index++;
        });
        this.scene.enemyList.splice(pos, 1);
        this.isDestroy = true;
        delete this;
    }

    update(event){
        // console.log(event, event.key, event.type);
        this.move();
        this.Animation();
        this.Att();
        
        if(this.isDestroy === false && this.heath < 0){
            this.scene.player1.score += 2000;
            this.scene.Background1.type = 2;
            this.scene.Background2.type = 2;
            this.scene.isCreateMonster = true;
            this.scene.isWin = true;
            this.Delelte();
        }
    }
}

class Enemy extends Obj{
    constructor(scene, x, y, type){
        super(`resource/enemy/enemy${type} (1).png`, x, y);
        this.scene = scene;
        this.speed = 7;
        this.heath = 100;
        this.type = type;
        this.attPow = 10;

        this.isAtt = true;
        this.curTimeAtt = 0;
        this.attTime = 3;

        this.curTimeAni = 0;
        this.aniTime = 5;
        this.spriteCount = 3;
        this.curNum = 1;

        this.healthBar = new HealthBar(this, 'resource/healthbar.png', this.x + 25, this.y - 10, 10);
        this.scene.uiList.push(this.healthBar);

        this.setType(type);
    }

    
    setPosistion(x, y){
        this.x = x;
        this.y = y;
    }

    init(){

    }

    draw(){
        context.drawImage(this.sprite, this.x, this.y, this.sprite.width / this.ratio, this.sprite.height / this.ratio);
    }

    setType(type){
        if(type === 3 || type === 4){
            this.attPow = 15;
        }

        if(type === 2 || type === 4){
            this.speed = 15;
        }
    }

    move(){
        this.y += this.speed * deltatime;
        this.healthBar.y = this.y;

        if(this.isDestroy === false && this.y + 20 > WindowSizeY){
            console.log('Enemy: die');
            this.Delelte();
        }
    }
    Animation(){
        this.curTimeAni += deltatime;

        if(this.aniTime < this.curTimeAni){
            this.curNum++;

            if(this.curNum === this.spriteCount){
                this.curNum = 1;
            }
            this.sprite.src = `resource/enemy/enemy${this.type} (${this.curNum}).png`;
            this.curTimeAni = 0;
        }
    }

    Att(){
        if(this.isAtt === false){
            this.curTimeAtt += deltatime;
            if( 5 < this.curTimeAtt){
                this.curTimeAtt = 0;
                this.isAtt = true;
            }
        }


        if(this.isAtt === true && this.spaceBtn === true){
            const att = new Att(this.scene, 'resource/bullet/player_bullet_2.png', this.x + 20, this.y - 25);
            this.scene.objList.push(att);
            this.spaceBtn = false; 
            this.isAtt = false;
        }
    }

    Delelte(){
        this.healthBar.Delelte();
        let pos = 0;
        let index = 0;
        this.scene.enemyList.forEach(i=>{
            if(i === this){
                pos = index;
            }
            index++;
        });
        this.scene.enemyList.splice(pos, 1);
        this.isDestroy = true;
        delete this;
    }

    Collision(){
        const length = Math.sqrt(Math.pow(this.x - this.scene.player1.x + 30, 2) +  Math.pow(this.y - this.scene.player1.y, 2));

        if(this.isDestroy === false && length <= 70){
            console.log('Enemy: Collision');
            this.scene.player1.heath -= this.attPow;
            this.scene.uiList.push(new Damage(this.scene));

            this.Delelte();
        }
        else if(this.isDestroy === false && this.heath < 0){
            const probability = this.getRandomInt(1, 6);
            if(probability < 4){
                this.scene.objList.push(new Item(this.scene, this.x, this.y, this.getRandomInt(1, 4)));
            }
            this.Delelte();
        }
    }

    update(event){
        // console.log(event, event.key, event.type);
        this.move();
        this.Animation();
        this.Collision();
    }
}


class Att extends Obj{
    constructor(scene, filename, x, y, type){
        super(filename, x, y);
        this.scene = scene;
        this.speed = 7;
        this.power = 51;
        this.type = type;
    }
    
    init(){

    }

    draw(){
        context.drawImage(this.sprite, this.x, this.y, this.sprite.width / this.ratio, this.sprite.height / this.ratio);
    }

    Delelte(){
        let pos = 0;
        let index = 0;
        this.scene.objList.forEach(i=>{
            if(i === this){
                pos = index;
            }
            index++;
        });
        this.scene.objList.splice(pos, 1);
        this.isDestroy = true;
        delete this;
    }

    move(){
        if(this.type === 1){
            this.y -= this.speed * deltatime;
            this.x -= this.speed * deltatime * 0.2;
        }
        else if(this.type === 2){
            this.y -= this.speed * deltatime;
        }
        else if(this.type === 3){
            this.y -= this.speed * deltatime;
            this.x += this.speed * deltatime * 0.2;
        }
        

        if(this.isDestroy === false && this.y < 10){
            this.Delelte();
        }
    }

    Collision(){
        this.scene.enemyList.forEach(i=>{

            if(i.type === 100){
                const length = Math.sqrt(Math.pow(this.x - i.x - 150, 2) +  Math.pow(this.y - i.y - 100, 2));

                if(i.isDestroy === false && length <= 100){
                    i.heath -=  1;
                    this.scene.uiList.push(new Effect(this.scene, this.getRandomInt(this.x - 150, this.x + 50),this.getRandomInt(this.y - 150, this.y), 4));
                    this.Delelte();
                }
            }
            else if(i.type === 101){
                const length = Math.sqrt(Math.pow(this.x - i.x - 150, 2) +  Math.pow(this.y - i.y - 100, 2));

                if(i.isDestroy === false && length <= 100){
                    i.heath -=  1;
                    this.scene.uiList.push(new Effect(this.scene, this.getRandomInt(this.x - 150, this.x + 50),this.getRandomInt(this.y - 150, this.y), 5));
                    this.Delelte();
                }
            }
            else{
                const length = Math.sqrt(Math.pow(this.x - i.x - 70, 2) +  Math.pow(this.y - i.y, 2));

                if(i.isDestroy === false && length <= 70){
                    console.log('att: Collision');
                    this.scene.player1.score += i.attPow;
                    if(this.type === 3 || this.type === 4) {
                        i.heath -= this.power / 2;
                    } else{   
                        i.heath -= this.power;
                    }
                    this.scene.uiList.push(new Effect(this.scene, this.x - 100, this.y - 100, 1));
                    this.Delelte();
                }
            }
        });
       
    }

    update(event){
        this.move();
        this.Collision();
    }
}

class Item extends Obj{
    constructor(scene, x, y, type){
        super(`resource/item/item (${type}).png`, x, y);
        this.scene = scene;
        this.speed = 7;
        this.type = type;
    }

    
    setPosistion(x, y){
        this.x = x;
        this.y = y;
    }

    init(){

    }

    draw(){
        context.drawImage(this.sprite, this.x, this.y, this.sprite.width / this.ratio, this.sprite.height / this.ratio);
    }

    move(){
        this.y += this.speed * deltatime;

        if(this.isDestroy === false && this.y + 20 > WindowSizeY){
            console.log('item: die');
            this.Delelte();
        }
    }

    Delelte(){
        let pos = 0;
        let index = 0;
        this.scene.objList.forEach(i=>{
            if(i === this){
                pos = index;
            }
            index++;
        });
        this.scene.objList.splice(pos, 1);
        this.isDestroy = true;
        delete this;
    }

    Collision(){
        const length = Math.sqrt(Math.pow(this.x - this.scene.player1.x + 30, 2) +  Math.pow(this.y - this.scene.player1.y, 2));

        if(this.isDestroy === false && length <= 70){
            console.log('item: Collision');
            this.scene.uiList.push(new Effect(this.scene, this.x - 80, this.y - 100, 3));
            if(this.type === 1){
                this.scene.player1.heath += 10;
            }
            else if(this.type === 2){
                if(this.scene.player1.speed < 15){
                    this.scene.player1.speed += 3;
                }
            }
            else{
                this.scene.player1.attType += 1;

                if(this.scene.player1.attType === 4){
                    this.scene.player1.attType = 1;
                }
            }
            
            this.Delelte();
        }
        else if(this.isDestroy === false && this.heath < 0){
            this.Delelte();
        }
    }

    update(event){
        // console.log(event, event.key, event.type);
        this.move();
        this.Collision();
    }
}


class HealthBar extends Obj{
    constructor(player, filename, x, y, ratio){
        super(filename, x, y);
        this.player = player;
        this.ratio = ratio;
    }
    
    init(){
    }

    draw(){
        context.drawImage(this.sprite, this.x, this.y, (this.sprite.width / this.ratio) * (this.player.heath / 100), this.sprite.height / this.ratio);
    }
    update(event){
    }

    Delelte(){
        let pos = 0;
        let index = 0;
        this.player.scene.uiList.forEach(i=>{
            if(i === this){
                pos = index;
            }
            index++;
        });
        this.player.scene.uiList.splice(pos, 1);
        this.isDestroy = true;
        delete this;
    }
}

class Number extends Obj{
    constructor(scene, x, y){
        super('resource/number/0.png', x, y);
        this.scene = scene;
        this.now = 0;
        this.next = -1;
    }

    
    setPosistion(x, y){
        this.x = x;
        this.y = y;
    }

    init(){

    }

    draw(){
        context.drawImage(this.sprite, this.x, this.y, this.sprite.width / this.ratio, this.sprite.height / this.ratio);
    }

    changeNumber(num){
        this.next = num;
    }

    update(event){
        if(this.next !== -1){
            this.sprite.src = `resource/number/${this.next}.png`;
            this.now = this.next;
            this.next = -1;
        }
    }
} 

class Score{
    constructor(scene, player, x, y){
        this.scene = scene;
        this.player = player;
        this.sprites = [];
        this.x = x;
        this.y = y;

        for(let i = 0; i < 10; i++){
            this.sprites.push(new Number(this.scene, this.x + i * 20, this.y));
        }
    }

    draw(){
        this.sprites.forEach(i=>{
            i.draw();
        });
    }

    update(event){
        let curNum = this.player.score;
        let number = [];

        if(curNum !== 0){

            while(curNum !== 0){
                number.push(curNum % 10);
                curNum = Math.floor(curNum / 10);
            }
            
            
            for(let i = number.length; i < 10; i++){
                number.push(0);
            }
     
            number = number.reverse();
    
            for(let i = 0; i < 10; i++){
                this.sprites[i].changeNumber(number[i]);
            }
    
            this.sprites.forEach(i=>{
                i.update(event);
            });
        }
    }
}


class Player extends Obj{
    constructor(scene,filename, x, y){
        super(filename, x, y);
        this.scene = scene;
        this.leftBtn = false;
        this.rightBtn = false;
        this.topbtn = false;
        this.bottomBtn = false;
        this.spaceBtn = false;
        this.f2Btn = false;
        this.isAtt = true;
        this.currentTime = 0;
        this.attTime = 7;
        this.speed = 7;
        this.score = 0;
        this.heath = 100;
        this.attType = 1;
        this.healthBar = new HealthBar(this, 'resource/healthbar.png', 0, 600, 1.5);
        this.scene.uiList.push(this.healthBar);
    }

    
    setPosistion(x, y){
        this.x = x;
        this.y = y;
    }

    init(){

    }

    draw(){
        context.drawImage(this.sprite, this.x, this.y, this.sprite.width / this.ratio, this.sprite.height / this.ratio);
    }

    keyState(event){
        if(event.key === 'ArrowLeft' && event.type === 'keydown'){
            this.leftBtn = true;
        }

        if(event.key === 'ArrowRight' && event.type === 'keydown'){
            this.rightBtn = true;
        }

        if(event.key === 'ArrowUp' && event.type === 'keydown'){
            this.topbtn = true;
        }

        if(event.key === 'ArrowDown' && event.type === 'keydown'){
            this.bottomBtn = true;
        }

        if(event.code === 'Space' && event.type === 'keypress'){
            this.spaceBtn = true;
        }

        if(event.type === 'keyup'){
            this.leftBtn = false;
            this.rightBtn = false;
            this.topbtn = false;
            this.bottomBtn = false;
        }

        if(event.code === 'F2' && event.type === 'keydown'){
            this.f2Btn = true;
        }
    }

    move(){
        if(this.leftBtn === true){
            if(this.x > 0){
                this.x -= this.speed * deltatime;
            }
        }

        if(this.rightBtn === true){
            if(this.x < WindowSizeX - 50){
                this.x += this.speed * deltatime;
            }
        }

        if(this.topbtn === true){
            if(this.y > 0){
                this.y -= this.speed * deltatime;
            }
        }

        if(this.bottomBtn === true){
            if(this.y < WindowSizeY - 50){
                this.y += this.speed * deltatime;
            }
        }

    }
    Animation(){
        if(this.leftBtn === true){
            this.sprite.src = "resource/player/_player (1).png";
        }

        else if(this.rightBtn === true){
            this.sprite.src = "resource/player/_player (5).png";
        }

        else{
            this.sprite.src = "resource/player/_player (3).png";
        }

    }

    Att(){
        if(this.isAtt === false){
            this.currentTime += deltatime;
            if( this.attTime < this.currentTime){
                this.currentTime = 0;
                this.isAtt = true;
            }
        }


        if(this.isAtt === true && this.spaceBtn === true){
            const audio = new Audio(); // Aduio 객체 생성 
            audio.src = "resource/laser.wav"; // 음원 파일 설정 
            audio.play(); // 음원 재생 

            if(this.attType === 1){
                const att = new Att(this.scene, 'resource/bullet/player_bullet_2.png', this.x + 20, this.y - 25, 2);
                this.scene.objList.push(att);
                this.attTime = 7;
            }
            else if(this.attType === 2){
                for(let i = 1; i < 4; i ++){
                    const att = new Att(this.scene, 'resource/bullet/player_bullet_2.png', this.x + 20, this.y - 25, i);
                    this.scene.objList.push(att);
                }
                this.attTime = 7;
            }
            else if(this.attType === 3){
                this.attTime = 3;
                const att = new Att(this.scene, 'resource/bullet/player_bullet_2.png', this.x + 20, this.y - 25, 2);
                this.scene.objList.push(att);
            }

            this.spaceBtn = false; 
            this.isAtt = false;
        }
    }

    update(event){
        // console.log(event, event.key, event.type);
        this.keyState(event);
        this.move();
        this.Animation();
        this.Att();

        if(this.f2Btn === true){
            this.score += 500;
            this.attType = 3;
            this.heath = 1000;
            this.f2Btn = false;
        }
    }
}

class Scene{
    constructor(){}

    init(){}

    draw(){}

    update(event){}
}

class Stage1Scene extends Scene{
    constructor(){
        super();
         //const myAudio = new Audio(); // Aduio 객체 생성 
         //myAudio.src = "resource/BGM.wav"; // 음원 파일 설정 
         //myAudio.play(); // 음원 재생 

        this.middleBoss = false;
        this.lastBoss = false;
        this.isCreateMonster = true;
        this.objList = [];
        this.uiList = [];
        this.enemyList = [];
        this.enemyAttList = [];
        this.createEnemyTime = 20;
        this.curEnemyTime = 0;
        this.isOver = false;
        this.isWin = false;

        this.Background1 = new Background(this, 0, -1080, 1);
        this.Background2 = new Background(this, 0, -2880, 1);
        this.player1 = new Player(this, "resource/player/_player (3).png", WindowSizeX / 2, WindowSizeY - 100);
        this.score = new Score(this, this.player1, 800, 50);

        this.enemyList.push(new Enemy(this, this.getRandomInt(100, WindowSizeX - 100), 100, this.getRandomInt(1, 4 + 1 )));
        //this.enemyList.push(new MidBoss(this, 400, -100));

        this.player1.bottomBtn = true;
    }

    getRandomInt(min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min)) + min; //최댓값은 제외, 최솟값은 포함
    }

    init(){
        this.Background1.init();
        this.Background2.init();
        this.player1.init();
        this.objList.forEach(i=>{
            i.init();
        });
        this.enemyList.forEach(i=>{
            i.init();
        });
        this.enemyAttList.forEach(i=>{
            i.init();
        });
        this.uiList.forEach(i=>{
            i.init();
        });
    }

    draw(){
        this.Background1.draw();
        this.Background2.draw();
        this.player1.draw();

        this.objList.forEach(i=>{
            i.draw();
        });
        this.enemyList.forEach(i=>{
            i.draw();
        });
        this.enemyAttList.forEach(i=>{
            i.draw();
        });
        this.uiList.forEach(i=>{
            i.draw();
        });
        this.score.draw();
    }

    update(event){
        this.Background1.update(event);
        this.Background2.update(event);
        this.player1.update(event);

        this.objList.forEach(i=>{
            i.update(event);
        });
        this.enemyList.forEach(i=>{
            i.update(event);
        });
        this.enemyAttList.forEach(i=>{
            i.update(event);
        });
        this.uiList.forEach(i=>{
            i.update(event);
        });
        this.score.update(event);

        this.curEnemyTime += deltatime;

        if(this.middleBoss === false && this.player1.score >= 500){
            this.middleBoss = true;
            this.isCreateMonster = false;
            this.enemyList.push(new MidBoss(this, 400, -100));
        }
        if(this.middleBoss === true && this.lastBoss === false && this.player1.score >= 3000){
            this.lastBoss = true;
            this.isCreateMonster = false;
            this.enemyList.push(new LastBoss(this, 400, -100));
        }
        if(this.isCreateMonster === true){
            if(this.curEnemyTime > this.createEnemyTime){
                if(this.middleBoss === true){
                    this.enemyList.push(new Enemy(this, this.getRandomInt(100, WindowSizeX - 100), -100, this.getRandomInt(3, 4 + 1 )));
                } else{
                    this.enemyList.push(new Enemy(this, this.getRandomInt(100, WindowSizeX - 100), -100, this.getRandomInt(1, 2 + 1 )));
                }
                this.curEnemyTime = 0; 
            }
        }
        if(this.isOver === false && this.player1.heath <= 0){
            this.isOver = true;
            deltatime = 0;
            const endui = new EndUI(this.scene, 'over');
            this.uiList.push(endui);
            //this.uiList.push(new button(this, 'replay', endui.x + 300, endui.y + 230));
            this.uiList.push(new button(this, 'exit', WindowSizeX / 1.6,  WindowSizeY / 8));
        }
        else if(this.isWin === true){
            this.isWin = false;
            deltatime = 0;
            const endui = new EndUI(this.scene, 'win');
            this.uiList.push(endui);
            //this.uiList.push(new button(this, 'replay', endui.x + 300, endui.y + 230));
            this.uiList.push(new button(this, 'exit', WindowSizeX / 1.6,  WindowSizeY / 8));
        }
    }
}

class SceneManager{
    constructor(main){
        this.main = main;
        this.next = null;
    }

    init(){
        this.main.init();
    }

    draw(){
        if(this.next !== null){
            delete this.main;
            this.main = null;
            this.main = this.next;
            this.next = null;
            this.init();
        }
        this.main.draw();
    }

    update(event){
        if(this.next !== null){
            this.main = null;
            this.main = this.next;
            this.next = null;
            this.init();
        }
        this.main.update(event);
    }
}

class Game{
    constructor(){
        this.sceneManager = new SceneManager(new Stage1Scene());
    }

    init(){
        this.sceneManager.init();
    }

    draw(){
        context.clearRect(0, 0, WindowSizeX, WindowSizeY);
        this.sceneManager.draw();
    }

    update(event){
        this.sceneManager.update(event);
    }
}

function main(){
   console.log('newnew');
    const game = new Game();
    let getEvent;
    game.init();

    document.addEventListener('click', function(event){
        getEvent = event;
    });
    
    document.addEventListener('mousemove', function(event){
        getEvent = event;
    });
    
    document.addEventListener('keydown', function(event){
        console.dir(event);
        getEvent = event;
    });

    document.addEventListener('keyup', function(event){
        getEvent = event;
    });

    document.addEventListener('keypress', function(event){
        getEvent = event;
    });


    //update
    setInterval(()=>{
        game.update(getEvent);
        game.draw();
    }, 10);
}

main();



// imageElem.addEventListener("load", () => {
//     context.clearRect(0, 0, canvas.offsetWidth, canvas.offsetHeight);

//     context.drawImage(imageElem, 1, 1);//이미지1
// });

