const canvas = document.getElementById('paintArea');
const fileInput = document.getElementById('file');
const colorInput = document.getElementById('colorpicker');
const lineWidthInput = document.getElementById('linewidth');
const lineButton = document.getElementById('line');
const rectButton = document.getElementById('rectangle');
const circleButton = document.getElementById('circle');
const clearButton = document.getElementById('clear');
const saveButton = document.getElementById('save');

let color = 'black';
let lineWidth = 1;
let drawingActive = false;

const currentShape = {
    rectangle: false,
    circle: false,
    line: false
}

const drawing = new Drawing(canvas);

rectButton.addEventListener('click', () => {
    currentShape.rectangle = true;
    currentShape.circle = false;
    currentShape.line = false;

    rectButton.className = 'selected';
    circleButton.className = '';
    lineButton.className = '';
});

circleButton.addEventListener('click', () => {
    currentShape.rectangle = false;
    currentShape.circle = true;
    currentShape.line = false;

    rectButton.className = '';
    circleButton.className = 'selected';
    lineButton.className = '';
});

lineButton.addEventListener('click', () => {
    currentShape.rectangle = false;
    currentShape.circle = false;
    currentShape.line = true;

    rectButton.className = '';
    circleButton.className = '';
    lineButton.className = 'selected';
});

canvas.addEventListener('mousedown', (e) => startDrawing(e));

function getMousePos(e) {
    const rect = canvas.getBoundingClientRect();
    return {
        x: e.clientX - rect.left,
        y: e.clientY - rect.top
    };
}

function startDrawing(e) {
    let { x, y } = getMousePos(e);

    let shape;

    color = colorInput.value;
    lineWidth = lineWidthInput.value;

    if (currentShape.rectangle) {
        shape = new Rectangle(x, y, 100, 100, color, lineWidth);
    }
    else if (currentShape.circle) {
        shape = new Circle(x, y, 0, color, lineWidth);
    }
    else if (currentShape.line) {
        shape = new Line(x, y, color, lineWidth);
    }

    if (shape) {
        drawing.addShape(shape);
    }
}