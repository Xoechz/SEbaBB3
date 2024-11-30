'use strict';

const instanceButton = document.getElementById("instance");

const resetButton = document.getElementById("reset-button");
const runButton = document.getElementById("run-button");

const bestqual = document.getElementById("bestqual");
const solutionCanvas = document.getElementById("solution");
const qualhistCanvas = document.getElementById("qualhist");

let dists = [];
let running = false;
let population = [];
let coords = [];
let history = [];

instanceButton.addEventListener("change", loadInstance);
runButton.addEventListener("click", runOptimizer);

function loadInstance() {
  let file = this.files[0];
  let fileReader = new FileReader();

  fileReader.onload = function (_) {
    const content = this.result;
    const DIMENSION_SECTION = "DIMENSION";
    const NODE_COORD_SECTION = "NODE_COORD_SECTION";

    let lines = content.split("\n");

    let i = 0;

    // parse dimension
    while (!lines[i].startsWith(DIMENSION_SECTION) && i < lines.length) { i++; }
    if (i >= lines.length) { return; } // invalid format
    coords = new Array(parseInt(lines[i].split(" ")[1]));

    // parse coords
    while (!lines[i].startsWith(NODE_COORD_SECTION) && i < lines.length) { i++; }
    i++; // skip section line
    if (i >= lines.length) { return; } // invalid format
    for (let j = 0; j < coords.length && i + j < lines.length; j++) {
      let parts = lines[i + j].split(" ");
      let idx = parseInt(parts[0]) - 1;
      if (idx != j) { return; } // invalid format
      let x = parseFloat(parts[1]);
      let y = parseFloat(parts[2]);
      coords[j] = [x, y];
    }

    dists = calculateDistanceMatrix(coords);
  };

  fileReader.readAsText(file);
}

function calculateDistanceMatrix(coords) {
  // initialize dimensions
  let dists = new Array(coords.length);
  for (let r = 0; r < coords.length; r++) {
    dists[r] = new Array(coords.length)
  }

  // calc dist.mat. for symmetrical tsp
  for (let r = 0; r < coords.length; r++) {
    let f = coords[r];
    for (let c = 0; c < coords.length; c++) {
      if (c == r) continue;

      let t = coords[c];
      let dx = t[0] - f[0];
      let dy = t[1] - f[1];
      dists[r][c] = dists[c][r] = Math.sqrt(dx * dx + dy * dy);
    }
  }

  return dists;
}

function randomInt(i) { // [0, i)
  return Math.floor(Math.random() * i);
}

