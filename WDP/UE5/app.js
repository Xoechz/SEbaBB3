const API_URL = 'http://localhost:3000';

refreshList();

document.getElementById('entry-form') - addEventListener('submit', async (e) => {
    e.preventDefault();

    const aValue = document.getElementById('input1').value;
    const bValue = document.getElementById('input2').value;
    const colorValue = document.getElementById('colorpicker').value;

    await fetch(`${API_URL}/entries`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            a: aValue,
            b: bValue,
            color: colorValue
        })
    });

    await refreshList();
});

async function refreshList() {
    const json = await (await fetch(`${API_URL}/entries`)).json();
    const list = document.getElementById('entry-list');

    while (list.firstChild) {
        list.removeChild(list.firstChild);
    }

    json.forEach(e => {
        const listItem = document.createElement('div');
        listItem.style['background-color'] = e.color;

        const negativeColor = invertColor(e.color);

        const p1 = document.createElement('p');
        p1.textContent = `a: ${e.a}`;
        p1.style['color'] = negativeColor;
        listItem.appendChild(p1);

        const p2 = document.createElement('p');
        p2.textContent = `b: ${e.b}`;
        p2.style['color'] = negativeColor;
        listItem.appendChild(p2);

        const deleteButton = document.createElement('button');
        deleteButton.textContent = 'Delete';
        deleteButton.addEventListener('click', () => deleteEntry(e.id));
        listItem.appendChild(deleteButton);

        list.appendChild(listItem);
    });
}

async function deleteEntry(id) {
    await fetch(`${API_URL}/entries/${id}`, {
        method: 'DELETE'
    });

    await refreshList();
}

function invertColor(hex) {
    if (hex.indexOf('#') === 0) {
        hex = hex.slice(1);
    }
    // convert 3-digit hex to 6-digits.
    if (hex.length === 3) {
        hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2];
    }
    if (hex.length !== 6) {
        throw new Error('Invalid HEX color.');
    }
    // invert color components
    var r = (255 - parseInt(hex.slice(0, 2), 16)).toString(16),
        g = (255 - parseInt(hex.slice(2, 4), 16)).toString(16),
        b = (255 - parseInt(hex.slice(4, 6), 16)).toString(16);
    // pad each with zeros and return
    return '#' + padZero(r) + padZero(g) + padZero(b);
}

function padZero(str, len) {
    len = len || 2;
    var zeros = new Array(len).join('0');
    return (zeros + str).slice(-len);
}

document.getElementById('entry-form') - addEventListener('click', async () => {
    document.getElementById('entry-form').reset();
});