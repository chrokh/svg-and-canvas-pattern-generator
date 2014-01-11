var svgen = window.svgen = {};

svgen.Boundries = {};
svgen.Boundries.width  = 500;
svgen.Boundries.height = 500;
svgen.Boundries.steps  = 4;
svgen.Boundries.stepSize = svgen.Boundries.width / svgen.Boundries.steps;

svgen.Circle = function(){
    this.x = svgen.Rand.next();
    this.y = svgen.Rand.next();
    this.radius = svgen.Rand.next();
    this.color = svgen.Rand.next();
}
svgen.Rect = function(){
  this.x = svgen.Rand.next();
  this.y = svgen.Rand.next();
  this.width = svgen.Rand.next(1);
  this.height = svgen.Rand.next(1);
  this.color = svgen.Rand.next(1);
}
svgen.Pattern = function(){
  this._shapes = [];
  for(var i=0; i<10; i++){
    this._shapes.push(new svgen.Rect());
  }
}

svgen.Rand = {};
svgen.Rand.next = function(min){
  min = min || 0;
  var max  = svgen.Boundries.steps,
      rand = svgen.Rand.next_between(min, max);
  return svgen.Boundries.stepSize * rand;
}
svgen.Rand.next_between = function(min, max){
  return Math.floor((Math.random()*max)+min);
}

for(var n = 0; n<10; n++){
  f = new svgen.Pattern();
  console.log(f)
}
