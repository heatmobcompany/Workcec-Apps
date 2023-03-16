const express = require('express');
const child_process = require('child_process')
require('dotenv').config()

const app = express();
const PORT = process.env.PORT ?? 5000;

const apps = [
    "Apps.ClamAV",
    "Apps.Jitsi",
    "rocket.chat.app-poll",
    "Rocket.Chat.App-Remind",
]

app.use(express.json());

app.get('/', (req, res)=>{
    res.status(200);
    res.send("Workcec apps: Nothing here!");
});

app.post('/install/apps', (req, res)=>{
    const {token, url, username, password} = req.body
    if (token != process.env.TOKEN) {
        res.status(200);
        res.send("Workcec apps: Invalid token!");
        return;
    }

    apps.forEach(app=> {
        install_app(__dirname + "/" + app, url, username, password);
    })

    res.status(200);
    res.send("Workcec apps: Successfully!");
});

app.listen(PORT, (error) =>{
    if(!error)
        console.log("Server is Successfully Running on port "+ PORT)
    else 
        console.log("Error occurred, server can't start", error);
    }
);

const install_app = async (app_path, url, username, password) => {
    console.log(`Installing ${url} - ${app_path}`);
    const installCmd = `cd ${app_path} && rc-apps deploy --url ${url} --username ${username} --password ${password}`
    try {
        let installOutput = child_process.execSync(installCmd).toString()
        console.log(`Output: \r ${installOutput}`);    
    } catch (e){
        console.log(`Output: App installed fail: ${e}`);
    }
}
