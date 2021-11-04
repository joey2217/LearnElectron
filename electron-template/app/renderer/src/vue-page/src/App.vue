<template>
  <button @click="down">download</button>
  <ul>
    <li>
      <router-link to="/">Home</router-link>
    </li>
    <li>
      <router-link to="/about">About</router-link>
    </li>
  </ul>
  <h2>globalShortcut Demo</h2>
  <router-view />
  <h1 @contextmenu="onContextMenu">{{ msgRef }}</h1>
</template>

<script lang="ts">
import { defineComponent, ref } from "vue";
import mitter from "./utils/event";
const { ipcRenderer, remote } = window.require("electron");
const { Menu, MenuItem } = remote;

export default defineComponent({
  name: "App",
  components: {},
  setup() {
    const msgRef = ref("");
    ipcRenderer.invoke("message", 1, 2, 3);
    ipcRenderer.on("reply", (e, msg) => {
      console.log("on reply", msg);
      msgRef.value = msg;
    });
    ipcRenderer.on("cut", () => {
      mitter.emit("cut");
    });
    const onContextMenu = (e) => {
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
    return {
      msgRef,
      onContextMenu,
      down:()=>{
        ipcRenderer.invoke('down')
      }
    };
  },
});
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>

function ref(arg0: string) { throw new Error("Function not implemented."); }
