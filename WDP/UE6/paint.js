const canvas = document.getElementById('paintArea');
const fileInput = document.getElementById('file');
const colorInput = document.getElementById('colorpicker');
const lineWidthInput = document.getElementById('linewidth');
const lineButton = document.getElementById('line');
const rectButton = document.getElementById('rectangle');
const circleButton = document.getElementById('circle');
const clearButton = document.getElementById('clear');
const saveButton = document.getElementById('save');

let drawingActive = false;

const ShapeType = {
    RECTANGLE: 'rectangle',
    CIRCLE: 'circle',
    LINE: 'line'
}

let currentShape = ShapeType.RECTANGLE;

const drawing = new Drawing(canvas);

rectButton.addEventListener('click', () => {
    currentShape = ShapeType.RECTANGLE;

    rectButton.className = 'selected';
    circleButton.className = '';
    lineButton.className = '';

    doneDrawing();
});

circleButton.addEventListener('click', () => {
    currentShape = ShapeType.CIRCLE;

    rectButton.className = '';
    circleButton.className = 'selected';
    lineButton.className = '';

    doneDrawing();
});

lineButton.addEventListener('click', () => {
    currentShape = ShapeType.LINE;

    rectButton.className = '';
    circleButton.className = '';
    lineButton.className = 'selected';

    doneDrawing();
});

canvas.addEventListener('mousedown', (e) => {
    if (drawingActive) {
        draw(e);
    }
    else {
        startDrawing(e);
    }
});

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

    let color = colorInput.value;
    let lineWidth = lineWidthInput.value;

    if (currentShape === ShapeType.RECTANGLE) {
        shape = new Rectangle(x, y, 100, 100, color, lineWidth);
    }
    else if (currentShape === ShapeType.CIRCLE) {
        shape = new Circle(x, y, 100, color, lineWidth);
    }
    else if (currentShape === ShapeType.LINE) {
        shape = new Line(x, y, color, lineWidth);
        drawingActive = true;
    }

    if (shape) {
        drawing.addShape(shape);
    }
}

function doneDrawing() {
    drawingActive = false;
}

function draw(e) {
    if (!drawingActive) {
        return;
    }

    let { x, y } = getMousePos(e);

    let shape = drawing.getLastShape();

    shape.draw(drawing.ctx, x, y);
}