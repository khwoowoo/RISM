class Slider{
    constructor(){
        const list = document.querySelectorAll("#jsSlider");
        const box = document.querySelector(".Slider_State");

        for(let i = 0; i < list.length; i++){
            const newDiv = document.createElement("div");
            newDiv.style.backgroundColor = (i == 0) ? 'rgb(44, 44, 44)' : 'rgb(100, 100, 100)';
            newDiv.classList.add("Slider_State_circle");
            box.appendChild(newDiv);
        }

        setInterval(()=>{
           this.sliderHaddle(list, box)
        }, 2000);
    }

    sliderHaddle(list, box){
        const stateList = box.querySelectorAll(".Slider_State_circle");
        let start = 0;
        let end = 0;
        let index = 0;

        for(let i = 0; i < list.length; i++){
            let string = list[i].src;
            for(let j = list[i].src.length; j > -1; j--){
                if(list[i].src[j] === '('){
                    start = j;
                } else if(list[i].src[j] === ')'){
                    end = j;
                }
            }

            string = string.slice(start + 1, end);
            index = parseInt(string);
            index++;

            if(index > list.length){
                index = 1;
            }

            list[i].src = `images/slider (${index}).jpg`;
        }

        for(let i = 0; i < stateList.length; i++){
            if(stateList[i].style.backgroundColor === "rgb(44, 44, 44)"){
                index = i;
                index++;
                
                if(index == stateList.length){
                    index = 0;
                }
            }
        }

        for(let i = 0; i < stateList.length; i++){
            if(index === i){
                stateList[i].style.backgroundColor = "rgb(44, 44, 44)";
            } else{
                stateList[i].style.backgroundColor = "rgb(100, 100, 100)";
            }
        }
    }
}

function main(){
    const slier = new Slider();
}

main();