const API_URL = 'http://localhost:3000';

refreshList();

document.getElementById('filter-button').addEventListener('click', async () => { refreshList(); });

document.getElementById('sort-button').addEventListener('click', async () => { sortList(); });

document.getElementById('entry-form').addEventListener('reset', async () => {
    document.getElementById('entry-form').reset();
});

document.getElementById('entry-form').addEventListener('submit', async (e) => {
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

async function sortList() {
    const list = document.getElementById('entry-list');
    const entries = Array.from(list.children);
    const sortButton = document.getElementById('sort-button');

    if (sortButton.textContent === 'Sort ↑') {
        entries.sort((a, b) => {
            const value1 = a.dataset.a;
            const value2 = b.dataset.a;
            return value2.localeCompare(value1);
        });
        sortButton.textContent = 'Sort ↓';
    }
    else {
        entries.sort((a, b) => {
            const value1 = a.dataset.a;
            const value2 = b.dataset.a;
            return value1.localeCompare(value2);
        });
        sortButton.textContent = 'Sort ↑';
    }

    while (list.firstChild) {
        list.removeChild(list.firstChild);
    }

    entries.forEach(e => list.appendChild(e));
}

async function refreshList() {
    const filter = document.getElementById('filter');
    const json = filter ? await (await fetch(`${API_URL}/entries/${filter.value}`)).json() : await (await fetch(`${API_URL}/entries`)).json();

    const list = document.getElementById('entry-list');


    while (list.firstChild) {
        list.removeChild(list.firstChild);
    }

    json.forEach(e => {
        const listItem = document.createElement('div');
        listItem.style['background-color'] = e.color;

        const negativeColor = invertColor(e.color);

        const p1 = document.createElement('input');
        p1.id = 'inputA' + e.id;
        p1.type = 'text'
        p1.disabled = true;
        p1.value = e.a;
        p1.style['color'] = negativeColor;
        p1.style['background-color'] = e.color;
        listItem.appendChild(p1);

        const p2 = document.createElement('input');
        p2.id = 'inputB' + e.id;
        p2.type = 'text'
        p2.disabled = true;
        p2.value = e.b;
        p2.style['color'] = negativeColor;
        p2.style['background-color'] = e.color;
        listItem.appendChild(p2);

        const colorPicker = document.createElement('input');
        colorPicker.id = 'colorpicker' + e.id;
        colorPicker.disabled = true;
        colorPicker.type = 'color';
        colorPicker.value = e.color;
        listItem.appendChild(colorPicker);

        const deleteButton = document.createElement('button');
        deleteButton.textContent = 'Delete';
        deleteButton.addEventListener('click', () => askForDeleteConfirmation(e.id));
        listItem.appendChild(deleteButton);

        const editButton = document.createElement('button');
        editButton.id = 'editButton' + e.id;
        editButton.textContent = 'Edit';
        editButton.addEventListener('click', () => editEntry(e.id));
        listItem.appendChild(editButton);

        listItem.dataset.a = e.a;

        list.appendChild(listItem);
    });
}

async function askForDeleteConfirmation(id) {
    const popupScreen = document.getElementById('popup-screen');
    const popupYes = document.getElementById('popup-yes');
    const popupNo = document.getElementById('popup-no');

    popupScreen.style.display = 'flex';

    popupYes.addEventListener('click', async () => {
        await deleteEntry(id);
        popupScreen.style.display = 'none';
    });

    popupNo.addEventListener('click', () => {
        popupScreen.style.display = 'none';
    });
}

async function editEntry(id) {
    const editButton = document.getElementById('editButton' + id);
    const aValue = document.getElementById('inputA' + id);
    const bValue = document.getElementById('inputB' + id);
    const colorPicker = document.getElementById('colorpicker' + id);

    if (editButton.textContent === 'Edit') {
        aValue.disabled = false;
        bValue.disabled = false;
        colorPicker.disabled = false;
        editButton.textContent = 'Save';
    } else {
        aValue.disabled = true;
        bValue.disabled = true;
        colorPicker.disabled = true
        editButton.textContent = 'Edit';
        await saveEntry(id);
    }
}

async function saveEntry(id) {
    const aValue = document.getElementById('inputA' + id).value;
    const bValue = document.getElementById('inputB' + id).value;
    const colorValue = document.getElementById('colorpicker' + id).value;

    await fetch(`${API_URL}/entries/${id}`, {
        method: 'PUT',
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
