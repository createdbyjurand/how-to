// https://stackoverflow.com/questions/53981103/wait-for-user-input-from-readline-module-node-js

with callbacks
const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

exports.question = function(q , cb ){

    var response;

    rl.setPrompt(q);
    rl.prompt();

    rl.on('line', (userInput) => {
        response = userInput;
        rl.close();
    });

    rl.on('close', () => {
        return cb(response);
    });
};
you call it like this

var age  = arki.question("how old are you? ", resp => {
    console.log(resp);
});
with promises
const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

exports.question = function(q){

    var response;

    rl.setPrompt(q);
    rl.prompt();

    return new Promise(( resolve , reject) => {

        rl.on('line', (userInput) => {
            response = userInput;
            rl.close();
        });

        rl.on('close', () => {
            resolve(response);
        });

    });


};
you call it like this

arki.question("how old are you? ").then( response => console.log(response) );
or

; ( async () => {
    console.log(await arki.question("how old are you? "));
})();