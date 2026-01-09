# Refs

- [about: Operators/Destructuring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring)

# Examples to clean up


```js
const user = {
  id: 42,
  displayName: "jdoe",
  fullName: {
    firstName: "Jane",
    lastName: "Doe",
  },
}
```

## Function Parameters

### Unpack Property

> quote: You could have also written the function without that default. However, if you leave out that default value, the function will look for at least one argument to be supplied when invoked, whereas in its current form, you can call drawChart() without supplying any parameters. Otherwise, you need to at least supply an empty object literal.
> 
```js
function userId( { id } ) {
  return id;
}

console.log(userId(user)); // 42
```

### Unpack and Rename Property
```js
function userDisplayName( { displayName: dname } ) {
  return dname;
}

console.log(userDisplayName(user)); // "jdoe"

// nested unpacking
function whois( { displayName, fullName: { firstName: name } } ) {
  return `${displayName} is ${name}`;
}

console.log(whois(user)); // "jdoe is Jane"
```

### Optional Paramm, Preserving Default values

```js
function drawChart({
  size = "big",
  coords = { x: 0, y: 0 },
  radius = 25,
} = {}) {
  console.log(size, coords, radius);
  // do some chart drawing
}

drawChart({
  coords: { x: 18, y: 30 },
  radius: 30,
})
```

### Optional Positional with defaults

[from](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Default_parameters#destructured_parameter_with_default_value_assignment)
```js
function preFilledArray( [x = 1, y = 2] = [] ) {
  return x + y;
}

preFilledArray() // 3
preFilledArray( [] ) // 3
preFilledArray( [2] ) // 4
preFilledArray( [2, 3] ) // 5

// Works the same for objects:
function preFilledObject( { z = 3 } = {} ) {
  return z
}
preFilledObject( ) // 3
preFilledObject({} ) // 3
preFilledObject({ z: 2 } ) // 2
```