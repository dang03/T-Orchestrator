function IsJsonString(str) {
    try {
        JSON.parse(str);
    } catch (e) {
        return false;
    }
    return true;
}

/*
 * Check if is array. If not, convert to array. 
 * Only used when is required an array and with one element is not recognized as an arrray.
 * @param {type} possibleArray
 * @returns {Array}
 */
function checkIfIsArray(possibleArray) {
    if (possibleArray instanceof Array) {
        return possibleArray;
    } else {
        return [possibleArray];
    }
}

function removeItem(obj, prop, val) {
    var c, found=false;
    for(c in obj) {
        if(obj[c][prop] == val) {
        	delete obj[c];
        }
    }
}