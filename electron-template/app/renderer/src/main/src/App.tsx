import React, { useEffect, useState } from "react";
import logo from "./logo.svg";
import "./App.css";
const { ipcRenderer, remote } = window.require("electron");
const { Menu, MenuItem } = remote;

function App() {
  const [message, setMessage] = useState("");

  useEffect(() => {
    ipcRenderer.invoke("message", 1, 2, 3);
    ipcRenderer.on("reply", (_e: any, msg: string) => {
      console.log("on reply", msg);
      setMessage(msg);
    });
  }, []);

  const handleContextMenu = (e: any) => {
    e.preventDefault();
    const menu = new Menu();
    menu.append(new MenuItem({ label: "复制", role: "copy" }));
    // menu.append(
    //   new MenuItem({
    //     label: "分享到微信",
    //     click: (menuItem, win, keyboardEvent) => {
    //       ipcRenderer.send("share-to-wechat", 'localCode');
    //     },
    //   })
    // );
    menu.popup();
  };

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p onContextMenu={(e) => handleContextMenu(e)}>{message}</p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
