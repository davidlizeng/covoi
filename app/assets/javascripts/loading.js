newLoadingAnimation = function() {
  var circle = new Sonic({
    width: 50,
    height: 50,
    padding: 0,
    strokeColor: '#000000',
    pointDistance: .01,
    stepsPerFrame: 3,
    trailLength: .7,
    step: 'fader',
    setup: function() {
      this._.lineWidth = 5;
    },
    path: [
        ['arc', 25, 25, 25, 0, 360]
    ]
  }); 
  return circle;
};
