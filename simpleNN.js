

class neuralNetwork {

  constructor(inputNodes, hiddenNodes, outputNodes, parent1, parent2){
    this.inputNodes = inputNodes;
    this.hiddenNodes = hiddenNodes;
    this.outputNodes = outputNodes;
    if (parent1 && parent2){
      this.inputWeights = breed(parent1.inputWeights, parent2.inputWeights);
      this.outputWeights = breed(parent1.outputWeights, parent2.outputWeights);
    }
    else{
      this.inputWeights = tf.randomNormal([this.inputNodes, this.hiddenNodes]);
      this.outputWeights = tf.randomNormal([this.hiddenNodes, this.outputNodes]);
    }
  }

  predict(input){
    let output;

    tf.tidy(() => {
      let inputLayer = tf.tensor(input, [1, this.inputNodes]);
      let hiddenLayer = inputLayer.matMul(this.inputWeights).sigmoid();
      let outputLayer = hiddenLayer.matMul(this.outputWeights).sigmoid();
      output = outputLayer.dataSync();
    });
    return output;
  }

  // clone(){
  //   let newClone = new neuralNetwork(  this.inputNodes, this.hiddenNodes, this.outputNodes);
  //   newClone.dispose();
  //   newClone.inputWeights = tf.clone(this.inputWeights);
  //   newClone.outputWeights = tf.clone(this.outputWeights);
  //   return newClone;
  // }

  dispose(){
    this.inputWeights.dispose();
    this.outputWeights.dispose();
  }
}


function breed(tensor1, tensor2){
  let newTensorArr = [];
  // console.log(tensor1.shape);
  // console.log(tensor2.shape);
    for (let i = 0; i < tensor1.shape[0]; i++){
      let weightArr = [];
      for (let j = 0; j < tensor1.shape[1]; j++){
        if (random() > 0.01){
          if (random() > 0.5){
            weightArr.push(tensor1.get(i, j));
          }
          else{
            weightArr.push(tensor2.get(i, j));
          }
        }
        else{
          weightArr.push(random(-1, 1));
        }
      }
      newTensorArr.push(weightArr);
    }
  return tf.tensor(newTensorArr);

}

class cell{
  constructor(parent1, parent2){
    this.xpos = round(random(canvasWidth));
    this.ypos = round(random(canvasHeight));
    // this.xpos = canvasWidth/2;
    // this.ypos = canvasHeight-10;
    // this.goalx = round(random(canvasWidth-50));
    // this.goaly = round(random(canvasHeight-50));
    this.goalx = canvasWidth/2;
    this.goaly = canvasHeight/2;
    this.fitness = 0;

    if (parent1 && parent2){  line(canvasWidth/2-5, canvasHeight/2+5, canvasWidth/2-5, canvasHeight/2+5)

      this.mind = new neuralNetwork(4, 16, 4, parent1, parent2);
    }
    else{
      this.mind = new neuralNetwork(4, 16, 4);
    }
    this.radius = 10;
    this.color = {
      r: random(255),
      g:  random(255),
      b: random(255)
    }
  }

    update() {
      // console.log("update");

      let previousDist = dist(this.xpos, this.ypos, this.goalx, this.goaly);

      let outputs = this.mind.predict([this.xpos, this.ypos, this.goalx, this.goaly]);
      // console.log(outputs);
      if (round(outputs[0])){ this.xpos += speed; }
      if (round(outputs[1])){ this.ypos += speed; }
      if (round(outputs[2])){ this.xpos -= speed; }
      if (round(outputs[3])){ this.ypos -= speed; }

      //TODO TOO MANY RULES:

      if (dist(this.xpos, this.ypos, this.goalx, this.goaly) < 10){
        this.fitness += 100;
      }
      if (dist(this.xpos, this.ypos, this.goalx, this.goaly) < previousDist){
        this.fitness += 5;
      }
      if (this.xpos > canvasWidth || this.xpos < 0 || this.ypos > canvasHeight || this.xpos < 0){
        this.fitness -= 5;
      }
      if (dist(this.xpos, this.ypos, this.goalx, this.goaly) > previousDist) {
        this.fitness -= 1;
      }
      stroke(this.color.r, this.color.g, this.color.b);
      noFill();
      // line(this.xpos, this.ypos, this.goalx, this.goaly);
      ellipse(this.xpos, this.ypos, this.radius);

    }


}
