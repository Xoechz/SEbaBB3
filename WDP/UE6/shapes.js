class Shape {
    constructor(shapeType, posX, posY, color, lineWidth = 1) {
        this.__shapeType = shapeType;
        this.posX = posX;
        this.posY = posY;
        this.color = color;
        this.lineWidth = lineWidth;
    }

    draw(ctx) {
        throw new Error('Method draw() must be implemented');
    }
}

class Circle extends Shape {
    constructor(posX, posY, radius, color, lineWidth = 1) {
        super('circle', posX, posY, color, lineWidth);
        this.radius = radius;
    }

    draw(ctx) {
        ctx.beginPath();
        ctx.arc(this.posX, this.posY, this.radius, 0, 2 * Math.PI);
        ctx.lineWidth = this.lineWidth;
        ctx.strokeStyle = this.color;
        ctx.stroke();
    }
}

class Rectangle extends Shape {
    constructor(posX, posY, width, height, color, lineWidth = 1) {
        super('rectangle', posX, posY, color, lineWidth);
        this.width = width;
        this.height = height;
    }

    draw(ctx) {
        ctx.beginPath();
        ctx.rect(this.posX, this.posY, this.width, this.height);
        ctx.lineWidth = this.lineWidth;
        ctx.strokeStyle = this.color;
        ctx.stroke();
    }
}

class Line extends Shape {
    constructor(posX, posY, color, lineWidth = 1) {
        super('line', posX, posY, color, lineWidth);
        this.points = [];
    }

    draw(ctx, cx, cy) {
        if (cx === undefined || cy === undefined) {
            ctx.beginPath();
            ctx.moveTo(this.posX, this.posY);
            this.points.forEach(point => ctx.lineTo(point.x, point.y));
        }
        else {
            if (this.points.length === 0) {
                ctx.beginPath();
                ctx.moveTo(cx, cy);
            }
            else {
                ctx.lineTo(cx, cy);
            }
            this.points.push({ x: cx, y: cy });
            ctx.lineWidth = this.lineWidth;
            ctx.strokeStyle = this.color;
            ctx.stroke();
        }
    }
}

class Drawing {
    constructor(canvas) {
        this.canvas = canvas;
        this.ctx = canvas.getContext('2d');
        this.shapeList = [];
    }

    addShape(shape) {
        this.shapeList.push(shape);
        if (shape.__shapeType != 'line') {
            shape.draw(this.ctx);
        }
    }

    draw() {
        this.shapeList.forEach(shape => shape.draw(this.ctx));
    }

    getLastShape() {
        return this.shapeList[this.shapeList.length - 1];
    }

    clear() {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        this.shapeList = [];
    }
}