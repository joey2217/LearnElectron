<template>
  <div class="container">
    <div
      class="row1"
      @mouseenter="mouseEnter('LEFT')"
      @mouseleave="mouseEnter('')"
    >
      1
    </div>
    <div
      class="row2"
      @mouseenter="mouseEnter('MID')"
      @mouseleave="mouseEnter('')"
    >
      2
    </div>
    <div
      class="row3"
      @mouseenter="mouseEnter('RIGHT')"
      @mouseleave="mouseEnter('')"
    >
      3
    </div>
  </div>
</template>

<script lang="ts">
import { computed, defineComponent } from "vue";
import { useStore } from "vuex";
import mitter from "../../utils/event";

export default defineComponent({
  name: "Home",
  setup(props, context) {
    const store = useStore();
    const area = computed(() => store.state.area);
    const mouseEnter = (area: string) => {
      store.commit("UPDATE_AREA", area);
    };
    mitter.on("cut", () => {
      console.log("on cut", area.value);
    });
    return {
      mouseEnter,
    };
  },
});
</script>

<style scoped>
.container {
  display: flex;
  height: 200px;
  background: #000;
  color: #fff;
}
.container > div {
  flex: 1;
}
.row1 {
  background: red;
}
.row2 {
  background: goldenrod;
}
.row3 {
  background: blue;
}
</style>