// fisher-yates shuffle
function shuffle(arr) {
  for (let i = arr.length - 1; i > 0; i--) {
    let j = randomInt(i + 1);
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
}

async function runOptimizer() {
  try {
    running = true;
    updateEnabled();

    let popsize = document.getElementById("popsize").value;
    let generations = document.getElementById("generations").value;
    let mutprob = document.getElementById("mutprob").value;
    let elitism = document.getElementById("elitism").checked;
    let displayfreq = document.getElementById("displayfreq").value;
    let best = await GA(popsize, generations, mutprob, elitism, displayfreq);
    bestqual.innerText = best.fitness; // to use result of promise
  } catch (err) {
  } finally {
    running = false;
    updateEnabled();
  }
}

async function GA(popsize, generations, mutprob, elitism, displayfreq) {
  initialize(popsize);
  for (let gen = 0; gen < generations; gen++) {
    iterate(popsize, mutprob, elitism);
    if ((gen % displayfreq) == 0 || gen == generations - 1) {
      drawSolution(population[0].individual);
      drawQualityHistory();
      bestqual.innerText = population[0].fitness;
      await new Promise(resolve => setTimeout(resolve, 0));
    }
  }
  return population[0];
}

function initialize(popsize) {
  population = new Array(popsize);
  
  for (let i = 0; i < popsize; i++) {
    let individual = create();
    let fitness = evaluate(individual);

    population[i] = {
      individual: individual,
      fitness: fitness
    };
  }

  population.sort((a, b) => a.fitness - b.fitness);
  
  history = [];
  analyzeQualities();
}

function iterate(popsize, mutprob, elitism) {
  let newPop = new Array(popsize);
  let effort = elitism ? popsize - 1 : popsize;

  for (let i = 0; i < effort; i++) {
    let parents = select(population);
    let child = cross(parents);
    if (Math.random() < mutprob) {
      mutate(child);
    }

    let fitness = evaluate(child);
    newPop[i] = {
      individual: child,
      fitness: fitness
    };
  }

  if (elitism) {
    newPop[effort] = population[0];
  }

  population = newPop.sort((a, b) => a.fitness - b.fitness);
  analyzeQualities();
}

// random creation
function create() {
  let individual = [...new Array(dists.length).keys()];
  shuffle(individual);
  return individual;
}

// tournament selection
function select() {
  let selected = new Array(2);

  let tournamentSize = 2;
  for (let i = 0; i < selected.length; i++) {
    let best = population[randomInt(population.length)];
    for (let j = 1; j < tournamentSize; j++) {
      let candidate = population[randomInt(population.length)];
      if (candidate.fitness < best.fitness) {
        best = candidate;
      }
    }

    selected[i] = best;
  }

  return {
    mother: selected[0].individual,
    father: selected[1].individual
  };
}

// order crossover 2
function cross(parents) {
  let mother = parents.mother;
  let father = parents.father;

  let length = mother.length;
  let child = new Array(length);
  let cityCopied = new Array(length);

  let breakPoint1 = randomInt(length);
  let breakPoint2 = (breakPoint1 + 1 + randomInt(length - 1)) % length;
  if (breakPoint2 < breakPoint1) {
    [breakPoint1, breakPoint2] = [breakPoint2, breakPoint1];
  }

  // copy part of first tour
  for (let i = breakPoint1; i <= breakPoint2; i++) {
    child[i] = mother[i];
    cityCopied[mother[i]] = true;
  }

  // copy remaining part of second tour
  let index = 0;
  for (let i = 0; i < length; i++) {
    if (index == breakPoint1) { // skip already copied part
      index = breakPoint2 + 1;
    }
    if (!cityCopied[father[i]]) {
      child[index] = father[i];
      index++;
    }
  }

  return child;
}

// inversion mutation
function mutate(child) {
  let length = child.length;
  let breakPoint1 = randomInt(length);
  let breakPoint2 = (breakPoint1 + 1 + randomInt(length - 1)) % length;
  if (breakPoint2 < breakPoint1) {
    [breakPoint1, breakPoint2] = [breakPoint2, breakPoint1];
  }

  let copy = child.slice(0);

  // inverse tour between breakpoints
  for (let i = 0; i <= (breakPoint2 - breakPoint1); i++) {
    child[breakPoint1 + i] = copy[breakPoint2 - i];
  }
}

function evaluate(child) {
  let dist = 0.0;
  let i = 0;
  while (i < child.length - 1) {
    dist += dists[child[i]][child[i + 1]];
    i++;
  }
  dist += dists[child[i]][child[0]];
  return dist;
}

function analyzeQualities() {
  let sum = population[0].fitness;
  let best = population[0].fitness;
  let worst = population[0].fitness;

  for (let i = 1; i < population.length; i++) {
    let fitness = population[i].fitness;
    if (fitness < best) best = fitness;
    if (fitness > worst) worst = fitness;
    sum += fitness;
  }

  history.push({ best: best, avg: sum / population.length, worst: worst });
}

function updateEnabled() {
  instanceButton.disabled = running;
  resetButton.disabled = running;
  runButton.disabled = running;
}

function drawSolution(solution) {
  let ctx = solutionCanvas.getContext("2d");
  ctx.clearRect(0, 0, solutionCanvas.width, solutionCanvas.height);

  let minX = coords[0][0];
  let maxX = minX;
  let minY = coords[0][1];
  let maxY = minY;
  for (let i = 1; i < coords.length; i++) {
    let x = coords[i][0];
    let y = coords[i][0];

    if (x < minX) minX = x;
    if (x > maxX) maxX = x;
    if (y < minY) minY = y;
    if (y > maxY) maxY = y;
  }
  let dX = maxX - minX;
  let dY = maxY - minY;

  ctx.beginPath();
  ctx.moveTo((coords[solution[0]][0] - minX) / dX * qualhistCanvas.width, qualhistCanvas.height - (coords[solution[0]][1] - minY) / dY * qualhistCanvas.height);
  for (let i = 1; i < solution.length; i++) {
    ctx.lineTo((coords[solution[i]][0] - minX) / dX * qualhistCanvas.width, qualhistCanvas.height - (coords[solution[i]][1] - minY) / dY * qualhistCanvas.height);
  }
  ctx.lineTo((coords[solution[0]][0] - minX) / dX * qualhistCanvas.width, qualhistCanvas.height - (coords[solution[0]][1] - minY) / dY * qualhistCanvas.height);
  ctx.stroke();

  //also draw red circle
  for (let i = 0; i < solution.length; i++) {
    ctx.beginPath();
    ctx.arc((coords[solution[i]][0] - minX) / dX * qualhistCanvas.width, qualhistCanvas.height - (coords[solution[i]][1] - minY) / dY * qualhistCanvas.height, 3, 0, 3 * Math.PI);
    ctx.fillStyle = "red";
    ctx.fill();
    ctx.stroke();
  }
}

function drawQualityHistory() {
  let ctx = qualhistCanvas.getContext("2d");
  ctx.clearRect(0, 0, qualhistCanvas.width, qualhistCanvas.height);

  let minF = history[0].best;
  let maxF = history[0].worst;
  for (let i = 1; i < history.length; i++) {
    if (history[i].best < minF) minF = history[i].best;
    if (history[i].worst > maxF) maxF = history[i].worst;
  }
  let dX = history.length;
  let dY = maxF - minF;

  ctx.beginPath();
  ctx.strokeStyle = "green";
  ctx.moveTo(0, qualhistCanvas.height - (history[0].best - minF) / dY * qualhistCanvas.height);
  for (let i = 1; i < history.length; i++) {
    ctx.lineTo(i / dX * qualhistCanvas.width, qualhistCanvas.height - (history[i].best - minF) / dY * qualhistCanvas.height);
  }
  ctx.stroke();

  ctx.beginPath();
  ctx.strokeStyle = "blue";
  ctx.moveTo(0, qualhistCanvas.height - (history[0].avg - minF) / dY * qualhistCanvas.height);
  for (let i = 1; i < history.length; i++) {
    ctx.lineTo(i / dX * qualhistCanvas.width, qualhistCanvas.height - (history[i].avg - minF) / dY * qualhistCanvas.height);
  }
  ctx.stroke();

  ctx.beginPath();
  ctx.strokeStyle = "red";
  ctx.moveTo(0, qualhistCanvas.height - (history[0].worst - minF) / dY * qualhistCanvas.height);
  for (let i = 1; i < history.length; i++) {
    ctx.lineTo(i / dX * qualhistCanvas.width, qualhistCanvas.height - (history[i].worst - minF) / dY * qualhistCanvas.height);
  }
  ctx.stroke();
}