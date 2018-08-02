let trainingFrame = 100;
// let numCells = 100;
let speed = 5;

new p5();
// transform(199);
let canvasWidth = 400;
let canvasHeight = 400;
let cells = new Array(75).fill().map(() => new cell());
let genePool = [];
// let test = new neuralNetwork(8, 32, 18);
// let test2 = new neuralNetwork(8, 32, 18);
// let test3 = new neuralNetwork(8, 32, 18, test, test2);

// let networks = new Array(25).fill().map(() => new neuralNetwork(4, 16, 4));

// console.log(network);

function setup(){
  createCanvas(canvasWidth, canvasHeight);
};


function draw(){
  background(25);
  noStroke();
  fill(127);
  // ellipse(canvasWidth/2, 50, 2);
  ellipse(canvasWidth/2, canvasHeight/2, 5);
  for (c in cells){
    cells[c].update();
  }

  if (frameCount % trainingFrame == 0){
    newMind();
  }
}

function newMind(){
  let newCells = [];
  genePool = [];
  for (c in cells){
    if (cells[c].fitness < 1) {cells[c].fitness = 1}
    for (let i = 0; i < cells[c].fitness; i++){
      genePool.push(int(c));
    }
  }


  if (genePool.length > 0){
    for (c in cells){
      if (random() > 0.1){
        let parent1 = genePool[int(random(genePool.length-1))];
        let parent2 = genePool[int(random(genePool.length-1))];
        newCells.push(new cell(cells[parent1].mind, cells[parent2].mind));
      }
      else{
        newCells.push(new cell());
      }

    }
    for (c in cells){
      cells[c].mind.dispose();
    }
  }
  else{

    for (c in cells){
      newCells.push(new cell());
    }
  }
  cells = newCells;
}





// // BACK PROP TRAINING
// //
// //
// // const config = {
// //   // shuffle: true,
// //   epochs: 10
// // };
//
// // tf.tidy(() => {
// //   train().then(() => {
// //     console.log('training complete');
// //     let outputs = NNmodel.predict(randomTest);
// //     // xs.print();
// //     randomTest.print();
// //     outputs.print();
// //     // console.log(Math.sqrt( Math.pow(x2Pos - x1Pos, 2) + Math.pow(y2Pos - y1Pos, 2)));
// //   })
// // });
// //
//
// // async function train(){
// //   for(let i=0; i<10; i++){
// //     // x1Pos = Math.random();
// //     // y1Pos = Math.random(    // cells[c].fitness = map(cells[c].fitness, 1, 100);
    // if (cells[c].fitness > 1000) {cells[c].fitness = 1000});
// //     // x2Pos = Math.random();
// //     // y2Pos = Math.random();
// //
// //     const response = await NNmodel.fit(xs, xs);
// //     // console.log(Math.sqrt( Math.pow(x2Pos - x1Pos, 2) + Math.pow(y2Pos - y1Pos, 2)));
// //     console.log(response.history.loss[0]);
// //   }
// // };
