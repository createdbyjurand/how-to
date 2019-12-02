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







// ( new file path, old file path );
// fs.renameSync(`./${newFileName}`, `./${files[i]}`);

const fs = require('fs');

const readline = require('readline');

fs.readdir('./', (readdirError, files) => {
  if (readdirError) return console.error('[ FAILED ] ' + readdirError);

  for (let i = 0; i < files.length; i++) {
    if (files[i] !== files[i].toLowerCase()) {
      console.log(`[ RENAME ] (lowercase)   ${files[i]}   to   ${files[i].toLowerCase()}`);
      // fs.renameSync(`./${files[i].toLowerCase()}`, `./${files[i]}`);
      files[i] = files[i].toLowerCase();
    }

    if (files[i] !== files[i].split(' ').join('.')) {
      console.log(`[ RENAME ] (space)   ${files[i]}   to   ${files[i].split(' ').join('.')}`);
      // fs.renameSync(`./${files[i].split(' ').join('.')}`, `./${files[i]}`);
      files[i] = files[i].split(' ').join('.');
    }

    if (files[i].match(/^.*\.s\d\de\d\d\..*\.url$/)) {
      if (!files[i].match(/^.*\.s\d\de\d\d\..*\.z\.url$/)) {
        console.log(`[ RENAME ] (z)   ${files[i]}   to   ${files[i].slice(0, files[i].length - 4) + '.z.url'}`);
        // fs.renameSync(`./${files[i].slice(0, files[i].length - 4) + '.z.url'}`, `./${files[i]}`);
        files[i] = files[i].slice(0, files[i].length - 4) + '.z.url';
      }

      if (files[i].slice(0, files[i].search(/\.s\d\de\d\d\./)) === files[i + 1].slice(0, files[i + 1].search(/\.s\d\de\d\d\./))) {
        console.log('---------- URL RENAME START ----------');
        console.log(files[i]);
        console.log(files[i + 1]);
        console.log(files[i + 1].slice(0, files[i + 1].length - 4) + '.z.url   <-   ' + files[i]);
        console.log('----------  URL RENAME END  ----------');

        // TODO: ask user Y/n to rename file
        const rl = readline.createInterface({
          input: process.stdin,
          output: process.stdout
        });

        function readLineAsync(message) {
          return new Promise((resolve, reject) => {
            rl.question(message, (answer) => {
              resolve(answer);
            });
          });
        }

        // Leverages Node.js' awesome async/await functionality
        async function demoSynchronousPrompt(expenses) {
          var promptInput = await readLineAsync("Give me some input >");
          console.log("Won't be executed until promptInput is received", promptInput);
          rl.close();
        }



        const foo = event.onCall(async () => {
          // do something
        });

        const answer = async readline.question(`Rename?`, answer => {
          console.log(`Thank you for your valuable feedback: ${answer}`);
        });

        // fs.renameSync(`./${files[i + 1].slice(0, files[i + 1].length - 4) + '.z.url'}`, `./${files[i]}`);

        const tmp = files[i + 1].slice(0, files[i + 1].length - 4) + '.z.url';
        files[i] = files[i + 1];
        files[i + 1] = tmp;
      }
    }
  };
});






// Multiple async functions in series
// async functions can be chained very easily, and the syntax is much more readable than with plain promises:
// const promiseToDoSomething = () => {
//     return new Promise(resolve => {
//         setTimeout(() => resolve('I did something'), 10000)
//     })
// }
// const watchOverSomeoneDoingSomething = async () => {
//     const something = await promiseToDoSomething()
//     return something + ' and I watched'
// }
// const watchOverSomeoneWatchingSomeoneDoingSomething = async () => {
//     const something = await watchOverSomeoneDoingSomething()
//     return something + ' and I watched as well'
// }
// watchOverSomeoneWatchingSomeoneDoingSomething().then((res) => {
//     console.log(res)
// })
// Will print:
// I did something and I watched and I watched as well







// function removeAndExceptLine() {
//   process.stdin.removeListener('keypress', listener);
//   const rl = readline.createInterface({
//     input: process.stdin,
//     output: process.stdout
//   });
//   rl.on('line', async input => {
//     const city = input;
//     console.log(await getWeatherData(city));
//     rl.close();
//   });
// }






// const readline = require('readline');

// function askQuestion(query) {
//     const rl = readline.createInterface({
//         input: process.stdin,
//         output: process.stdout,
//     });

//     return new Promise(resolve => rl.question(query, ans => {
//         rl.close();
//         resolve(ans);
//     }))
// }


// const ans = await askQuestion("Are you sure you want to deploy to PRODUCTION? ");






// 'use strict'

// const readline = require('readline')

// const rl = readline.createInterface({
//   input: process.stdin,
//   output: process.stdout
// })

// const question1 = () => {
//   return new Promise((resolve, reject) => {
//     rl.question('q1 What do you think of Node.js? ', (answer) => {
//       console.log(`Thank you for your valuable feedback: ${answer}`)
//       resolve()
//     })
//   })
// }

// const question2 = () => {
//   return new Promise((resolve, reject) => {
//     rl.question('q2 What do you think of Node.js? ', (answer) => {
//       console.log(`Thank you for your valuable feedback: ${answer}`)
//       resolve()
//     })
//   })
// }

// const main = async () => {
//   await question1()
//   await question2()
//   rl.close()
// }

// main()
